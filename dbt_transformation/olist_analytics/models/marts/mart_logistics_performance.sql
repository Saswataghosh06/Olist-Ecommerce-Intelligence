WITH orders AS (
    SELECT * FROM {{ ref('fct_orders') }}
),

customers AS (
    SELECT * FROM {{ ref('dim_customers') }}
),

order_items AS (
    -- Get distinct order/seller combinations to determine the shipping lane
    SELECT DISTINCT 
        order_id,
        seller_id
    FROM {{ ref('fct_order_items') }}
),

sellers AS (
    SELECT * FROM {{ ref('dim_sellers') }}
),

payments AS (
    -- Aggregate total payment values per order from the granular payment fact table
    SELECT 
        order_id,
        SUM(payment_value) AS order_total_payment
    FROM {{ ref('fct_payments') }}
    GROUP BY 1
)

SELECT
    o.order_id,
    o.customer_id,
    c.state AS customer_state,
    s.state AS seller_state,
    o.order_status,
    o.is_delivered,
    
    -- Databricks Spark SQL logistics calculations: datediff(end, start)
    datediff(o.order_delivered_to_customer_at, o.order_purchase_at) AS actual_delivery_days,
    datediff(o.order_estimated_delivery_at, o.order_purchase_at) AS estimated_delivery_days,
    
    CASE 
        WHEN o.order_delivered_to_customer_at > o.order_estimated_delivery_at THEN TRUE 
        ELSE FALSE 
    END AS is_late_delivery,

    p.order_total_payment,
    o.average_review_score AS order_review_score

FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN sellers s ON oi.seller_id = s.seller_id
LEFT JOIN payments p ON o.order_id = p.order_id