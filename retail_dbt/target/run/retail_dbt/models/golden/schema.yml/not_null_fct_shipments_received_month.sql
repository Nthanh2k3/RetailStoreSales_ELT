
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select received_month
from "postgres"."silver_to_golden"."fct_shipments"
where received_month is null



  
  
      
    ) dbt_internal_test