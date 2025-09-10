
  
    

  create  table "postgres"."silver_to_golden"."fct_returns__dbt_tmp"
  
  
    as
  
  (
    

with returns_gold as (
    select
        r.return_id,
        r.item_id,
        r.reason,
        r.return_date,
        si.product_id,
        si.quantity as returned_quantity,
        p.name as product_name,
        st.customer_id,
        sto.name as store_name,
        date_part('year', r.return_date) as return_year,
        date_part('month', r.return_date) as return_month,
        date_part('day', r.return_date) as return_day
    from "postgres"."silver"."returns_silver" r
    left join "postgres"."silver"."sales_items_silver" si on r.item_id = si.item_id
    left join "postgres"."silver"."sales_transactions_silver" st on si.transaction_id = st.transaction_id
    left join "postgres"."silver"."products_silver" p on si.product_id = p.product_id
    left join "postgres"."silver"."stores_silver" sto on st.store_id = sto.store_id
    where r.return_id is not null
        and r.item_id is not null
        and r.reason is not null and r.reason != 'N/A'
        and r.return_date is not null
        and si.product_id is not null
        and si.quantity is not null
        and p.name is not null and p.name != 'N/A'
        and st.customer_id is not null
        and sto.name is not null and sto.name != 'N/A'
)

select * from returns_gold
  );
  