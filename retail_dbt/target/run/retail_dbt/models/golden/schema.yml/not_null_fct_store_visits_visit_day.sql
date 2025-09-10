
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select visit_day
from "postgres"."silver_to_golden"."fct_store_visits"
where visit_day is null



  
  
      
    ) dbt_internal_test