
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select feedback_id
from "postgres"."silver_to_golden"."fct_customer_feedback"
where feedback_id is null



  
  
      
    ) dbt_internal_test