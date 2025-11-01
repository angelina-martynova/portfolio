-- =========================================================
-- Project: Courier Service Analytics
-- Query 06: Courier Workload
-- Goal: Estimate daily number of users and orders per active courier.
-- =========================================================

WITH users_daily AS (
    SELECT time::date AS date,
           COUNT(DISTINCT user_id) AS users_count
    FROM user_actions
    WHERE order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
    )
    GROUP BY date
),

couriers_daily AS (
    SELECT time::date AS date,
           COUNT(DISTINCT courier_id) AS courier_count
    FROM courier_actions
    WHERE order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
    )
      AND action IN ('accept_order', 'deliver_order')
    GROUP BY date
),

orders_daily AS (
    SELECT creation_time::date AS date,
           COUNT(DISTINCT order_id) AS orders_count
    FROM orders
    WHERE order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
    )
    GROUP BY date
)

SELECT date,
       ROUND(users_count::DECIMAL / courier_count, 2) AS users_per_courier,
       ROUND(orders_count::DECIMAL / courier_count, 2) AS orders_per_courier
FROM users_daily
LEFT JOIN couriers_daily USING (date)
LEFT JOIN orders_daily USING (date)
ORDER BY date;