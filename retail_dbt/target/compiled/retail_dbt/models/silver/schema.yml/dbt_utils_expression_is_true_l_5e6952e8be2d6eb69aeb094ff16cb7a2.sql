



select
    1
from "postgres"."silver"."loyalty_programs_silver"

where not(name TRIM(name) != '' AND name NOT ILIKE '%N/A%')

