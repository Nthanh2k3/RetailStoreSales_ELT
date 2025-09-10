
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."returns_silver"

where not(reason TRIM(reason) != '' AND reason NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test