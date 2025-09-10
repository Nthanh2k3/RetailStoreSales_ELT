
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select region
from "postgres"."silver_to_golden"."dim_tax_rules"
where region is null



  
  
      
    ) dbt_internal_test