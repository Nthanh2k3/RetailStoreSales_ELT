
  
    

  create  table "postgres"."silver_invalid"."loyalty_programs_invalid__dbt_tmp"
  
  
    as
  
  (
    

with source as (
    select * from "postgres"."silver_staging"."stg_loyalty_programs"
),
invalid as (
    select
        loyalty_program_id,
        name,
        points_per_dollar,
        case 
            when loyalty_program_id is null then 'loyalty_program_id_null'
            when points_per_dollar is null then 'points_per_dollar_null'
            when points_per_dollar::text !~ '^[0-9]+$' then 'points_per_dollar_not_numeric'
        end as invalid_reason
    from source
    where 
        loyalty_program_id is null
        or points_per_dollar is null
        or points_per_dollar::text !~ '^[0-9]+$'
)

select * from invalid
  );
  