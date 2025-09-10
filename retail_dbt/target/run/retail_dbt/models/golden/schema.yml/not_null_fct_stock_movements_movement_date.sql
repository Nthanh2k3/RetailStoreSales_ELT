
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select movement_date
from "postgres"."silver_to_golden"."fct_stock_movements"
where movement_date is null



  
  
      
    ) dbt_internal_test