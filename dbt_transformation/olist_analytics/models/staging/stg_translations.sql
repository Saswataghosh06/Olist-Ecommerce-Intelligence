WITH raw_translation AS (
    SELECT * FROM {{ source('olist_raw', 'product_category_name_translation') }}
)

SELECT
    product_category_name AS category_name_portuguese,
    product_category_name_english AS category_name_english
FROM raw_translation