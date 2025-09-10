
  create view "postgres"."silver_invalid"."campaign_invalid__dbt_tmp"
    
    
  as (
    with source as (
    select * from "postgres"."raw"."campaigns"
),

cleaned as (
    select
        campaign_id::text        as campaign_id_raw,
        name::text               as name_raw,
        budget::text             as budget_raw,
        start_date::text         as start_date_raw,
        end_date::text           as end_date_raw,

        
        case 
            when campaign_id is null or trim(campaign_id::text) = '' then null
            when lower(trim(campaign_id::text)) in ('null','na','n/a','none') then null
            else trim(campaign_id::text)
        end as campaign_id,

        case 
            when name is null or trim(name::text) = '' then null
            when lower(trim(name::text)) in ('null','na','n/a','none') then null
            else trim(name::text)
        end as name,

        case
            when budget is null then null
            when trim(budget::text) = '' then null
            when lower(trim(budget::text)) in ('null','na','n/a','none') then null
            else nullif(regexp_replace(trim(budget::text), '[^0-9.\-]', '', 'g'), '')
        end as budget_str,

        case when start_date is null then null else regexp_replace(trim(start_date::text), '[./]', '-', 'g') end as start_norm,
        case when end_date   is null then null else regexp_replace(trim(end_date::text),   '[./]', '-', 'g') end   as end_norm
    from source
),


parsed as (
    select
        *,
        case
            when start_norm ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])(\s.*)?$'
                then to_date(split_part(start_norm, ' ', 1), 'YYYY-MM-DD')
            when start_norm ~ '^(0[1-9]|[12]\d|3[01])-(0[1-9]|1[0-2])-\d{4}(\s.*)?$'
                then to_date(split_part(start_norm, ' ', 1), 'DD-MM-YYYY')
            when start_norm ~ '^(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])-\d{4}(\s.*)?$'
                then to_date(split_part(start_norm, ' ', 1), 'MM-DD-YYYY')
            else null
        end as start_date_parsed,

        case
            when end_norm ~ '^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])(\s.*)?$'
                then to_date(split_part(end_norm, ' ', 1), 'YYYY-MM-DD')
            when end_norm ~ '^(0[1-9]|[12]\d|3[01])-(0[1-9]|1[0-2])-\d{4}(\s.*)?$'
                then to_date(split_part(end_norm, ' ', 1), 'DD-MM-YYYY')
            when end_norm ~ '^(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])-\d{4}(\s.*)?$'
                then to_date(split_part(end_norm, ' ', 1), 'MM-DD-YYYY')
            else null
        end as end_date_parsed,

        case when budget_str ~ '^-?\d+(\.\d+)?$' then budget_str::numeric else null end as budget_num
    from cleaned
),


flagged as (
    select
        *,
        
        (budget_str is null or not (budget_str ~ '^-?\d+(\.\d+)?$'))                as f_budget_invalid,

        
        (start_norm is not null and start_date_parsed is null)                      as f_start_bad_format,
        (end_norm   is not null and end_date_parsed   is null)                      as f_end_bad_format,
        (start_norm is null)                                                        as f_start_missing,
        (end_norm   is null)                                                        as f_end_missing,

        
        (start_date_parsed is not null and end_date_parsed is not null 
            and start_date_parsed >= end_date_parsed)                               as f_order_invalid,

        (start_date_parsed is not null and start_date_parsed >= date '2025-08-22') as f_start_ge_cutoff,
        (end_date_parsed   is not null and end_date_parsed   >= date '2025-08-22') as f_end_ge_cutoff
    from parsed
),


reasons as (
    select
        *,
        array_remove(
            array[
                case when f_budget_invalid  then 'budget_invalid_or_not_numeric' end,
                case when f_start_missing   then 'start_date_missing' end,
                case when f_end_missing     then 'end_date_missing' end,
                case when f_start_bad_format then 'start_date_unparseable' end,
                case when f_end_bad_format   then 'end_date_unparseable' end,
                case when f_order_invalid    then 'start_date_not_less_than_end_date' end,
                case when f_start_ge_cutoff  then 'start_date_on_or_after_2025-08-22' end,
                case when f_end_ge_cutoff    then 'end_date_on_or_after_2025-08-22' end
            ],
            null
        ) as invalid_reasons_array
    from flagged
),


invalid_rows as (
    select *
    from reasons
    where cardinality(invalid_reasons_array) > 0
)

select
    
    campaign_id_raw,
    name_raw,
    budget_raw,
    start_date_raw,
    end_date_raw,
    campaign_id,
    name,
    budget_str,
    budget_num,
    start_norm,
    end_norm,
    start_date_parsed as start_date,
    end_date_parsed   as end_date, 
    invalid_reasons_array                                  as invalid_reasons,
    array_to_string(invalid_reasons_array, '; ')           as invalid_reason_text
from invalid_rows
  );