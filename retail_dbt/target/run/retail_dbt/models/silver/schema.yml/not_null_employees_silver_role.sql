
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select role
from "postgres"."silver"."employees_silver"
where role is null



  
  
      
    ) dbt_internal_test