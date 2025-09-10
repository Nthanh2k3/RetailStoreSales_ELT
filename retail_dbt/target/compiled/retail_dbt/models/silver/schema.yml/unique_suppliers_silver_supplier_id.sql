
    
    

select
    supplier_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."suppliers_silver"
where supplier_id is not null
group by supplier_id
having count(*) > 1


