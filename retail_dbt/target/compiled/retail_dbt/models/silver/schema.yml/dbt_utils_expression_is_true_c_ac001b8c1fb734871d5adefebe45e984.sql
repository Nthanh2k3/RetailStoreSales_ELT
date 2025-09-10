



select
    1
from "postgres"."silver"."customers_silver"

where not(phone TRIM(phone) != '' AND phone NOT ILIKE '%N/A%')

