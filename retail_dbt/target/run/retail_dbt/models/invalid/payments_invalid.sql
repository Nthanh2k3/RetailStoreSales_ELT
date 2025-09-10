
  create view "postgres"."silver_invalid"."payments_invalid__dbt_tmp"
    
    
  as (
    

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
        *,
        CASE WHEN paid_at_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
             THEN to_timestamp(replace(paid_at_txt,'-','/'),'YYYY/FMMM/FMDD')
        END AS paid_at_ts
    FROM src
),

flags AS (
    SELECT
        *,
        /* thiếu/NA */
        (paid_at_txt IS NULL OR paid_at_txt = '' OR lower(paid_at_txt) IN ('na','n/a')) AS f_date_missing,
        /* có giá trị nhưng không khớp pattern */
        (paid_at_txt IS NOT NULL AND paid_at_txt <> '' AND lower(paid_at_txt) NOT IN ('na','n/a')
         AND paid_at_ts IS NULL) AS f_bad_format,
        /* qua cutoff */
        (paid_at_ts IS NOT NULL AND paid_at_ts > to_timestamp('2025/08/22','YYYY/MM/DD')) AS f_after_cutoff
    FROM typed
)

SELECT
    payment_id_txt AS payment_id,
    method,
    status,
    paid_at_txt    AS paid_at_raw,
    paid_at_ts     AS paid_at_parsed,
    CASE
        WHEN f_date_missing THEN 'paid_at missing/NA'
        WHEN f_bad_format   THEN 'paid_at invalid format'
        WHEN f_after_cutoff THEN 'paid_at > 2025-08-22'
    END AS invalid_reason
FROM flags
WHERE f_date_missing OR f_bad_format OR f_after_cutoff
  );