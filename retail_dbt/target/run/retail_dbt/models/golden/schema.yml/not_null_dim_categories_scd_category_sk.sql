
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category_sk
from "postgres"."silver_to_golden"."dim_categories_scd"
where category_sk is null



  
  
      
    ) dbt_internal_test