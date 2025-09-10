
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."categories_silver"

where not(name TRIM(name) != '' AND name NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test