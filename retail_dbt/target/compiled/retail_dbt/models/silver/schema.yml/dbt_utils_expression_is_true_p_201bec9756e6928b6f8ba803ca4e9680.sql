



select
    1
from "postgres"."silver"."payments_silver"

where not(method TRIM(method) != '' AND method NOT ILIKE '%N/A%')

