
    
    

select
    visit_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."store_visits_silver"
where visit_id is not null
group by visit_id
having count(*) > 1


