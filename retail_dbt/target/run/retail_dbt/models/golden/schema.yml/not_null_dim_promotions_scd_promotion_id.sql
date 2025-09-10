
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select promotion_id
from "postgres"."silver_to_golden"."dim_promotions_scd"
where promotion_id is null



  
  
      
    ) dbt_internal_test