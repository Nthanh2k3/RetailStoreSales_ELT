
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select supplier_name
from "postgres"."silver_to_golden"."fct_purchase_orders"
where supplier_name is null



  
  
      
    ) dbt_internal_test