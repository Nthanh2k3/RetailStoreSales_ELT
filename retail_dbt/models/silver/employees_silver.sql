{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_employees') }} as s
