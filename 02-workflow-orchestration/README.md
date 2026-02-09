# Data Orchestration Using Kestra

- Download Kestra Image Using Docker
- Run Kestra and Postgres
- Orchestrate Data Pipeline on GCP using Kestra flows

Kestra is a workflow orchestrator that 
- Runs workflows that contains certain predefined tasks
- Monitor and lof errors
- Automatically run workflows based on schedules

Kestra is an open-source orchestration platform that enables engineers to manage busines critical workflows. 

## Getting Started
Install docker using docker compose file here: https://github.com/K-O-N/Ny_taxi_trips/blob/main/02-workflow-orchestration/images/docker-compose.yml

```
-- download and start the kestra container
docker compose up
```
Once the container starts, you can access Kestra via the port specified http://localhost:8080

```
-- shut bdown the container 
docker compose down
```
### Kestra Components: 
- Flows: Flows are yaml files in kestra that specifies the task, their excution order, inputs, outputs, and orchestration logic
- Task: these are the steps within the flow. They indiacte different actions and produce results in teh form of outputs
- Triggers: This acutomatically starts the excution of a flow
- Execution:  a single run of a flow with a specific flow

### Setting Up GCP for data pipelines in Kestra
- first, make a directory having the google credentials
- run this to encode your files:  base64 -w 0 google_credentials.json
- crearte a .env file in the same folder as your docker-compose.yml with the following
- SECRET_GCP_CREDS=your_base64_encoded_string_here
- Then, in your docker-compose.yml, add the following line to the kestra environment variables:
```
SECRET_GCP_CREDS: ${SECRET_GCP_CREDS}
```
- to set up Kestra for GCP, we need to set up the Google Cloud Platform. Adjust the following flow https://github.com/K-O-N/Ny_taxi_trips/blob/main/02-workflow-orchestration/flows/gcp_setup_one.yaml  to include your service account, GCP project ID, BigQuery dataset and GCS bucket name (along with their location) as KV Store values:
* GCP_PROJECT_ID
* GCP_LOCATION
* GCP_BUCKET_NAME
* GCP_DATASET

## Data Pipeline 
Using Kestra schedule and Backfill, I built data pipelines to extract, transform and load data into postgres and Google BigQuery. 
Find flows in the flows folder

