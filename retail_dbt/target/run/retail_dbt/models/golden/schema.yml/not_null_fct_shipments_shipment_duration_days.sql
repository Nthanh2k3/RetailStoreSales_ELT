
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select shipment_duration_days
from "postgres"."silver_to_golden"."fct_shipments"
where shipment_duration_days is null



  
  
      
    ) dbt_internal_test