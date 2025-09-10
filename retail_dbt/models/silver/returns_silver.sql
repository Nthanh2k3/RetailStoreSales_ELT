{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_returns') }} as s
