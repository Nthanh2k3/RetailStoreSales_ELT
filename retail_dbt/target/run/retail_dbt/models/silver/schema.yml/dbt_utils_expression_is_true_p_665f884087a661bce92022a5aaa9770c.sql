
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."payments_silver"

where not(status TRIM(status) != '' AND status NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test