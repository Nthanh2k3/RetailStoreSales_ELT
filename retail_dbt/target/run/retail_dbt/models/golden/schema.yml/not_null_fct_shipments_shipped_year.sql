
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select shipped_year
from "postgres"."silver_to_golden"."fct_shipments"
where shipped_year is null



  
  
      
    ) dbt_internal_test