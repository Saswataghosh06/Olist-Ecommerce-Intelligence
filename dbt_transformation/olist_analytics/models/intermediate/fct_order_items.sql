WITH items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
)

SELECT
    order_item_key,
    order_id,
    item_sequence_number,
    product_id,
    seller_id,
    shipping_limit_at,
    price AS item_price,
    freight_value AS item_freight,
    total_item_value
FROM items