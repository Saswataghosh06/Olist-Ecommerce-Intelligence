WITH raw_order_items AS (
    SELECT * FROM {{ source('olist_raw', 'olist_order_items_dataset') }}
)

SELECT
    -- Primary Key (Surrogate Key combining Order ID and Item Sequence)
    md5(concat(order_id, '_', cast(order_item_id as string))) AS order_item_key,

    -- Foreign Keys / Granularity Identifiers
    order_id,
    order_item_id AS item_sequence_number,
    product_id,
    seller_id,

    -- Timestamps
    shipping_limit_date::TIMESTAMP AS shipping_limit_at,

    -- Financials
    price,
    freight_value,
    (price + freight_value) AS total_item_value

FROM raw_order_items