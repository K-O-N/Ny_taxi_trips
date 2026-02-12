with trips_union as (

    select 
         distinct payment_type,
         payment_type_desc
    from {{ ref('int_nytaxi_union_trips')}}

)

select
      *
from trips_union

