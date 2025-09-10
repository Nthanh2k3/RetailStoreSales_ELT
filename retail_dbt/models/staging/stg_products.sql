{{ config(
    materialized='view',
    schema='staging',
    tags=['staging','products']
) }}

WITH src AS (
  SELECT
    TRIM(CAST(product_id  AS text)) AS product_id_txt,
    TRIM(CAST(name        AS text)) AS name_txt,
    TRIM(CAST(category_id AS text)) AS category_id_txt,
    TRIM(CAST(brand_id    AS text)) AS brand_id_txt,
    TRIM(CAST(supplier_id AS text)) AS supplier_id_txt,
    TRIM(CAST(price       AS text)) AS price_txt,
    TRIM(REPLACE(CAST(created_at AS text), E'\r','')) AS created_at_txt,
    -- 👇 loại \r,\n,\t và collapse space cho season
    TRIM(REGEXP_REPLACE(REPLACE(CAST(season AS text), E'\r',''), '\s+', ' ', 'g')) AS season_txt
  FROM {{ source('raw','products') }}
),

typed AS (
  SELECT
    CASE WHEN product_id_txt  ~ '^\d+$'          THEN product_id_txt::integer  END AS product_id,
    NULLIF(name_txt,'')                                 AS name,
    CASE WHEN category_id_txt ~ '^\d+$'          THEN category_id_txt::integer END AS category_id,
    CASE WHEN brand_id_txt    ~ '^\d+$'          THEN brand_id_txt::integer    END AS brand_id,
    CASE WHEN supplier_id_txt ~ '^\d+$'          THEN supplier_id_txt::integer END AS supplier_id,
    CASE WHEN price_txt       ~ '^\d+(\.\d+)?$'  THEN price_txt::numeric       END AS price,
    CASE
      WHEN created_at_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
      THEN to_timestamp(replace(created_at_txt,'-','/'),'YYYY/FMMM/FMDD')::date
    END AS created_at,

    
    CASE
      WHEN lower(season_txt) ~ '^spring$'                    THEN 'Spring'
      WHEN lower(season_txt) ~ '^summer$'                    THEN 'Summer'
      WHEN lower(season_txt) ~ '^(fall|autumn)$'             THEN 'Fall'
      WHEN lower(season_txt) ~ '^winter$'                    THEN 'Winter'
      WHEN lower(season_txt) ~ '^all[ _-]?year$'             THEN 'All Year'
      ELSE NULL
    END AS season
  FROM src
)

SELECT product_id, name, category_id, brand_id, supplier_id, price, created_at, season
FROM typed
WHERE price IS NOT NULL
  AND created_at IS NOT NULL
  AND created_at < '2025-08-22'
