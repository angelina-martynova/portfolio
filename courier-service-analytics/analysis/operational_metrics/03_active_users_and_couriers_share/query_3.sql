-- =========================================================
-- Project: Courier Service Analytics
-- Query 03: Active Users and Couriers Share
-- Goal: Calculate daily share of paying users and active couriers 
--       relative to their total counts.
-- =========================================================

WITH paying_users_daily AS (
    SELECT time::date AS date,
           COUNT(DISTINCT user_id) AS paying_users
    FROM user_actions
    WHERE order_id NOT IN (
        SELECT order_id FROM user_actions WHERE action = 'cancel_order'
    )
    GROUP BY time::date
),

active_couriers_daily AS (
    SELECT time::date AS date,
           COUNT(DISTINCT courier_id) AS active_couriers
    FROM courier_actions
    WHERE action IN ('accept_order', 'deliver_order')
      AND order_id NOT IN (
          SELECT order_id FROM user_actions WHERE action = 'cancel_order'
      )
    GROUP BY time::date
),

users_cumulative AS (
    SELECT first_date AS date,
           SUM(COUNT(*)) OVER (ORDER BY first_date) AS total_users_cumulative
    FROM (
        SELECT MIN(time::date) AS first_date
        FROM user_actions
        GROUP BY user_id
    ) t
    GROUP BY first_date
),

couriers_cumulative AS (
    SELECT first_date AS date,
           SUM(COUNT(*)) OVER (ORDER BY first_date) AS total_couriers_cumulative
    FROM (
        SELECT MIN(time::date) AS first_date
        FROM courier_actions
        GROUP BY courier_id
    ) t
    GROUP BY first_date
)

SELECT d.date,
       paying_users,
       active_couriers,
       ROUND(paying_users * 100.0 / total_users_cumulative, 2) AS paying_users_share,
       ROUND(active_couriers * 100.0 / total_couriers_cumulative, 2) AS active_couriers_share
FROM paying_users_daily d
JOIN active_couriers_daily c USING (date)
JOIN users_cumulative u USING (date)
JOIN couriers_cumulative k USING (date)
ORDER BY d.date;