
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."tax_rules_silver"

where not(region TRIM(region) != '' AND region NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test