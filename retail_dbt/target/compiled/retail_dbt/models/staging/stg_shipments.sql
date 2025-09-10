

with source_data as (
    select * from "postgres"."raw"."shipments"
),

final as (
    select
        cast(shipment_id as int) as shipment_id,
        cast(order_id as int) as order_id,
        cast(store_id as int) as store_id,
        cast(shipped_date as timestamp) as shipped_date,
        cast(received_date as timestamp) as received_date
    from source_data
    where shipment_id is not null
        and order_id is not null
        and store_id is not null
        and shipped_date is not null
        and received_date is not null
        and shipped_date < received_date
        and shipped_date <= '2025-08-22 00:00:00'
        and received_date <= '2025-08-22 00:00:00'
        and shipment_id != 'N/A'
        and order_id != 'N/A'
        and store_id != 'N/A'
        and shipped_date != 'N/A'
        and received_date != 'N/A'
)

select * from final