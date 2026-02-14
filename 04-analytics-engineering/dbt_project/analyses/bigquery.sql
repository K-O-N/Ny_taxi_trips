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


-- Create external table for fhv taxi data
CREATE OR REPLACE EXTERNAL TABLE `dtc-trips.staging.ext_fhv_trips`
OPTIONS (
  format = 'CSV',
  uris = ['gs://ny-trips-dtc-bucket/fhv_tripdata_2019*.csv'],
  skip_leading_rows = 1
);


select count(*) from `dtc-trips.staging.ext_green_trips`;

select count(*) from `dtc-trips.staging.ext_yellow_trips`;
