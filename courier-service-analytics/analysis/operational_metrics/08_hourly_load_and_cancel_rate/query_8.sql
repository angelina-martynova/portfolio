-- =========================================================
-- Project: Courier Service Analytics
-- Query 08: Hourly Load and Cancel Rate
-- Goal: Evaluate hourly order load and cancellation rate.
-- =========================================================

WITH hourly_orders AS (
    SELECT EXTRACT(HOUR FROM creation_time) AS hour,
           COUNT(order_id) FILTER (
               WHERE order_id IN (
                   SELECT order_id FROM user_actions WHERE action = 'cancel_order'
               )
           ) AS canceled_orders,
           COUNT(order_id) FILTER (
               WHERE order_id IN (
                   SELECT order_id FROM courier_actions WHERE action = 'deliver_order'
               )
           ) AS successful_orders,
           COUNT(order_id) AS all_orders
    FROM orders
    GROUP BY hour
)

SELECT hour::INT,
       successful_orders,
       canceled_orders,
       ROUND(canceled_orders::DECIMAL / all_orders, 3) AS cancel_rate
FROM hourly_orders
ORDER BY hour;