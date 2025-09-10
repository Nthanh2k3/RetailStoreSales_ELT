
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select shipped_month
from "postgres"."silver_to_golden"."fct_shipments"
where shipped_month is null



  
  
      
    ) dbt_internal_test