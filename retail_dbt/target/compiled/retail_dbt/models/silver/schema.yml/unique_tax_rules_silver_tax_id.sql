
    
    

select
    tax_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."tax_rules_silver"
where tax_id is not null
group by tax_id
having count(*) > 1


