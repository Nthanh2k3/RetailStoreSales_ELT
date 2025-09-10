
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select return_date
from "postgres"."silver"."returns_silver"
where return_date is null



  
  
      
    ) dbt_internal_test