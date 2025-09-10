
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select staged_at
from "postgres"."silver_to_golden"."dim_campaigns"
where staged_at is null



  
  
      
    ) dbt_internal_test