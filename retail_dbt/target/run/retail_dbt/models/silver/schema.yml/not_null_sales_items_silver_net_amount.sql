
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select net_amount
from "postgres"."silver"."sales_items_silver"
where net_amount is null



  
  
      
    ) dbt_internal_test