
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select history_id
from "postgres"."silver"."pricing_history_silver"
where history_id is null



  
  
      
    ) dbt_internal_test