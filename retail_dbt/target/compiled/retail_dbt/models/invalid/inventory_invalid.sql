

with source as (
    select * 
    from "postgres"."raw"."inventory"
),

evaluated as (
    select
        inventory_id,
        store_id,
        product_id,
        quantity,
        last_updated,

        -- rule checks
        case 
            when inventory_id is null or trim(lower(inventory_id)) in ('', 'null', 'na', 'n/a', 'none') 
            then 'invalid_inventory_id'
        end as invalid_inventory_id,

        case 
            when store_id is null or trim(lower(store_id)) in ('', 'null', 'na', 'n/a', 'none') 
            then 'invalid_store_id'
        end as invalid_store_id,

        case 
            when product_id is null or trim(lower(product_id)) in ('', 'null', 'na', 'n/a', 'none') 
            then 'invalid_product_id'
        end as invalid_product_id,

        case 
            when quantity is null or trim(lower(quantity)) in ('', 'null', 'na', 'n/a', 'none') 
                 or cast(quantity as integer) = 0
            then 'invalid_quantity'
        end as invalid_quantity,

        case 
            when last_updated is null or trim(lower(last_updated)) in ('', 'null', 'na', 'n/a', 'none') 
            then 'invalid_last_updated_null'
            when cast(last_updated as date) > date('2025-08-22') 
            then 'invalid_last_updated_future'
        end as invalid_last_updated
    from source
),

invalids as (
    select *
    from evaluated
    where invalid_inventory_id is not null
       or invalid_store_id is not null
       or invalid_product_id is not null
       or invalid_quantity is not null
       or invalid_last_updated is not null
)

select * from invalids