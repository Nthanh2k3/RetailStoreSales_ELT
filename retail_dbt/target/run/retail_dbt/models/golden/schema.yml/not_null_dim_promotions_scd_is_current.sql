
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select is_current
from "postgres"."silver_to_golden"."dim_promotions_scd"
where is_current is null



  
  
      
    ) dbt_internal_test