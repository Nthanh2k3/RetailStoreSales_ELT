
  create view "postgres"."silver_invalid"."customer_feedback_invalid__dbt_tmp"
    
    
  as (
    

WITH src AS (
    SELECT
        TRIM(CAST(feedback_id AS text))  AS feedback_id,
        TRIM(CAST(customer_id AS text))  AS customer_id,
        TRIM(CAST(store_id    AS text))  AS store_id,
        TRIM(CAST(product_id  AS text))  AS product_id,
        /* giữ nguyên rating dạng text để kiểm tra 'bad' */
        CASE
            WHEN rating IS NULL THEN NULL
            ELSE TRIM(CAST(rating AS text))
        END AS rating_text,
        TRIM(CAST(comments AS text)) AS comments,
        /* chuẩn hoá ngày thô */
        CASE
            WHEN feedback_date IS NULL THEN NULL
            ELSE TRIM(REPLACE(CAST(feedback_date AS text), E'\r',''))
        END AS feedback_date_text
    FROM "postgres"."raw"."customer_feedback"
),
dated AS (
    SELECT
        *,
        /* nhận YYYY[-/]M[M]?[-/]D[D]?; parse linh hoạt */
        CASE
            WHEN feedback_date_text ~ '^[0-9]{4}[-/](0?[1-9]|1[0-2])[-/](0?[1-9]|[12][0-9]|3[01])$'
            THEN to_timestamp(replace(feedback_date_text, '-', '/'), 'YYYY/FMMM/FMDD')
            ELSE NULL
        END AS feedback_date_ts
    FROM src
),
flagged AS (
    SELECT
        *,
        /* 2 điều kiện invalid duy nhất */
        (rating_text IS NOT NULL AND lower(rating_text) = 'bad') AS f_rating_bad,
        (feedback_date_ts IS NOT NULL
          AND feedback_date_ts > to_timestamp('2025/08/22','YYYY/MM/DD')) AS f_date_after_cutoff
    FROM dated
)
SELECT
    feedback_id,
    customer_id,
    store_id,
    product_id,
    rating_text    AS rating,
    comments,
    feedback_date_text,
    feedback_date_ts AS feedback_date_parsed,
    CASE
        WHEN f_rating_bad AND f_date_after_cutoff THEN 'rating=bad; date>2025/08/22'
        WHEN f_rating_bad THEN 'rating=bad'
        WHEN f_date_after_cutoff THEN 'date>2025/08/22'
    END AS invalid_reason
FROM flagged
WHERE
    /* chỉ lấy đúng 2 loại lỗi này */
    f_rating_bad OR f_date_after_cutoff
  );