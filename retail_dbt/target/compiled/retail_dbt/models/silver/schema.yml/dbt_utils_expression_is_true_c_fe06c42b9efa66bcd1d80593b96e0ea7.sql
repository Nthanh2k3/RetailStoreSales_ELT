



select
    1
from "postgres"."silver"."campaigns_silver"

where not(name TRIM(name) != '' AND name NOT ILIKE '%N/A%')

