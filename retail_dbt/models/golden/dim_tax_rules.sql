{{ config(materialized='table', schema='to_golden') }}
select * from {{ ref('tax_rules_silver') }}
