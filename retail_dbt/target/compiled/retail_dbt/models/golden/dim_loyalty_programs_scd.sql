
select
  *,
  dbt_scd_id  as loyalty_program_sk,
  dbt_valid_from as valid_from,
  dbt_valid_to   as valid_to,
  (dbt_valid_to is null) as is_current
from "postgres"."silver"."dim_loyalty_programs_snapshot"