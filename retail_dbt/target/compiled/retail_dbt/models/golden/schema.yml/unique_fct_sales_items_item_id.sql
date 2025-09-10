
    
    

select
    item_id as unique_field,
    count(*) as n_records

from "postgres"."silver_to_golden"."fct_sales_items"
where item_id is not null
group by item_id
having count(*) > 1


