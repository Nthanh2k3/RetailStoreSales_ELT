{{ config(
    schema='to_golden',
    materialized='table'
) }}

with store_visits_gold as (
    select
        sv.visit_id,
        sv.customer_id,
        sv.store_id,
        sv.visit_date,
        c.name as customer_name,
        sto.name as store_name,
        date_part('year', sv.visit_date) as visit_year,
        date_part('month', sv.visit_date) as visit_month,
        date_part('day', sv.visit_date) as visit_day
    from {{ ref('store_visits_silver') }} sv
    left join {{ ref('customers_silver') }} c on sv.customer_id = c.customer_id
    left join {{ ref('stores_silver') }} sto on sv.store_id = sto.store_id
)

select * from store_visits_gold