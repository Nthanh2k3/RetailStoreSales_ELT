
    
    



select dbt_valid_to
from "postgres"."silver_to_golden"."dim_employees_scd"
where dbt_valid_to is null


