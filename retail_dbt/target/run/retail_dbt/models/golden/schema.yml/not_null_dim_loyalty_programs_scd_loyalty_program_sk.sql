
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select loyalty_program_sk
from "postgres"."silver_to_golden"."dim_loyalty_programs_scd"
where loyalty_program_sk is null



  
  
      
    ) dbt_internal_test