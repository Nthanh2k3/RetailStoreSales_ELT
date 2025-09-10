
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select business_validation_flag
from "postgres"."silver"."sales_items_silver"
where business_validation_flag is null



  
  
      
    ) dbt_internal_test