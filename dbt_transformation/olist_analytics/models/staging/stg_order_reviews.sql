WITH raw_reviews AS (
    SELECT * FROM {{ source('olist_raw', 'olist_order_reviews_dataset') }}
)

SELECT
    review_id,
    order_id,
    -- DATA QUALITY FIX: Try to cast as integer. Corrupted strings (like timestamps) turn to NULL.
    TRY_CAST(review_score AS INT) AS review_score,
    review_comment_title,
    review_comment_message,
    CAST(review_creation_date AS TIMESTAMP) AS review_created_at,
    CAST(review_answer_timestamp AS TIMESTAMP) AS review_answered_at
FROM raw_reviews
WHERE review_id IS NOT NULL -- DATA QUALITY FIX: Drop corrupted rows missing a primary key