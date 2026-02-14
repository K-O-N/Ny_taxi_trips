with daily as (
    select 
        date_trunc(
            cast(pickup_datetime as timestamp),
            day
        ) as date_daily,
        cab_color,
        sum(passenger_count) as daily_users
    from {{ ref('int_nytaxi_union_trips') }}
    group by 1,2
)
select  date_daily,
        cab_color,
        daily_users
from daily
order by date_daily asc