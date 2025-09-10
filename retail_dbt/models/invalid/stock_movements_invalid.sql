{{ config(
    materialized='view',
    schema='invalid',
    tags=['invalid','stock_movements']
) }}

WITH src AS (
  SELECT
    TRIM(CAST(movement_id   AS text)) AS movement_id_txt,
    TRIM(CAST(product_id    AS text)) AS product_id_txt,
    TRIM(CAST(store_id      AS text)) AS store_id_txt,
    TRIM(CAST(movement_type AS text)) AS movement_type_txt,
    TRIM(CAST(quantity      AS text)) AS quantity_txt,
    TRIM(REPLACE(CAST(movement_date AS text), E'\r','')) AS movement_date_txt
  FROM {{ source('raw','stock_movements') }}
),

checked AS (
  SELECT
    *,
    -- validate từng cột
    CASE 
      WHEN movement_id_txt !~ '^\d+$' OR movement_id_txt::int <= 0
        THEN 'invalid_movement_id'
    END AS r_id,

    CASE 
      WHEN product_id_txt !~ '^\d+$' OR product_id_txt::int <= 0
        THEN 'invalid_product_id'
    END AS r_product,

    CASE 
      WHEN store_id_txt !~ '^\d+$' OR store_id_txt::int <= 0
        THEN 'invalid_store_id'
    END AS r_store,

    CASE 
      WHEN upper(TRIM(movement_type_txt)) NOT IN ('IN','OUT','TRANSFER')
        THEN 'invalid_movement_type'
    END AS r_type,

    CASE 
      WHEN quantity_txt IS NULL OR quantity_txt = '' 
        OR lower(quantity_txt) IN ('unknown','na','n/a')
        OR quantity_txt !~ '^-?\d+$'
        OR quantity_txt::int <= 0
        THEN 'invalid_quantity'
    END AS r_qty,

    CASE 
      WHEN movement_date_txt IS NULL OR movement_date_txt = '' THEN 'date_null'
      WHEN movement_date_txt !~ '^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$'
        THEN 'invalid_format_date'
      WHEN to_char(to_date(movement_date_txt,'YYYY-MM-DD'),'YYYY-MM-DD') <> movement_date_txt
        THEN 'nonexistent_date'
      WHEN to_date(movement_date_txt,'YYYY-MM-DD') > DATE '2025-08-22'
        THEN 'future_date'
    END AS r_date
  FROM src
)

SELECT
  movement_id_txt,
  product_id_txt,
  store_id_txt,
  movement_type_txt,
  quantity_txt,
  movement_date_txt,

  array_to_string(
    array_remove(ARRAY[r_id, r_product, r_store, r_type, r_qty, r_date], NULL),
    '; '
  ) AS invalid_reason
FROM checked
WHERE r_id IS NOT NULL
   OR r_product IS NOT NULL
   OR r_store IS NOT NULL
   OR r_type IS NOT NULL
   OR r_qty IS NOT NULL
   OR r_date IS NOT NULL
