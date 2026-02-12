with zones_revenue as (
    select 
        date_trunc(
            cast(pickup_datetime as timestamp),
            month
        ) as month,
        pickup_zone as zones,
        sum(total_amount) as total_revenue
    from {{ ref('int_nytaxi_union_trips') }}
    group by 1,2
)

select 
    month,
    zones,
    total_revenue
from zones_revenue