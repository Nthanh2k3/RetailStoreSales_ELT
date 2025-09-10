
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select comments
from "postgres"."silver"."customer_feedback_silver"
where comments is null



  
  
      
    ) dbt_internal_test