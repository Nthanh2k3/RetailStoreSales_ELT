

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
        NULLIF(rule_id_txt, '')        AS rule_id_clean,
        NULLIF(product_id_txt, '')     AS product_id_clean,
        NULLIF(discount_type_txt, '')  AS discount_type_clean,
        NULLIF(value_txt, '')          AS value_clean,
        NULLIF(valid_from_txt, '')     AS valid_from_clean,
        NULLIF(valid_to_txt, '')       AS valid_to_clean
    FROM src
),
typed AS (
    SELECT
        *,
        CASE WHEN rule_id_clean    ~ '^[0-9]+$' THEN rule_id_clean::integer END        AS rule_id_val,
        CASE WHEN product_id_clean ~ '^[0-9]+$' THEN product_id_clean::integer END     AS product_id_val,
        CASE WHEN value_clean ~* '^(na|n/a)$' THEN NULL
             WHEN value_clean ~ '^[0-9]+(\.[0-9]+)?$' THEN value_clean::numeric END    AS value_val,
        CASE WHEN valid_from_clean ~* '^(na|n/a)$' THEN NULL
             WHEN valid_from_clean ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
                  THEN to_timestamp(replace(valid_from_clean,'-','/'),'YYYY/FMMM/FMDD') END AS valid_from_ts,
        CASE WHEN valid_to_clean ~* '^(na|n/a)$' THEN NULL
             WHEN valid_to_clean ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
                  THEN to_timestamp(replace(valid_to_clean,'-','/'),'YYYY/FMMM/FMDD') END   AS valid_to_ts
    FROM norm
),
flags AS (
    SELECT
        *,
        (rule_id_val IS NULL
         OR product_id_val IS NULL
         OR discount_type_clean IS NULL OR discount_type_clean ~* '^(na|n/a)$'
         OR value_val IS NULL
         OR valid_from_ts IS NULL
         OR valid_to_ts IS NULL) AS f_missing_or_na,
        (valid_from_ts IS NOT NULL AND valid_to_ts IS NOT NULL AND valid_from_ts >= valid_to_ts) AS f_bad_range
    FROM typed
)
SELECT
    rule_id_clean AS rule_id,
    product_id_clean AS product_id,
    discount_type_clean AS discount_type,
    value_clean AS value,
    valid_from_clean AS valid_from,
    valid_to_clean AS valid_to,
    CASE
      WHEN f_missing_or_na AND f_bad_range THEN 'missing_or_NA; valid_from >= valid_to'
      WHEN f_missing_or_na THEN 'missing_or_NA'
      WHEN f_bad_range THEN 'valid_from >= valid_to'
    END AS invalid_reason
FROM flags
WHERE f_missing_or_na OR f_bad_range