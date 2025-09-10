
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."suppliers_silver"

where not(contact_info TRIM(contact_info) != '' AND contact_info NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test