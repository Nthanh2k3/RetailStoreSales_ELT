
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_id
from "postgres"."silver_to_golden"."fct_returns"
where customer_id is null



  
  
      
    ) dbt_internal_test