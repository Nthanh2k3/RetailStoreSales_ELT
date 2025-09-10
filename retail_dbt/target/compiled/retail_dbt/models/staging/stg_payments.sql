

WITH src AS (
    SELECT
        TRIM(CAST(payment_id AS text))                 AS payment_id_txt,
        TRIM(CAST(method     AS text))                 AS method,
        TRIM(CAST(status     AS text))                 AS status,
        TRIM(REPLACE(CAST(paid_at AS text), E'\r','')) AS paid_at_txt
    FROM "postgres"."raw"."payments"
),

typed AS (
    SELECT
        
        CASE WHEN payment_id_txt ~ '^\s*\d+\s*$' THEN payment_id_txt::integer END AS payment_id,
        method,
        status,

        
        CASE
          WHEN paid_at_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(paid_at_txt,'-','/'),'YYYY/FMMM/FMDD')
          ELSE NULL
        END AS paid_at
    FROM src
)

SELECT
    payment_id,
    method,
    status,
    paid_at
FROM typed
WHERE paid_at IS NOT NULL
  AND paid_at <= to_timestamp('2025/08/22','YYYY/MM/DD')