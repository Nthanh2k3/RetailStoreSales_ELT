



select
    1
from "postgres"."silver"."stores_silver"

where not(name TRIM(name) != '' AND name NOT ILIKE '%N/A%')

