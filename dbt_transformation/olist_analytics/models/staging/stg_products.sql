WITH raw_products AS (
    SELECT * FROM {{ source('olist_raw', 'olist_products_dataset') }}
)

SELECT
    product_id,
    COALESCE(product_category_name, 'unknown') AS category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM raw_products
