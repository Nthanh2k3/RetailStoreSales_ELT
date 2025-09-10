



select
    1
from "postgres"."silver"."customers_silver"

where not(email TRIM(email) != '' AND email NOT ILIKE '%N/A%' AND email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+[A-Za-z]{2,}$')

