
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select points_per_dollar
from "postgres"."silver"."loyalty_programs_silver"
where points_per_dollar is null



  
  
      
    ) dbt_internal_test