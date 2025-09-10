{{ config(
    materialized='view',
    schema='staging',
    tags=['staging','stores']
) }}

WITH src AS (
  SELECT
    store_id::int      AS store_id,
    NULLIF(TRIM(name), '')     AS name,
    NULLIF(TRIM(location), '') AS location,
    manager_id::int    AS manager_id
  FROM raw.stores
)

SELECT
  store_id,
  name,
  location,
  manager_id
FROM src
