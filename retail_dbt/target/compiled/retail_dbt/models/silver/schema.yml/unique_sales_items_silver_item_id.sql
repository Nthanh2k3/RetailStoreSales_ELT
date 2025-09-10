
    
    

select
    item_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."sales_items_silver"
where item_id is not null
group by item_id
having count(*) > 1


