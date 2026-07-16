WITH raw_payments AS (
    SELECT * FROM {{ source('olist_raw', 'olist_order_payments_dataset') }}
)

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM raw_payments