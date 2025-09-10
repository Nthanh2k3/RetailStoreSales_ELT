

with payments_gold as (
    select
        p.payment_id,
        p.method,
        p.status,
        p.paid_at,
        st.transaction_id,
        st.customer_id,
        st.store_id,
        st.employee_id,
        c.name as customer_name,
        sto.name as store_name,
        e.name as employee_name,
        date_part('year', p.paid_at) as paid_year,
        date_part('month', p.paid_at) as paid_month,
        date_part('day', p.paid_at) as paid_day
    from "postgres"."silver"."payments_silver" p
    left join "postgres"."silver"."sales_transactions_silver" st on p.payment_id = st.payment_id
    left join "postgres"."silver"."customers_silver" c on st.customer_id = c.customer_id
    left join "postgres"."silver"."stores_silver" sto on st.store_id = sto.store_id
    left join "postgres"."silver"."employees_silver" e on st.employee_id = e.employee_id
    where p.payment_id is null
        or p.method is null or p.method = 'N/A'
        or p.status is null or p.status = 'N/A'
        or p.paid_at is null
        or st.transaction_id is null
        or st.customer_id is null
        or st.store_id is null
        or st.employee_id is null
        or c.name is null or c.name = 'N/A'
        or sto.name is null or sto.name = 'N/A'
        or e.name is null or e.name = 'N/A'
)

select * from payments_gold