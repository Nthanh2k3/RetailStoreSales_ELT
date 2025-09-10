{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_loyalty_programs') }} as s
