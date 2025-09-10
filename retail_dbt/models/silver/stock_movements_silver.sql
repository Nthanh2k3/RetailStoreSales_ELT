{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_stock_movements') }} as s
