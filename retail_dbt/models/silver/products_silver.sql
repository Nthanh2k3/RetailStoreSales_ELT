{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_products') }} as s
