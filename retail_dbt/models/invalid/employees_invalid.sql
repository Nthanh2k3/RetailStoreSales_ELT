{{ config(
    materialized='view',
    schema='invalid',
    tags=['invalid','employees']
) }}

WITH src AS (
    SELECT
        TRIM(CAST(employee_id AS text)) AS employee_id_txt,
        TRIM(CAST(name        AS text)) AS name_txt,
        TRIM(CAST(role        AS text)) AS role_txt,
        TRIM(CAST(store_id    AS text)) AS store_id_txt
    FROM {{ source('raw','employees') }}
),

flags AS (
    SELECT
        *,
        (employee_id_txt IS NULL OR employee_id_txt = '' OR lower(employee_id_txt) IN ('na','n/a')) AS f_bad_employee_id,
        (name_txt        IS NULL OR name_txt        = '' OR lower(name_txt)        IN ('na','n/a')) AS f_bad_name,
        (role_txt        IS NULL OR role_txt        = '' OR lower(role_txt)        IN ('na','n/a')) AS f_bad_role,
        (store_id_txt    IS NULL OR store_id_txt    = '' OR lower(store_id_txt)    IN ('na','n/a')) AS f_bad_store_id
    FROM src
),

reasons AS (
    SELECT
        *,
        array_remove(ARRAY[
            CASE WHEN f_bad_employee_id THEN 'NULL/empty/NA in employee_id' END,
            CASE WHEN f_bad_name        THEN 'NULL/empty/NA in name' END,
            CASE WHEN f_bad_role        THEN 'NULL/empty/NA in role' END,
            CASE WHEN f_bad_store_id    THEN 'NULL/empty/NA in store_id' END
        ], NULL) AS reason_arr
    FROM flags
)

SELECT
    employee_id_txt AS employee_id,
    name_txt        AS name,
    role_txt        AS role,
    store_id_txt    AS store_id,
    array_to_string(reason_arr, '; ') AS invalid_reason
FROM reasons
WHERE cardinality(reason_arr) > 0
