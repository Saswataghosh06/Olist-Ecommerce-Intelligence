WITH raw_orders AS (
    SELECT * FROM {{ source('olist_raw', 'olist_orders_dataset') }}
)

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::TIMESTAMP AS order_purchase_at,
    order_approved_at::TIMESTAMP AS order_approved_at,
    order_delivered_carrier_date::TIMESTAMP AS order_shipped_to_carrier_at,
    
    -- DATA QUALITY FIX: Nullify impossible delivery dates caught by our custom test
    CASE 
        WHEN order_delivered_customer_date::TIMESTAMP < order_delivered_carrier_date::TIMESTAMP THEN NULL
        ELSE order_delivered_customer_date::TIMESTAMP 
    END AS order_delivered_to_customer_at,
    
    order_estimated_delivery_date::TIMESTAMP AS order_estimated_delivery_at,

    CASE 
        WHEN order_status = 'delivered' THEN TRUE 
        ELSE FALSE 
    END AS is_delivered

FROM raw_orders