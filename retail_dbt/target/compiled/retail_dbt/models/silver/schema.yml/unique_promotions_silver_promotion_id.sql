
    
    

select
    promotion_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."promotions_silver"
where promotion_id is not null
group by promotion_id
having count(*) > 1


