-- =========================================================
-- Project: Courier Service Analytics
-- Query 01: Users and Couriers Growth
-- Goal: Calculate daily number of new users and couriers, 
--       along with their cumulative totals.
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
)

SELECT date,
       COALESCE(new_users, 0) AS new_users,
       COALESCE(new_couriers, 0) AS new_couriers,
       SUM(COALESCE(new_users, 0)) OVER (ORDER BY date)::INTEGER AS total_users,
       SUM(COALESCE(new_couriers, 0)) OVER (ORDER BY date)::INTEGER AS total_couriers
FROM new_users_daily
FULL JOIN new_couriers_daily USING (date)
ORDER BY date;
