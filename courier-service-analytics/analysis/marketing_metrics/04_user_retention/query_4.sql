-- =========================================================
-- Project: Marketing Campaigns Analysis
-- Query 04: User Retention
-- Goal: Calculate daily retention rate for all users grouped by cohorts.
-- =========================================================

WITH first_actions AS (
    SELECT DISTINCT user_id, 
        MIN(time::DATE) OVER (PARTITION BY user_id) AS start_date,
        time::DATE AS activity_date
    FROM user_actions
),

retention_data AS (
    SELECT start_date, 
            DATE_TRUNC('month', start_date)::DATE AS start_month,
            (activity_date-start_date)::integer AS day_number,
            COUNT(DISTINCT user_id) AS active_users,
            MAX(COUNT(DISTINCT user_id)) OVER (PARTITION BY start_date) AS cohort_size
    FROM first_actions
    JOIN user_actions USING(user_id)
    GROUP BY start_date, day_number
)

SELECT start_month,
        start_date, 
        day_number,
        ROUND(active_users::decimal/cohort_size, 2) AS retention
FROM retention_data

ORDER BY start_date, day_number
