{{ config(materialized='table', schema='to_golden') }}
select * from {{ ref('campaigns_silver') }}
