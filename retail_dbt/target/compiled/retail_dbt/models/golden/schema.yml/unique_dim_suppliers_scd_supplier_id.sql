
    
    

select
    supplier_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."dim_suppliers_scd"
where supplier_id is not null
group by supplier_id
having count(*) > 1


