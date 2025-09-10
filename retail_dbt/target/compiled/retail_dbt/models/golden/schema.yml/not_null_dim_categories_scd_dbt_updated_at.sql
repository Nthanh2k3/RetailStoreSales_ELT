
    
    



select dbt_updated_at
from "postgres"."silver_to_golden"."dim_categories_scd"
where dbt_updated_at is null


