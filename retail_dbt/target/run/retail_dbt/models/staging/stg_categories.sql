
  create view "postgres"."silver_staging"."stg_categories__dbt_tmp"
    
    
  as (
    

with source as (
    select * from "postgres"."raw"."categories"
),

cleaned as (
    select
        case 
            when trim(category_id) = '' then null
            when lower(trim(category_id)) in ('null', 'na', 'n/a') then null
            -- loại bỏ ký tự không phải số trước khi cast
            else cast(regexp_replace(trim(category_id), '[^0-9]', '', 'g') as int)
        end as category_id,
        
        case 
            when trim(name) = '' then null
            when lower(trim(name)) in ('null', 'na', 'n/a', 'none', 'unknown') then null
            else trim(name)
        end as name,
        
        current_timestamp as staged_at
    from source
)

select * from cleaned
  );