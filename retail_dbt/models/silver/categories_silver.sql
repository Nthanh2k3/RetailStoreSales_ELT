{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_categories') }} as s
