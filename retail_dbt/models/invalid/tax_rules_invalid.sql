{{ config(
    materialized='view',
    schema='invalid',
    tags=['invalid','tax_rules']
) }}

WITH src AS (
    SELECT
        tax_id::int                                    AS tax_id,
        product_id::int                                AS product_id,
        TRIM(LOWER(tax_rate))                          AS tax_rate_raw,
        TRIM(region)                                   AS region
    FROM raw.tax_rules
),

invalid AS (
    SELECT
        tax_id,
        product_id,
        tax_rate_raw,
        region,
        CASE
            WHEN tax_rate_raw IS NULL OR tax_rate_raw = '' THEN 'tax_rate_null_or_blank'
            WHEN tax_rate_raw IN ('none','n/a') THEN 'tax_rate_invalid_string'
            WHEN tax_rate_raw ~ '^[0-9]+(\.[0-9]+)?$' AND tax_rate_raw::numeric = 0 THEN 'tax_rate_zero'
            ELSE 'tax_rate_unknown_format'
        END AS invalid_reason
    FROM src
    WHERE 
        tax_rate_raw IS NULL
        OR tax_rate_raw = ''
        OR tax_rate_raw IN ('none','n/a')
        OR (tax_rate_raw ~ '^[0-9]+(\.[0-9]+)?$' AND tax_rate_raw::numeric = 0)
        OR tax_rate_raw !~ '^[0-9]+(\.[0-9]+)?$'
)

SELECT *
FROM invalid
