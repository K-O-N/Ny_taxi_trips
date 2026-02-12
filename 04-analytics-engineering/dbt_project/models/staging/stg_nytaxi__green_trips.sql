with green_trips as (
    select * from {{ source('nytaxi_trips', 'ext_green_trips') }}
    where vendorid is not null 
    
)

select 
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['vendorid', 'PULocationID', 'DOLocationID', 'lpep_pickup_datetime', 'lpep_dropoff_datetime']) }} as tripid,
    {{ dbt.safe_cast("vendorid", api.Column.translate_type("integer")) }} as vendorid,
    {{ dbt.safe_cast("ratecodeid", api.Column.translate_type("integer")) }} as ratecodeid,
    {{ dbt.safe_cast("PULocationID", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("DOLocationID", api.Column.translate_type("integer")) }} as dropoff_locationid,

    
    -- timestamps
    FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', DATETIME(TIMESTAMP(lpep_pickup_datetime))) as pickup_datetime,
    FORMAT_DATETIME('%Y-%m-%d %H:%M:%S', DATETIME(TIMESTAMP(lpep_dropoff_datetime))) as dropoff_datetime,
    
    -- trip info
    store_and_fwd_flag,
    {{ dbt.safe_cast("passenger_count", api.Column.translate_type("integer")) }} as passenger_count,
    cast(trip_distance as numeric) as trip_distance,
    {{ dbt.safe_cast("trip_type", api.Column.translate_type("integer")) }} as trip_type,
    

    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(total_amount as numeric) as total_amount,
    cast(improvement_surcharge as numeric) as improvement_surcharge,
    cast(congestion_surcharge as numeric) as congestion_surcharge,
    coalesce({{ dbt.safe_cast("payment_type", api.Column.translate_type("integer")) }},0) as payment_type
    

from green_trips
