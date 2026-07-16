WITH raw_sellers AS (
    SELECT * FROM {{ source('olist_raw', 'olist_sellers_dataset') }}
)

SELECT
    seller_id,
    seller_zip_code_prefix AS zip_code,
    seller_city AS city,
    seller_state AS state
FROM raw_sellers