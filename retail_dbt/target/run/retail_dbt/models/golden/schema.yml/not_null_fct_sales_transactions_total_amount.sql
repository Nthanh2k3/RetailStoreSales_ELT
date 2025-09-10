
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_amount
from "postgres"."silver_to_golden"."fct_sales_transactions"
where total_amount is null



  
  
      
    ) dbt_internal_test