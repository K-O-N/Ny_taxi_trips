with trips_union as (

    select * from {{ ref('int_nytaxi_union_trips')}}

)

select 
    tripid,
    vendorid,
    ratecodeid,

    -- pickup 
    pickup_locationid,
    pickup_borough,
    pickup_zone,
    pickup_service_zone,

    -- dropodff
    dropoff_locationid,
    dropoff_borough,
    dropoff_zone,
    dropoff_service_zone,

    pickup_datetime,
    dropoff_datetime,
    store_and_fwd_flag,
    passenger_count,
    trip_distance,
    trip_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    total_amount,
    improvement_surcharge,
    congestion_surcharge,
    payment_type_desc,
    cab_color
      
from trips_union