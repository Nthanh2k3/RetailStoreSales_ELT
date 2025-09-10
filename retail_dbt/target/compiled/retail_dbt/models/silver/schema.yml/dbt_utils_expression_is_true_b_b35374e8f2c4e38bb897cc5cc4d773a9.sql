



select
    1
from "postgres"."silver"."brands_silver"

where not(name TRIM(name) != '' AND name NOT ILIKE '%N/A%')

