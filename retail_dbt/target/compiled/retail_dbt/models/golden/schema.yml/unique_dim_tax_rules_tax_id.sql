
    
    

select
    tax_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."dim_tax_rules"
where tax_id is not null
group by tax_id
having count(*) > 1


