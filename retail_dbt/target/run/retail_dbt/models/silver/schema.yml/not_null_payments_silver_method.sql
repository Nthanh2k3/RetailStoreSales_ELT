
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select method
from "postgres"."silver"."payments_silver"
where method is null



  
  
      
    ) dbt_internal_test