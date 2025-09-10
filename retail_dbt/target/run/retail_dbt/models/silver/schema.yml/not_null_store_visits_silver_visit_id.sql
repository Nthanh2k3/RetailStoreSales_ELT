
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select visit_id
from "postgres"."silver"."store_visits_silver"
where visit_id is null



  
  
      
    ) dbt_internal_test