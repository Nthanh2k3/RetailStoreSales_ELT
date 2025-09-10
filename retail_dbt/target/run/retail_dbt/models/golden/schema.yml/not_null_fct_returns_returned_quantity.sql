
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select returned_quantity
from "postgres"."silver_to_golden"."fct_returns"
where returned_quantity is null



  
  
      
    ) dbt_internal_test