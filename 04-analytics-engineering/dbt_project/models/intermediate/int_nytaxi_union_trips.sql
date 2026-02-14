with green_trips as (

    select *, 
           'green' as cab_color
    from {{ ref('stg_nytaxi__green_trips') }}  
       -- fix duplicates prioritise records with positive amount
),
yellow_trips as (

    select *, 
           'yellow' as cab_color
    from {{ ref('stg_nytaxi__yellow_trips') }}
    
),
final as (

    select * from green_trips
    union all
    select * from yellow_trips
)

select 
    tripid,
    vendorid,
    {{ get_vendor_name('vendorid') }} as vendor_name,
    ratecodeid,

    -- pickup 
    pickup_locationid,
    dl.borough as pickup_borough,
    dl.zone as pickup_zone,
    dl.service_zone as pickup_service_zone,

    -- dropodff
    dropoff_locationid,
    dl2.borough as dropoff_borough,
    dl2.zone as dropoff_zone,
    dl2.service_zone as dropoff_service_zone,

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
    payment_type,
    {{ get_payment_type_description("payment_type") }} as payment_type_desc,
    cab_color

from final f
left join {{ ref('int_trip_locations')}} as dl 
on f.pickup_locationid = dl.locationid
left join {{ ref('int_trip_locations')}} as dl2
on f.dropoff_locationid = dl2.locationid
-- noticed some duplicates - repeated trips data in yellow and green trips 
qualify row_number() over (partition by tripid order by total_amount desc, payment_type desc ) = 1
