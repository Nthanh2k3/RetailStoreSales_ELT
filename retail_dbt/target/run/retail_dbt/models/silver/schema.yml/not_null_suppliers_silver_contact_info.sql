
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select contact_info
from "postgres"."silver"."suppliers_silver"
where contact_info is null



  
  
      
    ) dbt_internal_test