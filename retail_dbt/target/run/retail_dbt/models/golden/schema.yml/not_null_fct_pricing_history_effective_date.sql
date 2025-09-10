
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select effective_date
from "postgres"."silver_to_golden"."fct_pricing_history"
where effective_date is null



  
  
      
    ) dbt_internal_test