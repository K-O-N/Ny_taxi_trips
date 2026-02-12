with trips_union as (

    select * from {{ ref('int_nytaxi_union_trips')}}

)

select 
      distinct vendorid,
      vendor_name
      
from trips_union


