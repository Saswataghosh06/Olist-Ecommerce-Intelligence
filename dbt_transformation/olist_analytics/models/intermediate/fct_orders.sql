WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
reviews AS (
    SELECT order_id, AVG(review_score) AS average_review_score 
    FROM {{ ref('stg_order_reviews') }} 
    GROUP BY 1
)

SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.is_delivered,
    CAST(o.order_purchase_at AS DATE) AS order_purchase_date_key, -- Links to dim_date
    o.order_purchase_at,
    o.order_approved_at,
    o.order_shipped_to_carrier_at,
    o.order_delivered_to_customer_at,
    o.order_estimated_delivery_at,
    r.average_review_score
FROM orders o
LEFT JOIN reviews r ON o.order_id = r.order_id