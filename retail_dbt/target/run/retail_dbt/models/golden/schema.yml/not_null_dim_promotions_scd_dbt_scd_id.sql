
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select dbt_scd_id
from "postgres"."silver_to_golden"."dim_promotions_scd"
where dbt_scd_id is null



  
  
      
    ) dbt_internal_test