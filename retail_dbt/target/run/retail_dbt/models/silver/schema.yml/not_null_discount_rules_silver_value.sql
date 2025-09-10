
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select value
from "postgres"."silver"."discount_rules_silver"
where value is null



  
  
      
    ) dbt_internal_test