{{ config(
    materialized='table',
    schema='invalid',
    tags=['invalid','returns']
) }}

WITH src AS (
    SELECT
        TRIM(CAST(return_id   AS text))                               AS return_id_txt,
        TRIM(CAST(item_id     AS text))                               AS item_id_txt,
        TRIM(REGEXP_REPLACE(REPLACE(CAST(reason AS text), E'\r',''), '\s+', ' ', 'g')) AS reason_txt,
        TRIM(REPLACE(CAST(return_date AS text), E'\r',''))            AS return_date_txt
    FROM {{ source('raw','returns') }}
),

typed AS (
    SELECT
        return_id_txt,
        item_id_txt,
        reason_txt,
        return_date_txt,

        CASE WHEN return_id_txt ~ '^\d+$' THEN return_id_txt::int END AS return_id,
        CASE WHEN item_id_txt   ~ '^\d+$' THEN item_id_txt::int   END AS item_id,

        CASE
          WHEN reason_txt IS NULL OR reason_txt = '' THEN NULL
          WHEN lower(reason_txt) IN ('na','n/a') THEN NULL
          ELSE reason_txt
        END AS reason_clean,

        CASE
          WHEN return_date_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(return_date_txt,'-','/'),'YYYY/FMMM/FMDD')::date
        END AS return_date_clean
    FROM src
)

SELECT
    return_id_txt        AS return_id_raw,
    item_id_txt          AS item_id_raw,
    reason_txt           AS reason_raw,
    return_date_txt      AS return_date_raw,
    return_id,
    item_id,
    reason_clean,
    return_date_clean,

    -- lý do bị loại
    CASE
        WHEN return_id IS NULL OR item_id IS NULL
            THEN 'invalid_id'
        WHEN reason_clean IS NULL
            THEN 'invalid_reason'
        WHEN return_date_clean IS NULL
            THEN 'invalid_date_format'
        WHEN return_date_clean > DATE '2025-08-22'
            THEN 'future_date'
    END AS invalid_reason
FROM typed
WHERE
      return_id IS NULL
   OR item_id IS NULL
   OR reason_clean IS NULL
   OR return_date_clean IS NULL
   OR return_date_clean > DATE '2025-08-22'
