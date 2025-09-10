
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select brand_sk
from "postgres"."silver_to_golden"."dim_brands_scd"
where brand_sk is null



  
  
      
    ) dbt_internal_test