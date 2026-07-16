WITH products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

translations AS (
    SELECT * FROM {{ ref('stg_translations') }}
)

SELECT
    p.product_id,
    p.category_name AS category_name_portuguese,
    COALESCE(t.category_name_english, 'unknown') AS category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM products p
LEFT JOIN translations t ON p.category_name = t.category_name_portuguese