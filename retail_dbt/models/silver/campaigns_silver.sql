{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_campaigns') }} as s
