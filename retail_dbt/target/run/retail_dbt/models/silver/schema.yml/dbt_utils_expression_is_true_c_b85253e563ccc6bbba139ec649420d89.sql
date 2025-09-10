
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."customer_feedback_silver"

where not(comments TRIM(comments) != '' AND comments NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test