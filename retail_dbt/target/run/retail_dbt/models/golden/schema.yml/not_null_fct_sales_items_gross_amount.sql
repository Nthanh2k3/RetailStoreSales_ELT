
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select gross_amount
from "postgres"."silver_to_golden"."fct_sales_items"
where gross_amount is null



  
  
      
    ) dbt_internal_test