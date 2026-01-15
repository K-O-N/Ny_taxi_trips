## Data Pipeline with Docker and PostgreSQL

- Containerize applications with Docker and Docker Compose
- Set up PostgreSQL databases and write SQL queries
- Build data pipelines to ingest NYC taxi data
- Provision cloud infrastructure with Terraform

### Docker
Docker is containerisation software. It makes it easy to run applications in isolation from your local computer. Pretty much like a virtual machine.
- A docker image is a snapshot of a container, that we can define to run specific softwares. 
- A docker container is a running image. It is stateless - meaning the previous state is not preserved. Well, not exactly.


###### Useful commands for this project
```
docker run -it python:3.13.11    -- python is the image, followed the tag/version

# You can overide the entrypoint of your image using entrypoint. rm removed the container afterwards
docker run -it --rm entrypoint=bash python:3.13.11

#shows all docker exited helps if you want to resume interaction (not stateless anymore)
docker ps -a

# gives all the container ids                
docker ps -aq

# deletes all container ids listed          
docker rm `docker ps -aq`
```

For this project, I made use of uv instead of pip
```
pip install uv

uv run which python  # Python in the virtual environment
uv run python -V

which python        # System Python
python -V

# Now initialize a Python project with uv. This creates a pyproject.toml file for managing dependencies and a .python-version file
uv init --python=3.13

uv add pandas pyarrow
```

### Docker Container State Preservation
To preserve state, use a dockerfile, starting the base image, dependencies, current working directory, etc
```
FROM python:3.13.11-slim 
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/

WORKDIR /code 
ENV PATH="/code/.venv/bin:$PATH"

COPY pyproject.toml .python-version uv.lock ./
RUN uv sync --locked

COPY ingest_data.py .

ENTRYPOINT ["python", "ingest_data.py" ]
```

### Run PostgreSQL in a Container
create a folder you would like postgres to store data. 
```
mkdir ny_taxi_postgres_data

docker run -it --rm\
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v ny_taxi_postgres_data:/var/lib/postgresql \
  -p 5432:5432 \
  postgres:18
```
###### Variables Defined 
- -e sets the enviroment variables (user, password, db name)
- -v is used to map the volumn. Docker manages this volume automatically, Data persist even after container is removed
- -p 5432:5432 maps port 5432 from container to host
- postgres:18 uses PostgreSQL version 16
  
> To connect to the postgres db, open a new termininal
```
# Install pgcli: the --dev extension installs the variable in dev :( see project.toml file
uv add --dev pgcli

uv run pgcli -h localhost -p 5432 -u root -d ny_taxi
```
Variables Explained
- uv run executes a command in the context of the virtual environment
- -h is the host. Since we're running locally we can use localhost.
- -p is the port.
- -u is the username.
- -d is the database name.
- - The password is not provided

### Setting up Jupyter
```
# Install jupyter in dev
uv add --dev jupyter

# open jupyter notebook
uv run jupyter notebook

# On the notebook
import pandas
install sqlalchemy psycopg2-binary 

# Create Database Connection
from sqlalchemy import create_engine
engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')

# Get DDL Schema
print(pd.io.sql.get_schema(df, name='yellow_taxi_data', con=engine))

# create table
df.head(n=0).to_sql(name='yellow_taxi_data', con=engine, if_exists='replace')

# Ingest data into postgres in chunks see notebook.ipynb
# Run this on your terminal to convert your notebook to a python script
uv run jupyter nbconvert --to=script notebook.ipynb
```
### Click Integration
Using copilot as an agent I asked it to make this params configurable using commandline interface using click. See results in ingest_data.py
Use the following to run the script ingest_data.py after the script is converted to a command line interface

```
# nb if you run
uv run python ingest_data.py    - the default script is ran.

# This is best if you would like to download multiple files -update as needed
uv run python ingest_data.py \
--pg-user root \
--pg-pass root \
--pg-host localhost \
--pg-db ny_taxi \
--pg-port 5432 \
--year 2021 \
--month 01 \
--chunksize 100000 \
--table yellow_taxi_data
```

### Interact with postgres using PgAdmin
To do this, first we create a network that all three containers that access 
```
Let's create a virtual Docker network called pg-network:
docker network create pg-network
```

### Run Containers on the Same Network
Stop both containers and re-run them with the network configuration:
```
  docker run -it --rm \
    --network=pg-network \
    taxi_ingest:v001 \
      --pg-user root \
      --pg-pass root \
      --pg-host pgdatabase \
      --pg-port 5432 \
      --pg-db ny_taxi \
      --chunksize 100000 \
      --table yellow_taxi_data

# Run PostgreSQL on the network
  docker run -it --rm\
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v ny_taxi_postgres_data:/var/lib/postgresql \
    -p 5432:5432 \
    --network=pg-network \
    --name pgdatabase \
    postgres:18

# run in another terminal run pgadmin in the same network
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -v pgadmin_data:/var/lib/pgadmin \
  -p 8085:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4
```

### Access PgAdmin
You should now be able to load pgAdmin on a web browser by browsing to http://localhost:8085. Use the same email and password you used for running the container to log in.

- Open browser and go to http://localhost:8085
- Login with email: admin@admin.com, password: root
- Right-click "Servers" → Register → Server
- Configure:
  1. General tab: Name: Local Docker
  2. Connection tab:
     - Host: pgdatabase (the container name)
     - Port: 5432
     - Username: root
     - Password: root
- Save. Now you can explore and query data

## Dockerizing the Ingestion Script
Using all three scripts, create the docker-compose file. Update the docker file that has been created before for a mini pipeline, replace and copy ingest_data.py into yml file and replace entry point to ingest_data.py. 
check the network link using ```docker network ls ``` as network isnt specified in the dockerfile. Typically folder name _ default (since it was not specified. In my case ``` pipeline_default```

### Build run the script:
```
# Build the new docker image
cd pipeline
docker build -t taxi_ingest:v001 .

# start the container 
docker compose up

# stop the container 
docker compose down

# Since we did not specify the table and other details, use the following script to run the ingestion script, and ingest data into postgresql, use pgadmin to access and view data
docker run -it \
  --network=pipeline_default \
  taxi_ingest:v001 \
    --pg-user=root \
    --pg-pass=root \
    --pg-host=pgdatabase \
    --pg-port=5432 \
    --pg-db=ny_taxi \
    --table=yellow_taxi_trips
```

#### Side notes
This can be used in replacement to the docker-compose file specifying all the requirements and then, the container can fully start using ``` docker compose up```

```
version: "3.9"

services:
  pgdatabase:
    image: postgres:18
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: root
      POSTGRES_DB: ny_taxi
    volumes:
      - ny_taxi_postgres_data:/var/lib/postgresql
    ports:
      - "5432:5432"
    networks:
      - pg-network

  pgadmin:
    image: dpage/pgadmin4
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@admin.com
      PGADMIN_DEFAULT_PASSWORD: root
    volumes:
      - pgadmin_data:/var/lib/pgadmin
    ports:
      - "8085:80"

  taxi_ingest:
    image: taxi_ingest:v001
    command: >
      --pg-user root
      --pg-pass root
      --pg-host pgdatabase
      --pg-port 5432
      --pg-db ny_taxi
      --chunksize 100000
      --table yellow_taxi_data

volumes:
  ny_taxi_postgres_data:
  pgadmin_data:

networks:
  pg-network:
```
