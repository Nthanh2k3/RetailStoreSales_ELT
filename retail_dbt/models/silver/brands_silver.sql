{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_brands') }} as s
