WITH payments AS (
    SELECT * FROM {{ ref('stg_order_payments') }}
)

SELECT
    order_id, -- Note: order_id is NOT unique here, as one order can have multiple payments
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM payments