-- =========================================================
-- Project: Courier Service Analytics
-- Query 02: Relative Growth of Users and Couriers
-- Goal: Calculate daily percentage growth of new and total users/couriers.
-- =========================================================

WITH first_user_actions AS (
    SELECT user_id,
           MIN(time::date) AS date
    FROM user_actions
    GROUP BY user_id
),

first_courier_actions AS (
    SELECT courier_id,
           MIN(time::date) AS date
    FROM courier_actions
    GROUP BY courier_id
),

new_users_daily AS (
    SELECT date,
           COUNT(DISTINCT user_id)::INTEGER AS new_users
    FROM first_user_actions
    GROUP BY date
),

new_couriers_daily AS (
    SELECT date,
           COUNT(DISTINCT courier_id)::INTEGER AS new_couriers
    FROM first_courier_actions
    GROUP BY date
),

combined_totals AS (
    SELECT date,
           COALESCE(new_users, 0) AS new_users,
           COALESCE(new_couriers, 0) AS new_couriers,
           SUM(COALESCE(new_users, 0)) OVER (ORDER BY date)::INTEGER AS total_users,
           SUM(COALESCE(new_couriers, 0)) OVER (ORDER BY date)::INTEGER AS total_couriers
    FROM new_users_daily
    FULL JOIN new_couriers_daily USING (date)
    ORDER BY date
)

SELECT date,
       new_users,
       new_couriers,
       total_users,
       total_couriers,
       ROUND((new_users * 100.0 / NULLIF(LAG(new_users) OVER (ORDER BY date), 0)) - 100, 2) AS new_users_change,
       ROUND((new_couriers * 100.0 / NULLIF(LAG(new_couriers) OVER (ORDER BY date), 0)) - 100, 2) AS new_couriers_change,
       ROUND((total_users * 100.0 / NULLIF(LAG(total_users) OVER (ORDER BY date), 0)) - 100, 2) AS total_users_growth,
       ROUND((total_couriers * 100.0 / NULLIF(LAG(total_couriers) OVER (ORDER BY date), 0)) - 100, 2) AS total_couriers_growth
FROM combined_totals
ORDER BY date;