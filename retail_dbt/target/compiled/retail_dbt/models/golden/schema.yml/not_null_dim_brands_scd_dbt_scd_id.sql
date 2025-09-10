
    
    



select dbt_scd_id
from "postgres"."silver_to_golden"."dim_brands_scd"
where dbt_scd_id is null


