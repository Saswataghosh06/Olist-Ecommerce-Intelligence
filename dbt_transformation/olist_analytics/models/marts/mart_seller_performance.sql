WITH order_items AS (
    SELECT * FROM {{ ref('fct_order_items') }}
),

orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
),

sellers AS (
    SELECT * FROM {{ ref('dim_sellers') }}
)

SELECT
    sel.seller_id,
    sel.city AS seller_city,
    sel.state AS seller_state,

    -- Volume Metrics
    COUNT(DISTINCT oi.order_id) AS total_orders_fulfilled,
    COUNT(oi.order_item_key) AS total_items_sold,

    -- Financial Metrics
    SUM(oi.item_price) AS total_product_revenue,
    SUM(oi.item_freight) AS total_freight_generated,
    SUM(oi.total_item_value) AS total_revenue_generated,

    -- Quality Metrics
    ROUND(AVG(o.average_review_score), 2) AS average_customer_review_score

FROM order_items oi
JOIN sellers sel ON oi.seller_id = sel.seller_id
LEFT JOIN orders o ON oi.order_id = o.order_id
GROUP BY 1, 2, 3