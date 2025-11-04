-- =========================================================
-- Project: Courier Service Analytics
-- Query 04: User Retention Rate
-- Goal: Analyze ARPU, ARPPU, and AOV metrics by day of week
--       for a specific two-week period.
-- =========================================================

WITH successful_orders AS (
       SELECT creation_time::DATE AS date, 
              TO_CHAR(creation_time::DATE, 'Day') AS weekday,
              CASE 
                     WHEN EXTRACT(dow FROM creation_time::DATE) = 0 THEN 7
                     ELSE EXTRACT(dow FROM creation_time::DATE)
              END AS weekday_number,
              order_id,
              UNNEST(product_ids) AS product_id
       FROM orders
       WHERE order_id NOT IN (
              SELECT order_id 
              FROM user_actions 
              WHERE action='cancel_order'
       )
       AND creation_time::DATE BETWEEN '2022-08-26' AND '2022-09-08'
),

weekly_revenue AS (
       SELECT weekday,
              weekday_number,
              SUM(price) AS revenue
       FROM successful_orders 
       LEFT JOIN products USING(product_id)
       GROUP BY weekday, weekday_number
),

weekly_all_users AS (
       SELECT TO_CHAR(time::DATE, 'Day') AS weekday,
              CASE 
                     WHEN EXTRACT(dow FROM time::DATE) = 0 THEN 7
                     ELSE EXTRACT(dow FROM time::DATE)
              END AS weekday_number,
              COUNT(DISTINCT user_id) AS total_unique_users
       FROM user_actions
       WHERE time::DATE BETWEEN '2022-08-26' AND '2022-09-08'
       GROUP BY weekday, weekday_number
),

weekly_paying_users AS (
       SELECT TO_CHAR(time::DATE, 'Day') AS weekday,
              CASE 
                     WHEN EXTRACT(dow FROM time::DATE) = 0 THEN 7
                     ELSE EXTRACT(dow FROM time::DATE)
              END AS weekday_number,
              COUNT(DISTINCT user_id) AS paying_unique_users,
              COUNT(DISTINCT order_id) AS paying_unique_orders
       FROM user_actions
       WHERE action = 'create_order' 
       AND order_id NOT IN (
              SELECT order_id 
              FROM user_actions 
              WHERE action='cancel_order'
       )
       AND time::DATE BETWEEN '2022-08-26' AND '2022-09-08'
       GROUP BY weekday, weekday_number
)

SELECT weekday,
       weekday_number,
       ROUND(revenue::decimal / total_unique_users, 2) AS arpu,
       ROUND(revenue::decimal / paying_unique_users, 2) AS arppu,
       ROUND(revenue::decimal / paying_unique_orders, 2) AS aov
FROM weekly_revenue
LEFT JOIN weekly_all_users using(weekday, weekday_number) 
LEFT JOIN weekly_paying_users using(weekday, weekday_number) 
ORDER BY weekday_number
