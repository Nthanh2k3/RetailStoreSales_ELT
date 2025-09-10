
  create view "postgres"."silver_invalid"."shipments_invalid__dbt_tmp"
    
    
  as (
    

with source_data as (
    select * from "postgres"."raw"."shipments"
),

final as (
    select
        cast(shipment_id as int) as shipment_id,
        cast(order_id as int) as order_id,
        cast(store_id as int) as store_id,
        case
            when shipped_date is null or shipped_date = 'N/A' or shipped_date > '2025-08-22 00:00:00' then null
            else cast(shipped_date as timestamp)
        end as shipped_date,
        case
            when received_date is null or received_date = 'N/A' or received_date > '2025-08-22 00:00:00' then null
            else cast(received_date as timestamp)
        end as received_date,
        case
            when shipment_id is null or shipment_id = 'N/A' then 'invalid_shipment_id'
            when order_id is null or order_id = 'N/A' then 'invalid_order_id'
            when store_id is null or store_id = 'N/A' then 'invalid_store_id'
            when case
                when shipped_date is null or shipped_date = 'N/A' or shipped_date > '2025-08-22 00:00:00' then null
                else cast(shipped_date as timestamp)
            end is null then 'invalid_shipped_date'
            when case
                when received_date is null or received_date = 'N/A' or received_date > '2025-08-22 00:00:00' then null
                else cast(received_date as timestamp)
            end is null then 'invalid_received_date'
            when shipped_date >= received_date then 'shipped_date_not_before_received_date'
            else 'valid'
        end as invalid_reason
    from source_data
    where not (
        shipment_id is not null
        and order_id is not null
        and store_id is not null
        and case
            when shipped_date is null or shipped_date = 'N/A' or shipped_date > '2025-08-22 00:00:00' then null
            else cast(shipped_date as timestamp)
        end is not null
        and case
            when received_date is null or received_date = 'N/A' or received_date > '2025-08-22 00:00:00' then null
            else cast(received_date as timestamp)
        end is not null
        and case
            when shipped_date is null or shipped_date = 'N/A' or shipped_date > '2025-08-22 00:00:00' then null
            else cast(shipped_date as timestamp)
        end < case
            when received_date is null or received_date = 'N/A' or received_date > '2025-08-22 00:00:00' then null
            else cast(received_date as timestamp)
        end
        and shipment_id != 'N/A'
        and order_id != 'N/A'
        and store_id != 'N/A'
        and shipped_date != 'N/A'
        and received_date != 'N/A'
    )
)

select * from final
  );