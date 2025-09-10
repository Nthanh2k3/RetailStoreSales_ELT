
  create view "postgres"."silver_staging"."stg_stock_movements__dbt_tmp"
    
    
  as (
    


WITH src AS (
  SELECT
    TRIM(CAST(movement_id   AS text)) AS movement_id_txt,
    TRIM(CAST(product_id    AS text)) AS product_id_txt,
    TRIM(CAST(store_id      AS text)) AS store_id_txt,
    TRIM(CAST(movement_type AS text)) AS movement_type_txt,
    TRIM(CAST(quantity      AS text)) AS quantity_txt,
    TRIM(REPLACE(CAST(movement_date AS text), E'\r','')) AS movement_date_txt
  FROM "postgres"."raw"."stock_movements"
),


typed AS (
  SELECT
    CASE WHEN movement_id_txt  ~ '^\d+$' THEN movement_id_txt::int  END AS movement_id,
    CASE WHEN product_id_txt   ~ '^\d+$' THEN product_id_txt::int   END AS product_id,
    CASE WHEN store_id_txt     ~ '^\d+$' THEN store_id_txt::int     END AS store_id,

    CASE
      WHEN upper(TRIM(movement_type_txt)) IN ('IN','OUT','TRANSFER')
      THEN upper(TRIM(movement_type_txt))
      ELSE NULL
    END AS movement_type,

    CASE
      WHEN quantity_txt IS NULL OR quantity_txt = '' THEN NULL
      WHEN lower(quantity_txt) IN ('unknown','na','n/a') THEN NULL
      WHEN quantity_txt ~ '^-?\d+$' THEN quantity_txt::int
      ELSE NULL
    END AS quantity,

  
    CASE
      WHEN movement_date_txt ~ '^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$'
      THEN to_date(movement_date_txt,'YYYY-MM-DD')
    END AS movement_date_raw,

    movement_date_txt
  FROM src
),


dated AS (
  SELECT
    movement_id, product_id, store_id, movement_type, quantity,
    CASE
      WHEN movement_date_raw IS NOT NULL
       AND to_char(movement_date_raw,'YYYY-MM-DD') = movement_date_txt
      THEN movement_date_raw
    END AS movement_date
  FROM typed
)

SELECT
  movement_id,
  product_id,
  store_id,
  movement_type,
  quantity,
  movement_date
FROM dated
WHERE movement_id   IS NOT NULL AND movement_id   > 0
  AND product_id    IS NOT NULL AND product_id    > 0
  AND store_id      IS NOT NULL AND store_id      > 0
  AND movement_type IS NOT NULL
  AND quantity      IS NOT NULL AND quantity      > 0
  AND movement_date IS NOT NULL
  AND movement_date <= DATE '2025-08-22'
  );