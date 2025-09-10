{{ config(materialized='table', schema='to_golden') }}
select * from {{ ref('discount_rules_silver') }}
