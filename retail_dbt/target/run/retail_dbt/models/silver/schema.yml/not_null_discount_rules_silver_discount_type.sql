
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select discount_type
from "postgres"."silver"."discount_rules_silver"
where discount_type is null



  
  
      
    ) dbt_internal_test