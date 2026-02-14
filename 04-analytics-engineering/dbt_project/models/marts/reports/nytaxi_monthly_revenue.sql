with monthly_revenue as (
    select 
        date_trunc(
            cast(pickup_datetime as timestamp),
            month
        ) as month,
        cab_color,
        sum(total_amount) as total_revenue
    from {{ ref('int_nytaxi_union_trips') }}
    group by 1,2
)

select 
    month,
    cab_color,
    total_revenue
    
from monthly_revenue
order by month asc