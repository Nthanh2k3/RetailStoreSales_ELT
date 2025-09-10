{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_tax_rules') }} as s
