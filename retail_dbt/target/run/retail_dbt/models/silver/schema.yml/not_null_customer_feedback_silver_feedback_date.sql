
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select feedback_date
from "postgres"."silver"."customer_feedback_silver"
where feedback_date is null



  
  
      
    ) dbt_internal_test