
  create view "postgres"."silver_staging"."stg_purchase_orders__dbt_tmp"
    
    
  as (
    

WITH src AS (
    SELECT
        TRIM(CAST(order_id AS text))       AS order_id_txt,
        TRIM(CAST(supplier_id AS text))    AS supplier_id_txt,
        TRIM(CAST(order_date AS text))     AS order_date_txt,
        TRIM(CAST(status AS text))         AS status_txt
    FROM "postgres"."raw"."purchase_orders"
),

typed AS (
    SELECT
        CASE WHEN order_id_txt ~ '^\d+$' THEN order_id_txt::int END        AS order_id,
        CASE WHEN supplier_id_txt ~ '^\d+$' THEN supplier_id_txt::int END  AS supplier_id,

        CASE
          WHEN order_date_txt ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
          THEN to_timestamp(replace(order_date_txt,'-','/'),'YYYY/FMMM/FMDD')::date
        END AS order_date,

        NULLIF(NULLIF(lower(status_txt),'na'),'') AS status_clean
    FROM src
)

SELECT
    order_id,
    supplier_id,
    order_date,
    initcap(status_clean) AS status
FROM typed
WHERE order_id IS NOT NULL
  AND supplier_id IS NOT NULL
  AND order_date IS NOT NULL
  AND status_clean IS NOT NULL
  AND order_date <= DATE '2025-08-22'
  );