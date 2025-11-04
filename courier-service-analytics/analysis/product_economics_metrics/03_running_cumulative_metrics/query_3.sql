-- =========================================================
-- Project: Courier Service Analytics
-- Query 03: Repeat Purchase Rate
-- Goal: Calculate the daily share of users who made repeat orders
--       (two or more successful orders).
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
                        
daily_revenue AS (
       SELECT date, 
              SUM(price) AS revenue,
              COUNT(DISTINCT order_id) AS count_orders
       FROM successful_orders 
       LEFT JOIN products USING(product_id)
       GROUP BY date
),

daily_users AS (
       SELECT time::DATE AS date,
              COUNT(DISTINCT user_id) AS users
       FROM user_actions
       GROUP BY time::DATE
),

daily_paying_users AS (
       SELECT time::DATE AS date,
              COUNT(DISTINCT user_id) AS paying_users
       FROM user_actions
       WHERE order_id NOT IN (
              SELECT order_id
              FROM user_actions
              WHERE action = 'cancel_order'
       )
       GROUP BY time::DATE
),

new_users_daily AS (
       SELECT date,
              COUNT(user_id) AS new_users
       FROM (
              SELECT user_id,
                     MIN(time::DATE) AS date
              FROM user_actions
              GROUP BY user_id
       ) AS new_user
       GROUP BY date
),

new_paying_users_daily AS (
       SELECT date,
              COUNT(user_id) AS new_paying_users
       FROM (
              SELECT user_id,
                     MIN(time::DATE) AS date
              FROM user_actions
              WHERE action = 'create_order' 
              AND order_id NOT IN (
                     SELECT order_id
                     FROM user_actions
                     WHERE action = 'cancel_order'
              )
              GROUP BY user_id
       ) AS user_created
       GROUP BY date
)

SELECT date,
       ROUND(SUM(revenue) OVER (ORDER BY date)::decimal / 
       SUM(new_users) OVER (ORDER BY date), 2) AS running_arpu,
       ROUND(SUM(revenue) OVER (ORDER BY date)::decimal / 
       SUM(new_paying_users) OVER (ORDER BY date), 2) AS running_arppu,
       ROUND(SUM(revenue) OVER (ORDER BY date)::decimal / 
       SUM(count_orders) OVER (ORDER BY date), 2) AS running_aov
FROM daily_revenue
LEFT JOIN new_users_daily USING (date)
LEFT JOIN new_paying_users_daily USING (date)
