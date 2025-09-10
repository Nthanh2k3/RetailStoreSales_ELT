
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_name
from "postgres"."silver_to_golden"."fct_customer_feedback"
where customer_name is null



  
  
      
    ) dbt_internal_test