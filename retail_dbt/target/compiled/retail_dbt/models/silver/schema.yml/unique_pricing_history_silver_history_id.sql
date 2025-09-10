
    
    

select
    history_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."pricing_history_silver"
where history_id is not null
group by history_id
having count(*) > 1


