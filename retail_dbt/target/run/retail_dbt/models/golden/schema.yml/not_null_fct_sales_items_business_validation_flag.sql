
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select business_validation_flag
from "postgres"."silver_to_golden"."fct_sales_items"
where business_validation_flag is null



  
  
      
    ) dbt_internal_test