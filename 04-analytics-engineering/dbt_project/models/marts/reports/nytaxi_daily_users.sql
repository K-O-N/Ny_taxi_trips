with daily as (
    select 
        date_trunc(
            cast(pickup_datetime as timestamp),
            day
        ) as date_daily,
        sum(passenger_count) as daily_users
    from {{ ref('int_nytaxi_union_trips') }}
    group by 1
)
select  date_daily,
        daily_users
from daily
order by date_daily asc