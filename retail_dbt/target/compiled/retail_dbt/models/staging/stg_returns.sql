

WITH src AS (
    SELECT
        TRIM(CAST(return_id   AS text))                               AS return_id_txt,
        TRIM(CAST(item_id     AS text))                               AS item_id_txt,
    
        TRIM(REGEXP_REPLACE(REPLACE(CAST(reason AS text), E'\r',''), '\s+', ' ', 'g')) AS reason_txt,
        
        TRIM(REPLACE(CAST(return_date AS text), E'\r',''))            AS return_date_txt
    FROM "postgres"."raw"."returns"
),

typed AS (
    SELECT
        CASE WHEN return_id_txt ~ '^\d+$' THEN return_id_txt::int END AS return_id,
        CASE WHEN item_id_txt   ~ '^\d+$' THEN item_id_txt::int   END AS item_id,

        CASE
          WHEN reason_txt IS NULL OR reason_txt = '' THEN NULL
          WHEN lower(reason_txt) IN ('na','n/a') THEN NULL
          ELSE reason_txt
        END AS reason,

        CASE
          WHEN return_date_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(return_date_txt,'-','/'),'YYYY/FMMM/FMDD')::date
        END AS return_date
    FROM src
)

SELECT
    return_id,
    item_id,
    reason,
    return_date
FROM typed
WHERE return_id   IS NOT NULL
  AND item_id     IS NOT NULL
  AND reason      IS NOT NULL
  AND return_date IS NOT NULL
  AND return_date <= DATE '2025-08-22'