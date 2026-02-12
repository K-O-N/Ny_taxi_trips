with locations as (

    select *
    from {{ ref('int_trip_locations') }}
)
select 
    locationid,
    borough,
    zone,
    service_zone
from locations