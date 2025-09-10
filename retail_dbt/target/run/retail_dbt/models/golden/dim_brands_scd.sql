
  
    

  create  table "postgres"."silver_to_golden"."dim_brands_scd__dbt_tmp"
  
  
    as
  
  (
    
select
  *,
  dbt_scd_id  as brand_sk,
  dbt_valid_from as valid_from,
  dbt_valid_to   as valid_to,
  (dbt_valid_to is null) as is_current
from "postgres"."silver"."dim_brands_snapshot"
  );
  