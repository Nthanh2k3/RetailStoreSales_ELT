

WITH src AS (
    SELECT
        TRIM(CAST(loyalty_program_id AS text)) AS loyalty_program_id_txt,
        TRIM(CAST(name               AS text)) AS name_txt,
        TRIM(CAST(points_per_dollar  AS text)) AS points_per_dollar_txt
    FROM "postgres"."raw"."loyalty_programs"
),


filtered AS (
    SELECT *
    FROM src
    WHERE loyalty_program_id_txt IS NOT NULL AND loyalty_program_id_txt <> '' AND lower(loyalty_program_id_txt) NOT IN ('na','n/a')
      AND name_txt               IS NOT NULL AND name_txt               <> '' AND lower(name_txt)               NOT IN ('na','n/a')
      AND points_per_dollar_txt  IS NOT NULL AND points_per_dollar_txt  <> '' AND lower(points_per_dollar_txt)  NOT IN ('na','n/a')
),

typed AS (
    SELECT
        
        CASE
          WHEN loyalty_program_id_txt ~ '^\s*\d+\s*$' THEN loyalty_program_id_txt::integer
        END AS loyalty_program_id,

        name_txt AS name,

        CASE
          WHEN points_per_dollar_txt ~ '^\s*\d+\s*$' THEN points_per_dollar_txt::integer
        END AS points_per_dollar
    FROM filtered
)

SELECT loyalty_program_id, name, points_per_dollar
FROM typed
WHERE loyalty_program_id IS NOT NULL
  AND name IS NOT NULL
  AND points_per_dollar IS NOT NULL