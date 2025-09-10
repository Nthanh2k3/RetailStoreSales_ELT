
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select item_id
from "postgres"."silver"."returns_silver"
where item_id is null



  
  
      
    ) dbt_internal_test