{{ config(
    schema='to_golden',
    materialized='table'
) }}

with purchase_orders_gold as (
    select
        po.order_id,
        po.supplier_id,
        po.order_date,
        po.status,
        s.name as supplier_name,
        date_part('year', po.order_date) as order_year,
        date_part('month', po.order_date) as order_month,
        date_part('day', po.order_date) as order_day
    from {{ ref('purchase_orders_silver') }} po
    left join {{ ref('suppliers_silver') }} s on po.supplier_id = s.supplier_id
    where po.order_id is not null
        and po.supplier_id is not null
        and po.order_date is not null
        and po.status is not null and po.status != 'N/A'
        and s.name is not null and s.name != 'N/A'
)

select * from purchase_orders_gold