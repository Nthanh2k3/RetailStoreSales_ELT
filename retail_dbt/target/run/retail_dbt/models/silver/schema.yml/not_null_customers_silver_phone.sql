
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select phone
from "postgres"."silver"."customers_silver"
where phone is null



  
  
      
    ) dbt_internal_test