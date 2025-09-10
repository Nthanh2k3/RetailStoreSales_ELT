
    
    



select employee_sk
from "postgres"."silver_to_golden"."dim_employees_scd"
where employee_sk is null


