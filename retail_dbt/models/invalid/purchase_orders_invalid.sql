{{ config(
    materialized='view',
    schema='invalid',
    tags=['invalid','purchase_orders']
) }}

WITH src AS (
    SELECT
        TRIM(CAST(order_id AS text))       AS order_id_txt,
        TRIM(CAST(supplier_id AS text))    AS supplier_id_txt,
        TRIM(CAST(order_date AS text))     AS order_date_txt,
        TRIM(CAST(status AS text))         AS status_txt
    FROM {{ source('raw','purchase_orders') }}
),

typed AS (
    SELECT
        src.*,
        CASE WHEN order_id_txt ~ '^\d+$' THEN order_id_txt::int END        AS order_id,
        CASE WHEN supplier_id_txt ~ '^\d+$' THEN supplier_id_txt::int END  AS supplier_id,
        CASE
          WHEN order_date_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(order_date_txt,'-','/'),'YYYY/FMMM/FMDD')::date
        END AS order_date,
        NULLIF(NULLIF(lower(status_txt),'na'),'') AS status_clean
    FROM src
),

flags AS (
    SELECT *,
        (order_id IS NULL)                         AS f_bad_id,
        (supplier_id IS NULL)                      AS f_bad_supplier,
        (order_date IS NULL)                       AS f_bad_date,
        (order_date IS NOT NULL AND order_date > DATE '2025-08-22') AS f_future_date,
        (status_clean IS NULL)                     AS f_bad_status
    FROM typed
),

reasons AS (
    SELECT *,
        array_remove(ARRAY[
            CASE WHEN f_bad_id       THEN 'invalid order_id' END,
            CASE WHEN f_bad_supplier THEN 'invalid supplier_id' END,
            CASE WHEN f_bad_date     THEN 'invalid order_date' END,
            CASE WHEN f_future_date  THEN 'order_date > 2025-08-22' END,
            CASE WHEN f_bad_status   THEN 'status missing/NA' END
        ], NULL) AS reason_arr
    FROM flags
)

SELECT
    order_id_txt   AS order_id,
    supplier_id_txt AS supplier_id,
    order_date_txt AS order_date,
    status_txt     AS status,
    array_to_string(reason_arr,'; ') AS invalid_reason
FROM reasons
WHERE cardinality(reason_arr) > 0
