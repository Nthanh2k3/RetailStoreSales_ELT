{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_pricing_history') }} as s
