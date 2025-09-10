
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select shipped_date
from "postgres"."silver"."shipments_silver"
where shipped_date is null



  
  
      
    ) dbt_internal_test