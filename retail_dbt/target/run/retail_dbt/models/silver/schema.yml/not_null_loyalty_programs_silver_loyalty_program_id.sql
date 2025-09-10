
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select loyalty_program_id
from "postgres"."silver"."loyalty_programs_silver"
where loyalty_program_id is null



  
  
      
    ) dbt_internal_test