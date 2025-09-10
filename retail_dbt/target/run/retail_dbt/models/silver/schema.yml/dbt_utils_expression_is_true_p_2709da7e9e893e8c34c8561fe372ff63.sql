
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."products_silver"

where not(season TRIM(season) != '' AND season NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test