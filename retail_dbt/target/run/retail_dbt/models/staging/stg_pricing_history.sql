
  create view "postgres"."silver_staging"."stg_pricing_history__dbt_tmp"
    
    
  as (
    

WITH src AS (
    SELECT
        TRIM(CAST(history_id     AS text)) AS history_id_txt,
        TRIM(CAST(product_id     AS text)) AS product_id_txt,
        TRIM(CAST(price          AS text)) AS price_txt,
        TRIM(REPLACE(CAST(effective_date AS text), E'\r','')) AS effective_date_txt
    FROM "postgres"."raw"."pricing_history"
),

typed AS (
    SELECT
        
        CASE WHEN history_id_txt ~ '^\d+$'  THEN history_id_txt::integer  END AS history_id,
        CASE WHEN product_id_txt ~ '^\d+$'  THEN product_id_txt::integer  END AS product_id,

        
        CASE WHEN price_txt ~ '^-?\d+(\.\d+)?$' THEN price_txt::numeric END AS price,

        
        CASE
          WHEN effective_date_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(effective_date_txt, '-', '/'),'YYYY/FMMM/FMDD')::date
          ELSE NULL
        END AS effective_date
    FROM src
)

SELECT
    history_id,
    product_id,
    price,
    effective_date
FROM typed
WHERE price IS NOT NULL
  AND price > 0
  AND effective_date IS NOT NULL
  AND effective_date <= CURRENT_DATE
  );