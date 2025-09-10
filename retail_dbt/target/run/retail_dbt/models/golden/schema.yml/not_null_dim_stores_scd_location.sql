
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select location
from "postgres"."silver_to_golden"."dim_stores_scd"
where location is null



  
  
      
    ) dbt_internal_test