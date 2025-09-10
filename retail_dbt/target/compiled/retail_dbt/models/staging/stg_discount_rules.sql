

WITH src AS (
    SELECT
        TRIM(CAST(rule_id AS text))          AS rule_id_txt,
        TRIM(CAST(product_id AS text))       AS product_id_txt,
        TRIM(CAST(discount_type AS text))    AS discount_type_txt,
        TRIM(CAST(value AS text))            AS value_txt,
        TRIM(REPLACE(CAST(valid_from AS text), E'\r','')) AS valid_from_txt,
        TRIM(REPLACE(CAST(valid_to   AS text), E'\r','')) AS valid_to_txt
    FROM "postgres"."raw"."discount_rules"
),
norm AS (
    SELECT
        NULLIF(rule_id_txt, '')          AS rule_id_clean,
        NULLIF(product_id_txt, '')       AS product_id_clean,
        NULLIF(discount_type_txt, '')    AS discount_type_clean,
        NULLIF(value_txt, '')            AS value_clean,
        NULLIF(valid_from_txt, '')       AS valid_from_clean,
        NULLIF(valid_to_txt, '')         AS valid_to_clean
    FROM src
),
typed AS (
    SELECT
        CASE WHEN rule_id_clean    ~ '^[0-9]+$'               THEN rule_id_clean::integer END          AS rule_id,
        CASE WHEN product_id_clean ~ '^[0-9]+$'               THEN product_id_clean::integer END       AS product_id,

        -- bỏ (?i) -> dùng ~* để so khớp không phân biệt hoa thường
        CASE WHEN discount_type_clean ~* '^(na|n/a)$' THEN NULL
             ELSE lower(discount_type_clean) END                                                            AS discount_type,

        CASE WHEN value_clean ~* '^(na|n/a)$' THEN NULL
             WHEN value_clean ~ '^[0-9]+(\.[0-9]+)?$' THEN value_clean::numeric
             ELSE NULL END                                                                                  AS value,

        CASE WHEN valid_from_clean ~* '^(na|n/a)$' THEN NULL
             WHEN valid_from_clean ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
                  THEN to_timestamp(replace(valid_from_clean,'-','/'),'YYYY/FMMM/FMDD')
             ELSE NULL END                                                                                  AS valid_from,

        CASE WHEN valid_to_clean ~* '^(na|n/a)$' THEN NULL
             WHEN valid_to_clean ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
                  THEN to_timestamp(replace(valid_to_clean,'-','/'),'YYYY/FMMM/FMDD')
             ELSE NULL END                                                                                  AS valid_to
    FROM norm
),
staging_data AS (
    SELECT rule_id, product_id, discount_type, value, valid_from, valid_to
    FROM typed
    WHERE rule_id IS NOT NULL
      AND product_id IS NOT NULL
      AND discount_type IS NOT NULL
      AND value IS NOT NULL
      AND valid_from IS NOT NULL
      AND valid_to   IS NOT NULL
      AND valid_from < valid_to
)
SELECT * FROM staging_data