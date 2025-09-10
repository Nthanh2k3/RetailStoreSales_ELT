

WITH src AS (
  SELECT
    TRIM(CAST(visit_id    AS text)) AS visit_id_txt,
    TRIM(CAST(customer_id AS text)) AS customer_id_txt,
    TRIM(CAST(store_id    AS text)) AS store_id_txt,
    TRIM(REPLACE(CAST(visit_date AS text), E'\r','')) AS visit_date_txt
  FROM "postgres"."raw"."store_visits"
),

checked AS (
  SELECT
    *,
    -- id checks
    CASE WHEN visit_id_txt    !~ '^\d+$'                  THEN 'invalid visit_id' END AS r_visit_id,
    CASE WHEN customer_id_txt !~ '^\d+$'                  THEN 'invalid customer_id' END AS r_customer_id,
    CASE WHEN store_id_txt    !~ '^\d+$'                  THEN 'invalid store_id' END AS r_store_id,

    -- date checks
    CASE 
      WHEN visit_date_txt IS NULL OR visit_date_txt = '' THEN 'visit_date is null/empty'
      WHEN visit_date_txt !~ '^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$'
           THEN 'invalid date format'
      WHEN to_char(to_date(visit_date_txt,'YYYY-MM-DD'),'YYYY-MM-DD') <> visit_date_txt
           THEN 'nonexistent calendar date'
      WHEN to_date(visit_date_txt,'YYYY-MM-DD') > DATE '2025-08-22'
           THEN 'visit_date > 2025-08-22'
    END AS r_visit_date
  FROM src
)

SELECT
  visit_id_txt    AS visit_id,
  customer_id_txt AS customer_id,
  store_id_txt    AS store_id,
  visit_date_txt  AS visit_date,
  array_to_string(
    array_remove(ARRAY[r_visit_id, r_customer_id, r_store_id, r_visit_date], NULL),
    '; '
  ) AS invalid_reason
FROM checked
WHERE r_visit_id    IS NOT NULL
   OR r_customer_id IS NOT NULL
   OR r_store_id    IS NOT NULL
   OR r_visit_date  IS NOT NULL