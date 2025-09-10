

with source as (
    select * 
    from "postgres"."raw"."inventory"
),

cleaned as (
    select
        case 
            when inventory_id is null or trim(lower(inventory_id)) in ('', 'null', 'na', 'n/a', 'none') 
            then null else cast(inventory_id as integer) 
        end as inventory_id,

        case 
            when store_id is null or trim(lower(store_id)) in ('', 'null', 'na', 'n/a', 'none') 
            then null else cast(store_id as integer) 
        end as store_id,

        case 
            when product_id is null or trim(lower(product_id)) in ('', 'null', 'na', 'n/a', 'none') 
            then null else cast(product_id as integer) 
        end as product_id,

        case 
            when quantity is null or trim(lower(quantity)) in ('', 'null', 'na', 'n/a', 'none') 
            then null else cast(quantity as integer) 
        end as quantity,

        case 
            when last_updated is null or trim(lower(last_updated)) in ('', 'null', 'na', 'n/a', 'none') 
            then null else cast(last_updated as timestamp) 
        end as last_updated
    from source
),

filtered as (
    select *
    from cleaned
    where 
        inventory_id is not null
        and store_id is not null
        and product_id is not null
        and quantity is not null
        and last_updated is not null
        and quantity <> 0
        and cast(last_updated as date) <= date('2025-08-22')
)

select * from filtered