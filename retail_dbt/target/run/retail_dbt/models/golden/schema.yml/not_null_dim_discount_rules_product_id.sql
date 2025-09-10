
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select product_id
from "postgres"."silver_to_golden"."dim_discount_rules"
where product_id is null



  
  
      
    ) dbt_internal_test