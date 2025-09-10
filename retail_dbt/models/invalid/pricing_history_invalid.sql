{{ config(
    materialized='view',
    schema='invalid',
    tags=['invalid','pricing_history']
) }}

-- 1) Lấy dữ liệu thô và chuẩn hoá text
WITH src AS (
    SELECT
        TRIM(CAST(history_id     AS text))                         AS history_id_raw,
        TRIM(CAST(product_id     AS text))                         AS product_id_raw,
        TRIM(CAST(price          AS text))                         AS price_raw,
        TRIM(REPLACE(CAST(effective_date AS text), E'\r',''))      AS effective_date_raw
    FROM {{ source('raw','pricing_history') }}
),

-- 2) Parse/cast về kiểu dùng để kiểm tra
typed AS (
    SELECT
        history_id_raw,
        product_id_raw,
        price_raw,
        effective_date_raw,

        CASE WHEN price_raw ~ '^-?\d+(\.\d+)?$' THEN price_raw::numeric END AS price_num,
        CASE
          WHEN effective_date_raw ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(effective_date_raw, '-', '/'),'YYYY/FMMM/FMDD')::date
        END AS effective_date_cast
    FROM src
),

-- 3) Cờ thiếu/NA
na_flags AS (
    SELECT
        history_id_raw,
        product_id_raw,
        price_raw,
        effective_date_raw,
        price_num,
        effective_date_cast,

        (price_raw IS NULL OR price_raw = '' OR lower(price_raw) IN ('na','n/a')) AS f_price_missing,
        (effective_date_raw IS NULL OR effective_date_raw = ''
            OR lower(effective_date_raw) IN ('na','n/a'))                         AS f_date_missing
    FROM typed
),

-- 4) Các cờ còn lại
flags AS (
    SELECT
        history_id_raw,
        product_id_raw,
        price_raw,
        effective_date_raw,
        price_num,
        effective_date_cast,
        f_price_missing,
        f_date_missing,

        (price_num IS NULL AND NOT f_price_missing)        AS f_price_not_numeric,
        (price_num IS NOT NULL AND price_num <= 0)         AS f_price_nonpositive,
        (effective_date_cast IS NULL AND NOT f_date_missing) AS f_date_bad_format,
        (effective_date_cast IS NOT NULL
         AND effective_date_cast > CURRENT_DATE)           AS f_date_future
    FROM na_flags
),

-- 5) Gộp lý do
reasons AS (
    SELECT
        history_id_raw,
        product_id_raw,
        price_raw,
        effective_date_raw,
        price_num,
        effective_date_cast,
        array_remove(ARRAY[
            CASE WHEN f_price_missing      THEN 'price missing/NA' END,
            CASE WHEN f_price_not_numeric  THEN 'price not numeric' END,
            CASE WHEN f_price_nonpositive  THEN 'price <= 0' END,
            CASE WHEN f_date_missing       THEN 'effective_date missing/NA' END,
            CASE WHEN f_date_bad_format    THEN 'effective_date invalid format' END,
            CASE WHEN f_date_future        THEN 'effective_date in the future' END
        ], NULL) AS reason_arr
    FROM flags
)

-- 6) Kết quả invalid
SELECT
    history_id_raw      AS history_id,
    product_id_raw      AS product_id,
    price_raw           AS price_raw,
    price_num           AS price_parsed,
    effective_date_raw  AS effective_date_raw,
    effective_date_cast AS effective_date_parsed,
    array_to_string(reason_arr, '; ') AS invalid_reason
FROM reasons
WHERE cardinality(reason_arr) > 0
