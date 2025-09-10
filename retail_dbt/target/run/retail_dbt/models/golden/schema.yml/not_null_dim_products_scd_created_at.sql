
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select created_at
from "postgres"."silver_to_golden"."dim_products_scd"
where created_at is null



  
  
      
    ) dbt_internal_test