



select
    1
from "postgres"."silver"."purchase_orders_silver"

where not(status TRIM(status) != '' AND status NOT ILIKE '%N/A%')

