
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select last_updated
from "postgres"."silver_to_golden"."fct_inventory"
where last_updated is null



  
  
      
    ) dbt_internal_test