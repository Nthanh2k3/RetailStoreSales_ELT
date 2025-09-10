



select
    1
from "postgres"."silver"."customer_feedback_silver"

where not(comments TRIM(comments) != '' AND comments NOT ILIKE '%N/A%')

