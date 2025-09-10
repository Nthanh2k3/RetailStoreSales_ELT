{{ config(
    materialized='view',
    schema='invalid',
    tags=['invalid','products']
) }}

-- 1) Raw -> text sạch
WITH src AS (
    SELECT
        TRIM(CAST(product_id  AS text)) AS product_id_txt,
        TRIM(CAST(name        AS text)) AS name_txt,
        TRIM(CAST(category_id AS text)) AS category_id_txt,
        TRIM(CAST(brand_id    AS text)) AS brand_id_txt,
        TRIM(CAST(supplier_id AS text)) AS supplier_id_txt,
        TRIM(CAST(price       AS text)) AS price_txt,
        TRIM(REPLACE(CAST(created_at AS text), E'\r','')) AS created_at_txt,
        -- làm sạch season: bỏ \r, gom space
        TRIM(REGEXP_REPLACE(REPLACE(CAST(season AS text), E'\r',''), '\s+', ' ', 'g')) AS season_txt
    FROM {{ source('raw','products') }}
),

-- 2) Parse/cast để kiểm tra
typed AS (
    SELECT
        src.*,
        CASE WHEN product_id_txt  ~ '^\d+$'         THEN product_id_txt::integer  END AS product_id_val,
        CASE WHEN category_id_txt ~ '^\d+$'         THEN category_id_txt::integer END AS category_id_val,
        CASE WHEN brand_id_txt    ~ '^\d+$'         THEN brand_id_txt::integer    END AS brand_id_val,
        CASE WHEN supplier_id_txt ~ '^\d+$'         THEN supplier_id_txt::integer END AS supplier_id_val,
        CASE WHEN price_txt       ~ '^\d+(\.\d+)?$' THEN price_txt::numeric       END AS price_val,
        CASE
          WHEN created_at_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(created_at_txt,'-','/'),'YYYY/FMMM/FMDD')::date
        END AS created_at_val,

        -- chuẩn hoá & map season linh hoạt
        lower(season_txt) AS season_low,
        CASE
          WHEN lower(season_txt) ~ '^spring$'                    THEN 'Spring'
          WHEN lower(season_txt) ~ '^summer$'                    THEN 'Summer'
          WHEN lower(season_txt) ~ '^(fall|autumn)$'             THEN 'Fall'
          WHEN lower(season_txt) ~ '^winter$'                    THEN 'Winter'
          WHEN lower(season_txt) ~ '^all[ _-]?year$'             THEN 'All Year'
          ELSE NULL
        END AS season_norm
    FROM src
),

-- 3) Cờ NA/rỗng
na_flags AS (
    SELECT
        *,
        (product_id_txt  IS NULL OR product_id_txt  = '' OR lower(product_id_txt)  IN ('na','n/a')) AS na_product_id,
        (name_txt        IS NULL OR name_txt        = '' OR lower(name_txt)        IN ('na','n/a')) AS na_name,
        (category_id_txt IS NULL OR category_id_txt = '' OR lower(category_id_txt) IN ('na','n/a')) AS na_category_id,
        (brand_id_txt    IS NULL OR brand_id_txt    = '' OR lower(brand_id_txt)    IN ('na','n/a')) AS na_brand_id,
        (supplier_id_txt IS NULL OR supplier_id_txt = '' OR lower(supplier_id_txt) IN ('na','n/a')) AS na_supplier_id,
        (price_txt       IS NULL OR price_txt       = '' OR lower(price_txt)       IN ('na','n/a')) AS na_price,
        (created_at_txt  IS NULL OR created_at_txt  = '' OR lower(created_at_txt)  IN ('na','n/a')) AS na_created_at,
        (season_txt      IS NULL OR season_txt      = '' OR lower(season_txt)      IN ('na','n/a')) AS na_season
    FROM typed
),

-- 4) Cờ invalid theo rule staging (price NOT NULL; created_at < 2025-08-22; season hợp lệ)
flags AS (
    SELECT
        *,
        (product_id_val  IS NULL OR product_id_val  <= 0) AS f_product_id_bad,
        (name_txt IS NULL OR name_txt='')                 AS f_name_bad,
        (category_id_val IS NULL OR category_id_val <= 0) AS f_category_id_bad,
        (brand_id_val    IS NULL OR brand_id_val    <= 0) AS f_brand_id_bad,
        (supplier_id_val IS NULL OR supplier_id_val <= 0) AS f_supplier_id_bad,

        (price_val IS NULL)                                AS f_price_null,
        (price_val IS NOT NULL AND price_val <= 0)         AS f_price_nonpositive,

        (created_at_val IS NULL)                           AS f_created_at_null_or_badfmt,
        (created_at_val IS NOT NULL AND created_at_val >= DATE '2025-08-22') AS f_created_at_on_or_after_cutoff,

        -- season: dùng season_norm đã chuẩn hoá; chỉ bad khi có giá trị nhưng không map được
        (season_norm IS NULL AND NOT na_season)            AS f_season_bad
    FROM na_flags
),

-- 5) Gộp lý do
reasons AS (
    SELECT
        *,
        array_remove(ARRAY[
            CASE WHEN na_product_id  THEN 'product_id missing/NA' END,
            CASE WHEN na_name        THEN 'name missing/NA' END,
            CASE WHEN na_category_id THEN 'category_id missing/NA' END,
            CASE WHEN na_brand_id    THEN 'brand_id missing/NA' END,
            CASE WHEN na_supplier_id THEN 'supplier_id missing/NA' END,
            CASE WHEN na_price       THEN 'price missing/NA' END,
            CASE WHEN na_created_at  THEN 'created_at missing/NA' END,
            CASE WHEN na_season      THEN 'season missing/NA' END,

            CASE WHEN NOT na_product_id  AND f_product_id_bad        THEN 'product_id not positive integer' END,
            CASE WHEN NOT na_name        AND f_name_bad              THEN 'name empty' END,
            CASE WHEN NOT na_category_id AND f_category_id_bad       THEN 'category_id not positive integer' END,
            CASE WHEN NOT na_brand_id    AND f_brand_id_bad          THEN 'brand_id not positive integer' END,
            CASE WHEN NOT na_supplier_id AND f_supplier_id_bad       THEN 'supplier_id not positive integer' END,
            CASE WHEN NOT na_price       AND f_price_null            THEN 'price is NULL' END,
            CASE WHEN NOT na_price       AND f_price_nonpositive     THEN 'price <= 0' END,
            CASE WHEN NOT na_created_at  AND f_created_at_null_or_badfmt THEN 'created_at invalid format' END,
            CASE WHEN f_created_at_on_or_after_cutoff               THEN 'created_at >= 2025-08-22' END,
            CASE WHEN f_season_bad                                   THEN 'season not in {Spring,Summer,Fall,Winter,All Year}' END
        ], NULL) AS reason_arr
    FROM flags
)

-- 6) Kết quả invalid
SELECT
    product_id_txt  AS product_id,
    name_txt        AS name,
    category_id_txt AS category_id,
    brand_id_txt    AS brand_id,
    supplier_id_txt AS supplier_id,
    price_txt       AS price,
    created_at_txt  AS created_at,
    season_txt      AS season,
    array_to_string(reason_arr, '; ') AS invalid_reason
FROM reasons
WHERE cardinality(reason_arr) > 0
