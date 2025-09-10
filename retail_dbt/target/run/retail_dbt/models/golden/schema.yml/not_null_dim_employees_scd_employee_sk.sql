
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select employee_sk
from "postgres"."silver_to_golden"."dim_employees_scd"
where employee_sk is null



  
  
      
    ) dbt_internal_test