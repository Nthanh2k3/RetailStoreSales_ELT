
  create view "postgres"."silver_staging"."stg_stores__dbt_tmp"
    
    
  as (
    

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
  );