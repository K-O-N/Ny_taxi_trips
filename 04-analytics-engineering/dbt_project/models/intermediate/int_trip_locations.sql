with locations as (

    select 
        locationid,
        borough,
        zone,
        service_zone
    from {{ ref('taxi_zones') }}
)
select * 
from locations