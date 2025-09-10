
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select campaign_id
from "postgres"."silver"."campaigns_silver"
where campaign_id is null



  
  
      
    ) dbt_internal_test