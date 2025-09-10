
  create view "postgres"."silver_staging"."stg_tax_rules__dbt_tmp"
    
    
  as (
    

WITH src AS (
    SELECT
        tax_id::int                                    AS tax_id,
        product_id::int                                AS product_id,
        NULLIF(NULLIF(NULLIF(LOWER(TRIM(tax_rate)), 'none'), 'n/a'), '') AS tax_rate_clean,
        TRIM(region)                                   AS region
    FROM raw.tax_rules
),

typed AS (
    SELECT
        tax_id,
        product_id,
        CASE
            WHEN tax_rate_clean ~ '^[0-9]+(\.[0-9]+)?$'
                 AND tax_rate_clean::numeric > 0
            THEN tax_rate_clean::numeric
        END AS tax_rate,
        region
    FROM src
)

SELECT *
FROM typed
WHERE tax_rate IS NOT NULL
  );