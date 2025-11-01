-- =========================================================
-- Project: Courier Service Analytics
-- Query 07: Average Delivery Time
-- Goal: Calculate average delivery duration (in minutes) for completed orders.
-- =========================================================

WITH delivery_time AS (
    SELECT order_id,
           EXTRACT(EPOCH FROM AGE(MAX(time), MIN(time))) / 60 AS minutes_to_deliver
    FROM courier_actions
    WHERE order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
    )
    GROUP BY order_id
)

SELECT time::date AS date,
       ROUND(AVG(minutes_to_deliver))::INTEGER AS minutes_to_deliver
FROM delivery_time
LEFT JOIN courier_actions USING (order_id)
GROUP BY date
ORDER BY date;