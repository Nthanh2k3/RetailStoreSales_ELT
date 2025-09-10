
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."customers_silver"

where not(email TRIM(email) != '' AND email NOT ILIKE '%N/A%' AND email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[A-Za-z]{2,}$')


  
  
      
    ) dbt_internal_test