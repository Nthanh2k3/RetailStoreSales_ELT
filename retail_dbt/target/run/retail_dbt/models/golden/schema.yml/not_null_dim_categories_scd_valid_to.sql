
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select valid_to
from "postgres"."silver_to_golden"."dim_categories_scd"
where valid_to is null



  
  
      
    ) dbt_internal_test