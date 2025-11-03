-- =========================================================
-- Project: Courier Service Analytics
-- Query 02: Average Order Value (AOV)
-- Goal: Calculate the average order value per day and analyze
--       its trend over time.
-- =========================================================

WITH successful_orders AS (
       SELECT creation_time::DATE AS date, 
              order_id,
              UNNEST(product_ids) AS product_id
       FROM orders
       WHERE order_id NOT IN (SELECT order_id 
                              FROM user_actions 
                              WHERE action='cancel_order'
                              )
),
                        
daily_revenue AS (
       SELECT date, 
              SUM(price) AS revenue
       FROM successful_orders 
       LEFT JOIN products USING(product_id)
       GROUP BY date
),

daily_all_users AS (
       SELECT time::DATE AS date, 
              COUNT(DISTINCT user_id) AS total_unique_users
       FROM user_actions
       GROUP BY time::DATE 
),

daily_paying_users AS (
       SELECT time::DATE AS date, 
              COUNT(DISTINCT user_id) AS paying_unique_users,
              COUNT(DISTINCT order_id) AS paying_unique_orders
       FROM user_actions
       WHERE action = 'create_order' AND order_id NOT IN (
              SELECT order_id 
              FROM user_actions 
              WHERE action='cancel_order'
       )
       GROUP BY time::DATE
)

SELECT date,
       ROUND(revenue/total_unique_users, 2) AS arpu,
       ROUND(revenue/paying_unique_users, 2) AS arppu,
       ROUND(revenue/paying_unique_orders, 2) AS aov
FROM daily_all_users
LEFT JOIN daily_paying_users USING(date)
LEFT JOIN daily_revenue USING(date)
ORDER BY date
