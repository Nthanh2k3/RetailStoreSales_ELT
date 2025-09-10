
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select employee_name
from "postgres"."silver_to_golden"."fct_sales_transactions"
where employee_name is null



  
  
      
    ) dbt_internal_test