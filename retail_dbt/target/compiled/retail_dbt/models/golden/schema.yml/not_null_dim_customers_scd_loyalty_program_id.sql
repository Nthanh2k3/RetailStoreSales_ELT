
    
    



select loyalty_program_id
from "postgres"."silver_to_golden"."dim_customers_scd"
where loyalty_program_id is null


