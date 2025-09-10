
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  



select
    1
from "postgres"."silver"."stock_movements_silver"

where not(movement_type TRIM(movement_type) != '' AND movement_type NOT ILIKE '%N/A%')


  
  
      
    ) dbt_internal_test