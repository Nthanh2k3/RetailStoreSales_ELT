
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select promotion_id
from "postgres"."silver"."promotions_silver"
where promotion_id is null



  
  
      
    ) dbt_internal_test