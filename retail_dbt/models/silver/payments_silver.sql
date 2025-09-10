{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_payments') }} as s
