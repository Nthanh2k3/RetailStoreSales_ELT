
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select end_date
from "postgres"."silver_to_golden"."dim_promotions_scd"
where end_date is null



  
  
      
    ) dbt_internal_test