{{ config(materialized='table') }}

select
  s.*
from {{ ref('stg_customer_feedback') }} as s
