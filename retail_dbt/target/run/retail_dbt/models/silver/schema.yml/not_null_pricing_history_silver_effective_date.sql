
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select effective_date
from "postgres"."silver"."pricing_history_silver"
where effective_date is null



  
  
      
    ) dbt_internal_test