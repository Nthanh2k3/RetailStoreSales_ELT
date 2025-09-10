



select
    1
from "postgres"."silver"."suppliers_silver"

where not(contact_info TRIM(contact_info) != '' AND contact_info NOT ILIKE '%N/A%')

