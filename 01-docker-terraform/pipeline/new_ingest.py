import os
import click 
import requests
import pyarrow.parquet as pq
import pandas as pd
from sqlalchemy import create_engine
from tqdm import tqdm

@click.command()
@click.option('--pg-user', default='root', help='PostgreSQL username')
@click.option('--pg-pass', default='root', help='PostgreSQL password')
@click.option('--pg-host', default='localhost', help='PostgreSQL host')
@click.option('--pg-db', default='ny_taxi', help='PostgreSQL database name')
@click.option('--pg-port', default=5432, type=int, help='PostgreSQL port')



def ingest_all(pg_user, pg_pass, pg_host, pg_db, pg_port):

    PARQUET_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet"
    CSV_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"

    PARQUET_FILE = "green_tripdata_2025-11.parquet"
    CSV_FILE = "taxi_zone_lookup.csv"

    READ_BATCH_SIZE = 100_000     # rows read from parquet
    INSERT_CHUNK_SIZE = 10_000    # rows per SQL insert


    # Postgres connection
    engine = create_engine(
        f'postgresql://{pg_user}:{pg_pass}@{pg_host}:{pg_port}/{pg_db}')
    


    # Download Parquet
    if not os.path.exists(PARQUET_FILE):
        print("Downloading parquet file...")
        headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"}
        with requests.get(PARQUET_URL, headers=headers, stream=True) as r:
            r.raise_for_status()
            with open(PARQUET_FILE, "wb") as f:
                for chunk in r.iter_content(8192):
                    f.write(chunk)
        print("Parquet download complete")

 
    # Ingest Parquet 
    print("Ingesting parquet into green_taxi_data...")
    parquet_file = pq.ParquetFile(PARQUET_FILE)

    first_batch = True
    for batch in tqdm(parquet_file.iter_batches(batch_size=READ_BATCH_SIZE)):
        df_chunk = batch.to_pandas()

        df_chunk.to_sql(
            name="green_taxi_data",
            con=engine,
            if_exists="replace" if first_batch else "append",
            index=False,
            method="multi",
            chunksize=INSERT_CHUNK_SIZE,
        )

        first_batch = False

    print("green_taxi_data ingestion complete")

    # Download CSV
    if not os.path.exists(CSV_FILE):
        print("Downloading taxi zone lookup CSV...")
        df_zones = pd.read_csv(CSV_URL)
        df_zones.to_csv(CSV_FILE, index=False)
    else:
        df_zones = pd.read_csv(CSV_FILE)

    
    # Ingest CSV
    print("Ingesting taxi_zone_lookup...")
    df_zones.to_sql(
        name="taxi_zone_lookup",
        con=engine,
        if_exists="replace",
        index=False,
        method="multi",
        chunksize=INSERT_CHUNK_SIZE,
    )

    print("taxi_zone_lookup ingestion complete")
    print("All ingestion finished successfully")


if __name__ == "__main__":
    ingest_all()
