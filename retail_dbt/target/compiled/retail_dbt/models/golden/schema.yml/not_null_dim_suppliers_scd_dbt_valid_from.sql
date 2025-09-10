
    
    



select dbt_valid_from
from "postgres"."silver_to_golden"."dim_suppliers_scd"
where dbt_valid_from is null


