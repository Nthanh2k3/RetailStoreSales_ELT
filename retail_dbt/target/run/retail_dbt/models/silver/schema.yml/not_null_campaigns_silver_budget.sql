
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select budget
from "postgres"."silver"."campaigns_silver"
where budget is null



  
  
      
    ) dbt_internal_test