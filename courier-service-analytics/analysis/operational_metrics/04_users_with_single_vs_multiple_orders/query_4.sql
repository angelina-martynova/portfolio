-- =========================================================
-- Project: Courier Service Analytics
-- Query 04: Users with Single vs Multiple Orders
-- Goal: Calculate daily shares of users making one order vs several orders.
-- =========================================================

WITH user_orders_daily AS (
    SELECT time::date AS date,
           user_id,
           COUNT(order_id) AS user_order_count
    FROM user_actions
    WHERE order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
    )
    GROUP BY date, user_id
    ORDER BY date
),

paying_users_daily AS (
    SELECT date,
           COUNT(DISTINCT user_id) AS paying_users
    FROM user_orders_daily
    GROUP BY date
),

single_order_users AS (
    SELECT date,
           COUNT(DISTINCT user_id) AS single_order_users
    FROM user_orders_daily
    WHERE user_order_count = 1
    GROUP BY date
),

several_order_users AS (
    SELECT date,
           COUNT(DISTINCT user_id) AS several_order_users
    FROM user_orders_daily
    WHERE user_order_count > 1
    GROUP BY date
)

SELECT p.date,
       ROUND((SELECT single_order_users FROM single_order_users WHERE single_order_users.date = p.date) * 100.0 / paying_users, 2) AS single_order_users_share,
       ROUND((SELECT several_order_users FROM several_order_users WHERE several_order_users.date = p.date) * 100.0 / paying_users, 2) AS several_orders_users_share
FROM paying_users_daily p
ORDER BY p.date;