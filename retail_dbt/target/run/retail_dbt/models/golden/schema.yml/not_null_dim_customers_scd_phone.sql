
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select phone
from "postgres"."silver_to_golden"."dim_customers_scd"
where phone is null



  
  
      
    ) dbt_internal_test