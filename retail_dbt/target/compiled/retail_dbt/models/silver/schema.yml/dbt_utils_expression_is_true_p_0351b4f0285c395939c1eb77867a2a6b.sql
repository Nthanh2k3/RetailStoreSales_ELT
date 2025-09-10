



select
    1
from "postgres"."silver"."products_silver"

where not(name TRIM(name) != '' AND name NOT ILIKE '%N/A%')

