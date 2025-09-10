



select
    1
from "postgres"."silver"."promotions_silver"

where not(name TRIM(name) != '' AND name NOT ILIKE '%N/A%')

