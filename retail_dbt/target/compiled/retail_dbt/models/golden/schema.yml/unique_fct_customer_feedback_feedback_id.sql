
    
    

select
    feedback_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."fct_customer_feedback"
where feedback_id is not null
group by feedback_id
having count(*) > 1


