-- Create external tablE in new schema pt
CREATE SCHEMA `dtc-trips.staging`
OPTIONS (
  location = "EU"
);


-- Create external table for yellow taxi data
CREATE OR REPLACE EXTERNAL TABLE dtc-trips.staging.external_yellow_data
OPTIONS (
 FORMAT = 'PARQUET',
 URIS= ['gs://ny-trips-dtc-bucket/yellow*.parquet']
);

-- Create regular materialised table for yellow taxi data
CREATE OR REPLACE TABLE `dtc-trips.staging.regular_yellow_data` AS
SELECT * FROM `dtc-trips.staging.external_yellow_data`;


-- Record count 2024 Yellow Taxi Data
SELECT count(*) FROM `dtc-trips.staging.external_yellow_data`;


-- Estimated amount of data read
SELECT Count(distinct  PULocationID) FROM `dtc-trips.staging.external_yellow_data`;
SELECT Count(distinct  PULocationID) FROM `dtc-trips.staging.regular_yellow_data`;


-- Columnar Storage
SELECT  PULocationID, DOLocationID FROM `dtc-trips.staging.regular_yellow_data`;


-- Fare Amount 0
SELECT  count(*) FROM `dtc-trips.staging.regular_yellow_data` where fare_amount=0;


-- Create a partitioned and clustered table
CREATE OR REPLACE TABLE `dtc-trips.staging.partition_yellow_data` 
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `dtc-trips.staging.external_yellow_data`;


-- Non-Partitioned Table - Retrieve VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15
SELECT  DISTINCT VendorID FROM `dtc-trips.staging.regular_yellow_data` 
WHERE DATE(tpep_dropoff_datetime) >= '2024-03-01' and DATE(tpep_dropoff_datetime) <= '2024-03-15' ;


-- Partitioned Table - Retrieve VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15
SELECT  DISTINCT VendorID FROM `dtc-trips.staging.partition_yellow_data` 
WHERE DATE(tpep_dropoff_datetime) >= '2024-03-01' and DATE(tpep_dropoff_datetime) <= '2024-03-15' ;


-- Materilised table bytes read
SELECT  count(*) FROM `dtc-trips.staging.regular_yellow_data`;
