{{ config(
    materialized='view',
    schema='staging',
    tags=['staging','employees']
) }}

WITH src AS (
    SELECT
        TRIM(CAST(employee_id AS text)) AS employee_id_txt,
        TRIM(CAST(name        AS text)) AS name_txt,
        TRIM(CAST(role        AS text)) AS role_txt,
        TRIM(CAST(store_id    AS text)) AS store_id_txt
    FROM {{ source('raw','employees') }}
),

filtered AS (
    SELECT *
    FROM src
    WHERE employee_id_txt IS NOT NULL AND employee_id_txt <> '' AND lower(employee_id_txt) NOT IN ('na','n/a')
      AND name_txt        IS NOT NULL AND name_txt <> ''        AND lower(name_txt)        NOT IN ('na','n/a')
      AND role_txt        IS NOT NULL AND role_txt <> ''        AND lower(role_txt)        NOT IN ('na','n/a')
      AND store_id_txt    IS NOT NULL AND store_id_txt <> ''    AND lower(store_id_txt)    NOT IN ('na','n/a')
),

typed AS (
    SELECT
        CAST(employee_id_txt AS integer) AS employee_id,
        name_txt  AS name,
        role_txt  AS role,
        CAST(store_id_txt AS integer)    AS store_id
    FROM filtered
)

SELECT *
FROM typed
