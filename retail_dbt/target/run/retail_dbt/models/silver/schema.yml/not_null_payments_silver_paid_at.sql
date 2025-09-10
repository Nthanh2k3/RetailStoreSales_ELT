
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select paid_at
from "postgres"."silver"."payments_silver"
where paid_at is null



  
  
      
    ) dbt_internal_test