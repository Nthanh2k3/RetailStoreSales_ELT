

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
)

SELECT
    promotion_id,
    initcap(name_clean) AS name,
    start_date,
    end_date
FROM typed
WHERE promotion_id IS NOT NULL
  AND name_clean  IS NOT NULL
  AND start_date  IS NOT NULL
  AND end_date    IS NOT NULL
  AND start_date  < end_date