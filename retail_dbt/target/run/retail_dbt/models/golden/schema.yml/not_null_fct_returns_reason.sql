
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select reason
from "postgres"."silver_to_golden"."fct_returns"
where reason is null



  
  
      
    ) dbt_internal_test