{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_sales_items') }} as s
