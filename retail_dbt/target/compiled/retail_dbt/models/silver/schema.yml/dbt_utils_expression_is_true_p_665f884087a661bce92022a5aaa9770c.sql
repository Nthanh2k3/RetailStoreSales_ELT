



select
    1
from "postgres"."silver"."payments_silver"

where not(status TRIM(status) != '' AND status NOT ILIKE '%N/A%')

