
    
    

select
    category_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."categories_silver"
where category_id is not null
group by category_id
having count(*) > 1


