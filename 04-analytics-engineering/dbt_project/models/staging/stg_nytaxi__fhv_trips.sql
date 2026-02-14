with fhv_trips as (
    select * from {{ source('nytaxi_trips', 'ext_fhv_trips') }}
    where dispatching_base_num IS NOT NULL
    
)

select 
      dispatching_base_num,
      pickup_datetime,  
      dropoff_datetime,
      PULocationID as pickup_locationid,
      DOLocationID as dropoff_locationid,
      SR_Flag as store_and_fwd_flag,
      Affiliated_base_number
from fhv_trips
