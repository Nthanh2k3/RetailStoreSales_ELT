
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select transaction_year
from "postgres"."silver_to_golden"."fct_sales_items"
where transaction_year is null



  
  
      
    ) dbt_internal_test