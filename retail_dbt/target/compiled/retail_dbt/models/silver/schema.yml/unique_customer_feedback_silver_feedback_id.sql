
    
    

select
    feedback_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."customer_feedback_silver"
where feedback_id is not null
group by feedback_id
having count(*) > 1


