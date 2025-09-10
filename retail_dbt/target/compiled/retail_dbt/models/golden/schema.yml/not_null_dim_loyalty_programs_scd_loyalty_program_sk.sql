
    
    



select loyalty_program_sk
from "postgres"."silver_to_golden"."dim_loyalty_programs_scd"
where loyalty_program_sk is null


