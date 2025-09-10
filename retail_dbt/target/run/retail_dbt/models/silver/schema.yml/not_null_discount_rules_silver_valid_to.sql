
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select valid_to
from "postgres"."silver"."discount_rules_silver"
where valid_to is null



  
  
      
    ) dbt_internal_test