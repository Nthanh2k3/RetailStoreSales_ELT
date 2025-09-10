



select
    1
from "postgres"."silver"."tax_rules_silver"

where not(region TRIM(region) != '' AND region NOT ILIKE '%N/A%')

