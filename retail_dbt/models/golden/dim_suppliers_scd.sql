{{ config(materialized='table', schema='to_golden') }}
select
  *,
  dbt_scd_id  as supplier_sk,
  dbt_valid_from as valid_from,
  dbt_valid_to   as valid_to,
  (dbt_valid_to is null) as is_current
from {{ ref('dim_suppliers_snapshot') }}
