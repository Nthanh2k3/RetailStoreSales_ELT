
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."customers_silver"

where not(phone TRIM(phone) != '' AND phone NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test