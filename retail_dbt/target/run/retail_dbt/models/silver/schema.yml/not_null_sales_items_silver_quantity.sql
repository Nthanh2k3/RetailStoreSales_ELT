
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select quantity
from "postgres"."silver"."sales_items_silver"
where quantity is null



  
  
      
    ) dbt_internal_test