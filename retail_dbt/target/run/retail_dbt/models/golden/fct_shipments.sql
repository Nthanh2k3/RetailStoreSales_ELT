
  
    

  create  table "postgres"."silver_to_golden"."fct_shipments__dbt_tmp"
  
  
    as
  
  (
    

with shipments_gold as (
    select
        sh.shipment_id,
        sh.order_id,
        sh.store_id,
        sh.shipped_date,
        sh.received_date,
        po.supplier_id,
        s.name as supplier_name,
        sto.name as store_name,
        date_part('year', sh.shipped_date) as shipped_year,
        date_part('month', sh.shipped_date) as shipped_month,
        date_part('day', sh.shipped_date) as shipped_day,
        date_part('year', sh.received_date) as received_year,
        date_part('month', sh.received_date) as received_month,
        date_part('day', sh.received_date) as received_day,
        EXTRACT(EPOCH FROM (sh.received_date - sh.shipped_date)) / 86400 as shipment_duration_days
    from "postgres"."silver"."shipments_silver" sh
    left join "postgres"."silver"."purchase_orders_silver" po on sh.order_id = po.order_id
    left join "postgres"."silver"."suppliers_silver" s on po.supplier_id = s.supplier_id
    left join "postgres"."silver"."stores_silver" sto on sh.store_id = sto.store_id
    where sh.shipment_id is not null
        and sh.order_id is not null
        and sh.store_id is not null
        and sh.shipped_date is not null
        and sh.received_date is not null
        and po.supplier_id is not null
        and s.name is not null and s.name != 'N/A'
        and sto.name is not null and sto.name != 'N/A'
)

select * from shipments_gold
  );
  