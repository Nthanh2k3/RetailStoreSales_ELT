
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category_id
from "postgres"."silver"."categories_silver"
where category_id is null



  
  
      
    ) dbt_internal_test