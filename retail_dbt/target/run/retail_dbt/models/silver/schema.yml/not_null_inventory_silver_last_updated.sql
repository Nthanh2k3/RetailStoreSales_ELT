
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select last_updated
from "postgres"."silver"."inventory_silver"
where last_updated is null



  
  
      
    ) dbt_internal_test