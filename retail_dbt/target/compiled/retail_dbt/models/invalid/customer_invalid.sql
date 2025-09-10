

WITH src AS (
    SELECT
        TRIM(CAST(customer_id AS text))            AS customer_id_text,
        TRIM(CAST(name AS text))                   AS name,
        LOWER(TRIM(CAST(email AS text)))           AS email,
        TRIM(CAST(phone AS text))                  AS phone,
        TRIM(CAST(loyalty_program_id AS text))     AS loyalty_program_id_text,
        TRIM(REPLACE(CAST(created_at AS text), E'\r','')) AS created_at_text
    FROM "postgres"."raw"."customers"
),
typed AS (
    SELECT
        *,
        CASE WHEN customer_id_text ~ '^[0-9]+$' THEN customer_id_text::integer END        AS customer_id_val,
        CASE WHEN loyalty_program_id_text ~ '^[0-9]+$' THEN loyalty_program_id_text::int  END AS loyalty_program_id_val,
        CASE
            WHEN created_at_text ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
            THEN to_timestamp(replace(created_at_text,'-','/'),'YYYY/FMMM/FMDD')
        END AS created_at_ts
    FROM src
),
flag AS (
    SELECT
        *,
        (customer_id_val IS NULL)                                              AS f_bad_customer_id,
        (email IS NULL OR email !~ '^[^@]+@[^@]+\.[^@]+$')                     AS f_bad_email,
        (phone IS NULL OR phone !~ '^[0-9]{9,15}$')                            AS f_bad_phone,   -- bạn chỉnh dài số nếu muốn
        (loyalty_program_id_val IS NULL)                                       AS f_bad_loyalty,
        (created_at_ts IS NULL)                                                AS f_bad_date,
        (created_at_ts IS NOT NULL AND created_at_ts > to_timestamp('2025/08/22','YYYY/MM/DD')) AS f_date_after_cutoff
    FROM typed
),
reasons AS (
    SELECT
        *,
        array_remove(ARRAY[
            CASE WHEN f_bad_customer_id   THEN 'Invalid customer_id' END,
            CASE WHEN f_bad_email         THEN 'Invalid email' END,
            CASE WHEN f_bad_phone         THEN 'Invalid phone' END,
            CASE WHEN f_bad_loyalty       THEN 'Invalid loyalty_program_id' END,
            CASE WHEN f_bad_date          THEN 'Invalid created_at format' END,
            CASE WHEN f_date_after_cutoff THEN 'created_at > 2025-08-22' END
        ], NULL) AS reason_arr
    FROM flag
)
SELECT
    customer_id_text   AS customer_id,
    name,
    email,
    phone,
    loyalty_program_id_text AS loyalty_program_id,
    created_at_text    AS created_at_raw,
    created_at_ts      AS created_at_parsed,
    array_to_string(reason_arr,'; ') AS invalid_reason
FROM reasons
WHERE cardinality(reason_arr) > 0