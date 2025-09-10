
    
    



select customer_sk
from "postgres"."silver_to_golden"."dim_customers_scd"
where customer_sk is null


