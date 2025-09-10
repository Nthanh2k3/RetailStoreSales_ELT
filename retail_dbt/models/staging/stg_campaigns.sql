{{ config(
    materialized='view',
    schema='staging'   
) }}

{%- set cutoff_date = '2025-08-22' -%}

with source as (
    select * from {{ source('raw', 'campaigns') }}
),

cleaned as (
    select
        case 
            when campaign_id is null then null
            when trim(campaign_id) = '' then null
            when lower(trim(campaign_id)) in ('null','na','n/a','none') then null
            -- loại bỏ ký tự không phải số rồi cast sang int
            else cast(regexp_replace(trim(campaign_id), '[^0-9]', '', 'g') as int)
        end as campaign_id,

        case 
            when name is null then null
            when trim(name) = '' then null
            when lower(trim(name)) in ('null','na','n/a','none') then null
            else trim(name)
        end as name,

        case
            when budget is null then null
            when trim(budget::text) = '' then null
            when lower(trim(budget::text)) in ('null','na','n/a','none') then null
            else nullif(regexp_replace(trim(budget::text), '[^0-9.\-]', '', 'g'), '')
        end as budget_str,

        nullif(trim(start_date::text), '') as start_date_raw,
        nullif(trim(end_date::text), '') as end_date_raw,

        current_timestamp as staged_at
    from source
),

typed as (
    select
        campaign_id,
        name,
        case
            when budget_str ~ '^-?\d+(\.\d+)?$' then budget_str::numeric
            else null
        end as budget,

        /* Chuẩn hoá dấu phân cách ngày về '-' để dễ regex */
        case when start_date_raw is null then null
             else regexp_replace(lower(start_date_raw), '[./]', '-', 'g') end as start_norm,
        case when end_date_raw   is null then null
             else regexp_replace(lower(end_date_raw),   '[./]', '-', 'g') end as end_norm,

        staged_at
    from cleaned
),

parsed as (
    select
        campaign_id,
        name,
        budget,

        /* START_DATE */
        case
            /* YYYY-MM-DD [optional time] */
            when start_norm ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])(\s.*)?$'
                then to_date(split_part(start_norm, ' ', 1), 'YYYY-MM-DD')
            /* DD-MM-YYYY [optional time] */
            when start_norm ~ '^(0[1-9]|[12]\d|3[01])-(0[1-9]|1[0-2])-\d{4}(\s.*)?$'
                then to_date(split_part(start_norm, ' ', 1), 'DD-MM-YYYY')
            /* MM-DD-YYYY [optional time] */
            when start_norm ~ '^(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])-\d{4}(\s.*)?$'
                then to_date(split_part(start_norm, ' ', 1), 'MM-DD-YYYY')
            else null
        end as start_date,

        /* END_DATE */
        case
            when end_norm ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])(\s.*)?$'
                then to_date(split_part(end_norm, ' ', 1), 'YYYY-MM-DD')
            when end_norm ~ '^(0[1-9]|[12]\d|3[01])-(0[1-9]|1[0-2])-\d{4}(\s.*)?$'
                then to_date(split_part(end_norm, ' ', 1), 'DD-MM-YYYY')
            when end_norm ~ '^(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])-\d{4}(\s.*)?$'
                then to_date(split_part(end_norm, ' ', 1), 'MM-DD-YYYY')
            else null
        end as end_date,

        staged_at
    from typed
),

filtered as (
    select *
    from parsed
    where start_date is not null
      and end_date is not null
      and start_date < end_date
      and start_date < date '{{ cutoff_date }}'
      and end_date < date '{{ cutoff_date }}'
      -- Thêm điều kiện loại bỏ tất cả các hàng có giá trị null ở bất kỳ cột nào
      and campaign_id is not null
      and name is not null
      and budget is not null
      and staged_at is not null
)

select
    campaign_id,
    name,
    budget,
    start_date,
    end_date,
    staged_at
from filtered