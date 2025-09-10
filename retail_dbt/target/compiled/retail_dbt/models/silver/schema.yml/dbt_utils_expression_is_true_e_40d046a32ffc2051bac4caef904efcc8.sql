



select
    1
from "postgres"."silver"."employees_silver"

where not(role TRIM(role) != '' AND role NOT ILIKE '%N/A%')

