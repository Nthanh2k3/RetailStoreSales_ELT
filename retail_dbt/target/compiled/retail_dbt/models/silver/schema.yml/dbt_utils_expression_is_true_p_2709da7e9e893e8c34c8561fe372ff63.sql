



select
    1
from "postgres"."silver"."products_silver"

where not(season TRIM(season) != '' AND season NOT ILIKE '%N/A%')

