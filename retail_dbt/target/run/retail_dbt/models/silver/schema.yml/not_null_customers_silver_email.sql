
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select email
from "postgres"."silver"."customers_silver"
where email is null



  
  
      
    ) dbt_internal_test