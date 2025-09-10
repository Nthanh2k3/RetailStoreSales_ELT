
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_id
from "postgres"."silver"."sales_transactions_silver"
where customer_id is null



  
  
      
    ) dbt_internal_test