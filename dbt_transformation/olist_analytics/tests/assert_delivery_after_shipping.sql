-- This test checks for logical anomalies in the logistics timeline.
-- It returns rows where the delivery date is mathematically before the shipping date.
-- If it returns 0 rows, the test passes.

SELECT 
    order_id,
    order_shipped_to_carrier_at,
    order_delivered_to_customer_at
FROM {{ ref('fct_orders') }}
WHERE order_delivered_to_customer_at < order_shipped_to_carrier_at
  AND order_status = 'delivered'