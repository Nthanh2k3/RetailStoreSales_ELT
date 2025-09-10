
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select tax_id
from "postgres"."silver"."tax_rules_silver"
where tax_id is null



  
  
      
    ) dbt_internal_test