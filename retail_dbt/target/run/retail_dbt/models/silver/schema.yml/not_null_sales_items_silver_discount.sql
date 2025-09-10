
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select discount
from "postgres"."silver"."sales_items_silver"
where discount is null



  
  
      
    ) dbt_internal_test