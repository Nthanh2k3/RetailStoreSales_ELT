



select
    1
from "postgres"."silver"."returns_silver"

where not(reason TRIM(reason) != '' AND reason NOT ILIKE '%N/A%')

