



select
    1
from "postgres"."silver"."customers_silver"

where not(name TRIM(name) != '' AND name NOT ILIKE '%N/A%')

