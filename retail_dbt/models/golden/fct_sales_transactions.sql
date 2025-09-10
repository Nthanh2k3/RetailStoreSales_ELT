{{ config(
    schema='to_golden',
    materialized='table'
) }}

with sales_transactions_gold as (
    select
        st.transaction_id,
        st.customer_id,
        st.store_id,
        st.employee_id,
        st.transaction_date,
        st.total_amount,
        st.payment_id,
        c.name as customer_name,
        sto.name as store_name,
        e.name as employee_name,
        pay.method as payment_method,
        date_part('year', st.transaction_date) as transaction_year,
        date_part('month', st.transaction_date) as transaction_month,
        date_part('day', st.transaction_date) as transaction_day
    from {{ ref('sales_transactions_silver') }} st
    left join {{ ref('customers_silver') }} c on st.customer_id = c.customer_id
    left join {{ ref('stores_silver') }} sto on st.store_id = sto.store_id
    left join {{ ref('employees_silver') }} e on st.employee_id = e.employee_id
    left join {{ ref('payments_silver') }} pay on st.payment_id = pay.payment_id
    where st.transaction_id is not null
        and st.customer_id is not null
        and st.store_id is not null
        and st.employee_id is not null
        and st.transaction_date is not null
        and st.total_amount is not null
        and st.payment_id is not null
        and c.name is not null and c.name != 'N/A'
        and sto.name is not null and sto.name != 'N/A'
        and e.name is not null and e.name != 'N/A'
        and pay.method is not null and pay.method != 'N/A'
)

select * from sales_transactions_gold