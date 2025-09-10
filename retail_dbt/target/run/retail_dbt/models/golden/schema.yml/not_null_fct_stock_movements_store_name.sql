
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select store_name
from "postgres"."silver_to_golden"."fct_stock_movements"
where store_name is null



  
  
      
    ) dbt_internal_test