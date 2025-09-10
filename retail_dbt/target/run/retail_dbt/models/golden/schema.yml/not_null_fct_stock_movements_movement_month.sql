
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select movement_month
from "postgres"."silver_to_golden"."fct_stock_movements"
where movement_month is null



  
  
      
    ) dbt_internal_test