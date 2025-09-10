
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category_name
from "postgres"."silver_to_golden"."fct_sales_items"
where category_name is null



  
  
      
    ) dbt_internal_test