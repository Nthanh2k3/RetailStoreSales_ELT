
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."sales_items_silver"

where not(business_validation_flag TRIM(business_validation_flag) != '' AND business_validation_flag NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test