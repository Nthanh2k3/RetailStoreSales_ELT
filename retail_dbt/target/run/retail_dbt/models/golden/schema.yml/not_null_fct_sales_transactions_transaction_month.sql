
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select transaction_month
from "postgres"."silver_to_golden"."fct_sales_transactions"
where transaction_month is null



  
  
      
    ) dbt_internal_test