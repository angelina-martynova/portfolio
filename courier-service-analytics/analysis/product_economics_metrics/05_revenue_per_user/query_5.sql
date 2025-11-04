-- =========================================================
-- Project: Courier Service Analytics
-- Query 05: Revenue per User
-- Goal: Calculate total revenue and segment it by new vs. existing users,
--       showing revenue share for each segment.
-- =========================================================

WITH successful_orders AS (
       SELECT creation_time::DATE AS date, 
              order_id,
              UNNEST(product_ids) AS product_id
       FROM orders
       WHERE order_id NOT IN (
              SELECT order_id 
              FROM user_actions 
              WHERE action='cancel_order'
       )
),

first_user_actions AS (
       SELECT user_id,
              MIN(time::date) AS date
       FROM user_actions
       GROUP BY user_id
),

daily_revenue AS (
       SELECT date, 
              SUM(price) AS revenue
       FROM successful_orders 
       LEFT JOIN products USING(product_id)
       GROUP BY date
),

daily_new_users_revenue AS (
       SELECT so.date, 
              SUM(price) AS new_users_revenue
       FROM successful_orders so
       LEFT JOIN products USING(product_id)
       LEFT JOIN user_actions ua USING(order_id)
       LEFT JOIN first_user_actions fua USING(user_id)
       WHERE so.date = fua.date AND ua.action != 'cancel_order'
       GROUP BY so.date
)

SELECT date, 
       revenue, 
       new_users_revenue,
       ROUND(new_users_revenue/revenue*100, 2) AS new_users_revenue_share,
       ROUND(((revenue - new_users_revenue)/revenue)*100, 2) AS old_users_revenue_share
FROM daily_revenue
LEFT JOIN daily_new_users_revenue USING(date)
ORDER BY date
