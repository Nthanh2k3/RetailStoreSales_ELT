
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."employees_silver"

where not(role TRIM(role) != '' AND role NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test