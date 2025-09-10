
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select movement_id
from "postgres"."silver"."stock_movements_silver"
where movement_id is null



  
  
      
    ) dbt_internal_test