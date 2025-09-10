
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select supplier_sk
from "postgres"."silver_to_golden"."dim_suppliers_scd"
where supplier_sk is null



  
  
      
    ) dbt_internal_test