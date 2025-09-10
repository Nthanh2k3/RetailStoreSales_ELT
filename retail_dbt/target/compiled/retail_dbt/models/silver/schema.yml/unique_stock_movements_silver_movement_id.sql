
    
    

select
    movement_id as unique_field,
    count(*) as n_records

from "postgres"."silver"."stock_movements_silver"
where movement_id is not null
group by movement_id
having count(*) > 1


