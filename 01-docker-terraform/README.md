## Data Pipeline with Docker and PostgreSQL

- Containerize applications with Docker and Docker Compose
- Set up PostgreSQL databases and write SQL queries
- Build data pipelines to ingest NYC taxi data
- Provision cloud infrastructure with Terraform

### Docker
Docker is 








mkdir ny_taxi_postgres_data
```
docker run -it --rm\
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v ny_taxi_postgres_data:/var/lib/postgresql \
  -p 5432:5432 \
  postgres:18
```


```
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
```

```
  docker run -it --rm\
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v ny_taxi_postgres_data:/var/lib/postgresql \
    -p 5432:5432 \
    --network=pg-network \
    --name pgdatabase \
    postgres:18
```

run in another terminal run pgadmin in the same network
```
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -v pgadmin_data:/var/lib/pgadmin \
  -p 8085:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4
```

  http://localhost:8085



# check the network link:
docker network ls

# it's pipeline_default (or similar based on directory name)
# now run the script:
```
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
