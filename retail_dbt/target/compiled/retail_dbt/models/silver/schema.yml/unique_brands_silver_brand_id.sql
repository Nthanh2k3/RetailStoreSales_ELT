
    
    

select
    brand_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."brands_silver"
where brand_id is not null
group by brand_id
having count(*) > 1


