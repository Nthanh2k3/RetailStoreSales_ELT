
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_day
from "postgres"."silver_to_golden"."fct_purchase_orders"
where order_day is null



  
  
      
    ) dbt_internal_test