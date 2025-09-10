
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select contact_info
from "postgres"."silver_to_golden"."dim_suppliers_scd"
where contact_info is null



  
  
      
    ) dbt_internal_test