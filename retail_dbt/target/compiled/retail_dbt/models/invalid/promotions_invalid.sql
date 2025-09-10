

WITH src AS (
    SELECT
        TRIM(CAST(promotion_id AS text))                       AS promotion_id_txt,
        TRIM(CAST(name AS text))                               AS name_txt,
        TRIM(REPLACE(CAST(start_date AS text), E'\r',''))      AS start_date_txt,
        TRIM(REPLACE(CAST(end_date   AS text), E'\r',''))      AS end_date_txt
    FROM "postgres"."raw"."promotions"
),

typed AS (
    SELECT
        src.*,
        CASE WHEN promotion_id_txt ~ '^\d+$' THEN promotion_id_txt::int END AS promotion_id,
        NULLIF(NULLIF(lower(name_txt),'na'),'') AS name_clean,
        CASE
          WHEN start_date_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(start_date_txt,'-','/'),'YYYY/FMMM/FMDD')::date
        END AS start_date,
        CASE
          WHEN end_date_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(end_date_txt,'-','/'),'YYYY/FMMM/FMDD')::date
        END AS end_date
    FROM src
),

flags AS (
    SELECT
        *,
        (promotion_id IS NULL) AS f_bad_id,
        (name_clean IS NULL)   AS f_bad_name,
        (start_date IS NULL)   AS f_bad_start,
        (end_date   IS NULL)   AS f_bad_end,
        (start_date IS NOT NULL AND end_date IS NOT NULL AND start_date >= end_date) AS f_bad_order
    FROM typed
),

reasons AS (
    SELECT
        *,
        array_remove(ARRAY[
            CASE WHEN f_bad_id    THEN 'invalid promotion_id' END,
            CASE WHEN f_bad_name  THEN 'name missing/NA' END,
            CASE WHEN f_bad_start THEN 'invalid start_date' END,
            CASE WHEN f_bad_end   THEN 'invalid end_date' END,
            CASE WHEN f_bad_order THEN 'start_date >= end_date' END
        ], NULL) AS reason_arr
    FROM flags
)

SELECT
    promotion_id_txt AS promotion_id,
    name_txt         AS name,
    start_date_txt   AS start_date,
    end_date_txt     AS end_date,
    array_to_string(reason_arr,'; ') AS invalid_reason
FROM reasons
WHERE cardinality(reason_arr) > 0