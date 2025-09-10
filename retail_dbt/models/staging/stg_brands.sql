{{ config(
    materialized='view',
    schema='staging'
) }}

with source as (
    select * from {{ source('raw', 'brands') }}
),

cleaned as (
    select
        case 
            when trim(brand_id) = '' then null
            when lower(trim(brand_id)) in ('null', 'na', 'n/a') then null
            -- loại bỏ ký tự không phải số trước khi cast
            else cast(regexp_replace(trim(brand_id), '[^0-9]', '', 'g') as int)
        end as brand_id,
        
        case 
            when trim(name) = '' then null
            when lower(trim(name)) in ('null', 'na', 'n/a', 'none', 'unknown') then null
            else trim(name)
        end as name,
        
        current_timestamp as staged_at
    from source
)

select * from cleaned
