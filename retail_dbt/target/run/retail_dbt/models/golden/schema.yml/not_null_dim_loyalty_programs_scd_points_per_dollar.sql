
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select points_per_dollar
from "postgres"."silver_to_golden"."dim_loyalty_programs_scd"
where points_per_dollar is null



  
  
      
    ) dbt_internal_test