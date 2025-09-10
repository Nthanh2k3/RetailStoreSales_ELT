{{ config(
    materialized='view',
    schema='staging',
    tags=['staging', 'customer_feedback']
) }}

WITH source_data AS (
    SELECT
        -- cast các ID về int
        CASE
            WHEN feedback_id IS NULL OR TRIM(feedback_id::text) = '' 
                 OR LOWER(TRIM(feedback_id::text)) IN ('na','null','n/a') 
            THEN NULL
            ELSE CAST(regexp_replace(TRIM(feedback_id::text), '[^0-9]', '', 'g') AS int)
        END AS feedback_id,

        CASE
            WHEN customer_id IS NULL OR TRIM(customer_id::text) = '' 
                 OR LOWER(TRIM(customer_id::text)) IN ('na','null','n/a') 
            THEN NULL
            ELSE CAST(regexp_replace(TRIM(customer_id::text), '[^0-9]', '', 'g') AS int)
        END AS customer_id,

        CASE
            WHEN store_id IS NULL OR TRIM(store_id::text) = '' 
                 OR LOWER(TRIM(store_id::text)) IN ('na','null','n/a') 
            THEN NULL
            ELSE CAST(regexp_replace(TRIM(store_id::text), '[^0-9]', '', 'g') AS int)
        END AS store_id,

        CASE
            WHEN product_id IS NULL OR TRIM(product_id::text) = '' 
                 OR LOWER(TRIM(product_id::text)) IN ('na','null','n/a') 
            THEN NULL
            ELSE CAST(regexp_replace(TRIM(product_id::text), '[^0-9]', '', 'g') AS int)
        END AS product_id,

        CASE
            WHEN rating IS NULL THEN NULL
            WHEN TRIM(LOWER(CAST(rating AS text))) IN ('na', '') THEN NULL
            WHEN TRIM(CAST(rating AS text)) ~ '^[0-9]+$' 
            THEN CAST(TRIM(CAST(rating AS text)) AS integer)
            ELSE NULL
        END AS rating,

        TRIM(CAST(comments AS text)) AS comments,

        CASE
            WHEN feedback_date IS NULL THEN NULL
            WHEN TRIM(LOWER(CAST(feedback_date AS text))) IN ('na', '') THEN NULL
            ELSE TRIM(REPLACE(CAST(feedback_date AS text), E'\r', ''))
        END AS feedback_date_text
    FROM {{ source('raw', 'customer_feedback') }}
),

dated AS (
    SELECT
        feedback_id,
        customer_id,
        store_id,
        product_id,
        rating,
        comments,
        feedback_date_text,

        (
            feedback_date_text ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
        ) AS is_valid_date_text,

        CASE
            WHEN feedback_date_text IS NOT NULL
             AND feedback_date_text ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
            THEN to_timestamp(replace(feedback_date_text, '-', '/'), 'YYYY/FMMM/FMDD')
            ELSE NULL
        END AS feedback_date_ts
    FROM source_data
),

staging_data AS (
    SELECT
        feedback_id::int      AS feedback_id,
        customer_id::int      AS customer_id,
        store_id::int         AS store_id,
        product_id::int       AS product_id,
        rating::integer       AS rating,
        comments::text        AS comments,
        feedback_date_ts      AS feedback_date
    FROM dated
    WHERE
        feedback_id IS NOT NULL
        AND customer_id IS NOT NULL
        AND store_id   IS NOT NULL
        AND product_id IS NOT NULL
        AND rating BETWEEN 1 AND 5
        AND is_valid_date_text
        AND feedback_date_ts IS NOT NULL
        AND feedback_date_ts <= to_timestamp('2025/08/22', 'YYYY/MM/DD')
)

SELECT
    feedback_id,
    customer_id,
    store_id,
    product_id,
    rating,
    comments,
    feedback_date
FROM staging_data
