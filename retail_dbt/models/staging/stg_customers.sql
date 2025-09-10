{{ config(
    materialized='view',
    schema='staging',
    tags=['staging','customers']
) }}

WITH src AS (
    SELECT
        TRIM(CAST(customer_id AS text))                        AS customer_id_text,
        TRIM(CAST(name        AS text))                        AS name,
        LOWER(TRIM(CAST(email AS text)))                       AS email,
        TRIM(CAST(phone       AS text))                        AS phone_text,
        TRIM(CAST(loyalty_program_id AS text))                 AS loyalty_program_id_text,
        TRIM(REPLACE(CAST(created_at AS text), E'\r',''))      AS created_at_text
    FROM {{ source('raw','customers') }}
),
typed AS (
    SELECT
        CASE WHEN customer_id_text ~ '^[0-9]+$'
             THEN customer_id_text::integer END                AS customer_id,
        name,
        email,
        phone_text                                             AS phone,
        CASE WHEN loyalty_program_id_text ~ '^[0-9]+$'
             THEN loyalty_program_id_text::integer END         AS loyalty_program_id,

        CASE
            WHEN created_at_text ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
            THEN to_timestamp(replace(created_at_text,'-','/'),'YYYY/FMMM/FMDD')
            ELSE NULL
        END                                                    AS created_at
    FROM src
)
SELECT
    customer_id, name, email, phone, loyalty_program_id, created_at
FROM typed
WHERE created_at IS NOT NULL
  AND created_at <= to_timestamp('2025/08/22','YYYY/MM/DD')
