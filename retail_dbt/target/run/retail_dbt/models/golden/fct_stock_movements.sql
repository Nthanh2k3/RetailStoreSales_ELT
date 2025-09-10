
  
    

  create  table "postgres"."silver_to_golden"."fct_stock_movements__dbt_tmp"
  
  
    as
  
  (
    

with stock_movements_gold as (
    select
        sm.movement_id,
        sm.product_id,
        sm.store_id,
        sm.movement_type,
        sm.quantity,
        sm.movement_date,
        p.name as product_name,
        sto.name as store_name,
        date_part('year', sm.movement_date) as movement_year,
        date_part('month', sm.movement_date) as movement_month
    from "postgres"."silver"."stock_movements_silver" sm
    left join "postgres"."silver"."products_silver" p on sm.product_id = p.product_id
    left join "postgres"."silver"."stores_silver" sto on sm.store_id = sto.store_id
    where sm.movement_id is not null
        and sm.product_id is not null
        and sm.store_id is not null
        and sm.movement_type is not null and sm.movement_type != 'N/A'
        and sm.quantity is not null
        and sm.movement_date is not null
        and p.name is not null and p.name != 'N/A'
        and sto.name is not null and sto.name != 'N/A'
)

select * from stock_movements_gold
  );
  