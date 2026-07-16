WITH orders AS (
    -- We only want to calculate RFM for actual, successful purchases
    SELECT * FROM {{ ref('fct_orders') }}
    WHERE order_status = 'delivered'
),

payments AS (
    SELECT * FROM {{ ref('fct_payments') }}
),

-- 1. Aggregate payments to the order level
order_totals AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_purchase_at,
        SUM(p.payment_value) AS order_total_value
    FROM orders o
    LEFT JOIN payments p ON o.order_id = p.order_id
    GROUP BY 1, 2, 3
),

-- 2. Aggregate to the Customer level (Frequency and Monetary)
customer_aggregates AS (
    SELECT
        customer_id,
        MAX(order_purchase_at) AS last_purchase_date,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(order_total_value) AS monetary
    FROM order_totals
    GROUP BY 1
),

-- 3. Find the "current date" of our static dataset to calculate Recency
dataset_max_date AS (
    SELECT MAX(order_purchase_at) AS max_date FROM orders
)

-- 4. Final RFM Calculation and Basic Segmentation
SELECT
    c.customer_id,
    
    -- Spark SQL Date Math: datediff(end_date, start_date)
    datediff(d.max_date, c.last_purchase_date) AS recency_days,
    c.frequency,
    ROUND(c.monetary, 2) AS monetary_value,

    -- Basic Business Logic Segmentation
    CASE 
        WHEN datediff(d.max_date, c.last_purchase_date) <= 90 AND c.frequency > 1 THEN 'Active Loyal'
        WHEN datediff(d.max_date, c.last_purchase_date) <= 90 AND c.frequency = 1 THEN 'New Customer'
        WHEN datediff(d.max_date, c.last_purchase_date) > 90 AND c.frequency > 1 THEN 'Churning Loyal'
        ELSE 'One-Off'
    END AS customer_segment

FROM customer_aggregates c
CROSS JOIN dataset_max_date d