{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_purchase_orders') }} as s
