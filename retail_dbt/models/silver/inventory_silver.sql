{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_inventory') }} as s
