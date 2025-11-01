-- =========================================================
-- Project: Courier Service Analytics
-- Query 05: Order Dynamics
-- Goal: Analyze daily total orders, first orders, and new-user orders with percentage shares.
-- =========================================================

WITH orders_daily AS (
    SELECT time::date AS date,
           COUNT(DISTINCT order_id) AS orders
    FROM user_actions
    WHERE order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
    )
    GROUP BY date
),

first_orders_daily AS (
    SELECT first_order_date AS date,
           COUNT(DISTINCT user_id) AS first_orders
    FROM (
        SELECT user_id,
               MIN(time::date) AS first_order_date
        FROM user_actions
        WHERE order_id NOT IN (
            SELECT order_id FROM user_actions WHERE action = 'cancel_order'
        )
        GROUP BY user_id
    ) t
    GROUP BY first_order_date
),

new_users_orders_daily AS (
    SELECT time::date AS date,
           COUNT(DISTINCT order_id) AS new_users_orders
    FROM user_actions
    INNER JOIN (
        SELECT user_id,
               MIN(time::date) AS first_user_date
        FROM user_actions
        GROUP BY user_id
    ) first_use
        ON user_actions.user_id = first_use.user_id
       AND user_actions.time::date = first_use.first_user_date
    WHERE user_actions.order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
    )
    GROUP BY user_actions.time::date
)

SELECT o.date,
       orders,
       COALESCE(f.first_orders, 0) AS first_orders,
       COALESCE(n.new_users_orders, 0) AS new_users_orders,
       ROUND(COALESCE(f.first_orders, 0) * 100.0 / orders, 2) AS first_orders_share,
       ROUND(COALESCE(n.new_users_orders, 0) * 100.0 / orders, 2) AS new_users_orders_share
FROM orders_daily o
LEFT JOIN first_orders_daily f ON o.date = f.date
LEFT JOIN new_users_orders_daily n ON o.date = n.date
ORDER BY o.date;