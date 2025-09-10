
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select name
from "postgres"."silver_to_golden"."dim_categories_scd"
where name is null



  
  
      
    ) dbt_internal_test