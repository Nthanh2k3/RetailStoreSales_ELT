{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_store_visits') }} as s
