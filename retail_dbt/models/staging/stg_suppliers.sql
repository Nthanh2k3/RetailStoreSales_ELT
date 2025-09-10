{{ config(
    materialized='view',
    schema='staging',
    tags=['staging','suppliers']
) }}

WITH src AS (
    SELECT
        supplier_id::int                               AS supplier_id,
        NULLIF(TRIM(name), '')                         AS name,
        NULLIF(TRIM(contact_info), '')                 AS contact_info
    FROM raw.suppliers
)

SELECT
    supplier_id,
    name,
    contact_info
FROM src
