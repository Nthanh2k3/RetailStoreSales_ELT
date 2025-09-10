
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select manager_id
from "postgres"."silver"."stores_silver"
where manager_id is null



  
  
      
    ) dbt_internal_test