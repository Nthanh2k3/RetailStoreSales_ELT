
  create view "postgres"."silver_staging"."stg_store_visits__dbt_tmp"
    
    
  as (
    

WITH src AS (
  SELECT
    TRIM(CAST(visit_id    AS text)) AS visit_id_txt,
    TRIM(CAST(customer_id AS text)) AS customer_id_txt,
    TRIM(CAST(store_id    AS text)) AS store_id_txt,
    TRIM(REPLACE(CAST(visit_date AS text), E'\r','')) AS visit_date_txt
  FROM "postgres"."raw"."store_visits"
),

typed AS (
  SELECT
    
    CASE WHEN visit_id_txt    ~ '^\d+$' THEN visit_id_txt::int    END AS visit_id,
    CASE WHEN customer_id_txt ~ '^\d+$' THEN customer_id_txt::int END AS customer_id,
    CASE WHEN store_id_txt    ~ '^\d+$' THEN store_id_txt::int    END AS store_id,

    
    CASE
      WHEN visit_date_txt ~ '^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$'
      THEN to_date(visit_date_txt,'YYYY-MM-DD')
    END AS visit_date_raw,

    visit_date_txt
  FROM src
),


validated AS (
  SELECT
    visit_id, customer_id, store_id,
    CASE
      WHEN visit_date_raw IS NOT NULL
       AND to_char(visit_date_raw,'YYYY-MM-DD') = visit_date_txt
      THEN visit_date_raw
    END AS visit_date
  FROM typed
)

SELECT
  visit_id,
  customer_id,
  store_id,
  visit_date
FROM validated
WHERE visit_id    IS NOT NULL
  AND customer_id IS NOT NULL
  AND store_id    IS NOT NULL
  AND visit_date  IS NOT NULL
  AND visit_date <= DATE '2025-08-22'
  );