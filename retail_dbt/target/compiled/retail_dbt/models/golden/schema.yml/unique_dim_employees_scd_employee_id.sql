
    
    

select
    employee_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."dim_employees_scd"
where employee_id is not null
group by employee_id
having count(*) > 1


