
  
    

  create  table "postgres"."silver_to_golden"."fct_sales_items__dbt_tmp"
  
  
    as
  
  (
    

with sales_items_gold as (
    select
        si.item_id,
        si.transaction_id,
        si.product_id,
        si.quantity,
        si.unit_price,
        si.discount,
        si.tax,
        si.gross_amount,
        si.net_amount,
        si.business_validation_flag,
        p.name as product_name,
        c.name as category_name,
        st.customer_id,
        sto.name as store_name,
        date_part('year', st.transaction_date) as transaction_year,
        date_part('month', st.transaction_date) as transaction_month
    from "postgres"."silver"."sales_items_silver" si
    left join "postgres"."silver"."products_silver" p on si.product_id = p.product_id
    left join "postgres"."silver"."categories_silver" c on p.category_id = c.category_id
    left join "postgres"."silver"."sales_transactions_silver" st on si.transaction_id = st.transaction_id
    left join "postgres"."silver"."stores_silver" sto on st.store_id = sto.store_id
    where si.item_id is not null
        and si.transaction_id is not null
        and si.product_id is not null
        and si.quantity is not null
        and si.unit_price is not null
        and si.discount is not null
        and si.tax is not null
        and si.gross_amount is not null
        and si.net_amount is not null
        and si.business_validation_flag is not null and si.business_validation_flag != 'N/A'
        and p.name is not null and p.name != 'N/A'
        and c.name is not null and c.name != 'N/A'
        and st.customer_id is not null
        and sto.name is not null and sto.name != 'N/A'
)

select * from sales_items_gold
  );
  