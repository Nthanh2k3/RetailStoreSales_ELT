{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_customers') }} as s
