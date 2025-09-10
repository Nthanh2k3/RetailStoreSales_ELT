



select
    1
from "postgres"."silver"."discount_rules_silver"

where not(discount_type TRIM(discount_type) != '' AND discount_type NOT ILIKE '%N/A%')

