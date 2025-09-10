{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_stores') }} as s
