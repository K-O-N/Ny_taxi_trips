-- Create external table for yellow taxi data
CREATE OR REPLACE EXTERNAL TABLE dtc-trips.staging.ext_yellow_trips
OPTIONS (
 FORMAT = 'PARQUET',
 URIS= ['gs://ny-trips-dtc-bucket/yellow_tripdata_2019*.parquet',
        'gs://ny-trips-dtc-bucket/yellow_tripdata_2020*.parquet'
 ]
);


-- Create external table for yellow taxi data
CREATE OR REPLACE EXTERNAL TABLE dtc-trips.staging.ext_green_trips
OPTIONS (
 FORMAT = 'PARQUET',
 URIS= ['gs://ny-trips-dtc-bucket/green_tripdata_2020*.parquet',
        'gs://ny-trips-dtc-bucket/green_tripdata_2019*.parquet'
 ]
);


select count(*) from `dtc-trips.staging.ext_green_trips`;

select count(*) from `dtc-trips.staging.ext_yellow_trips`;
