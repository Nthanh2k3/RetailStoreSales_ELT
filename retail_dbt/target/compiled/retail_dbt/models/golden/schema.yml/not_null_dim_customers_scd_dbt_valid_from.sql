
    
    



select dbt_valid_from
from "postgres"."silver_to_golden"."dim_customers_scd"
where dbt_valid_from is null


