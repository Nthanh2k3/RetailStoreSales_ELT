
  
    

  create  table "postgres"."silver_to_golden"."fct_inventory__dbt_tmp"
  
  
    as
  
  (
    

with inventory_gold as (
    select
        i.inventory_id,
        i.store_id,
        i.product_id,
        i.quantity,
        i.last_updated,
        p.name as product_name,
        sto.name as store_name,
        date_part('year', i.last_updated) as last_updated_year,
        date_part('month', i.last_updated) as last_updated_month,
        date_part('day', i.last_updated) as last_updated_day
    from "postgres"."silver"."inventory_silver" i
    left join "postgres"."silver"."products_silver" p on i.product_id = p.product_id
    left join "postgres"."silver"."stores_silver" sto on i.store_id = sto.store_id
    where i.inventory_id is not null
        and i.store_id is not null
        and i.product_id is not null
        and i.quantity is not null
        and i.last_updated is not null
        and p.name is not null and p.name != 'N/A'
        and sto.name is not null and sto.name != 'N/A'
)

select * from inventory_gold
  );
  