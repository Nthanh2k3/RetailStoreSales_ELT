{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_discount_rules') }} as s
