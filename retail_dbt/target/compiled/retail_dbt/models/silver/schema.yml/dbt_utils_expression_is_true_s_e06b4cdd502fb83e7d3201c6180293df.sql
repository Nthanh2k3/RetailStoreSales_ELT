



select
    1
from "postgres"."silver"."stores_silver"

where not(location TRIM(location) != '' AND location NOT ILIKE '%N/A%')

