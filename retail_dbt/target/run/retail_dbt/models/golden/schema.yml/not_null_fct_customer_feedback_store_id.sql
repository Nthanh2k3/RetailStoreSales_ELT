
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select store_id
from "postgres"."silver_to_golden"."fct_customer_feedback"
where store_id is null



  
  
      
    ) dbt_internal_test