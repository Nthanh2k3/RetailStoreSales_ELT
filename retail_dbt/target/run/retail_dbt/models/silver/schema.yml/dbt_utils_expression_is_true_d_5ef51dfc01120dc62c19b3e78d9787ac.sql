
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."discount_rules_silver"

where not(discount_type TRIM(discount_type) != '' AND discount_type NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test