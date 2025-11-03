-- =========================================================
-- PROJECT: Courier Service Analytics
-- TASK: Revenue and Cumulative Growth
-- GOAL: Calculate daily revenue, cumulative revenue, and
--       day-over-day revenue growth rate.
-- =========================================================

WITH successful_orders AS (SELECT creation_time::DATE AS date, 
order_id,
UNNEST(product_ids) AS product_id
FROM orders
WHERE order_id NOT IN (SELECT order_id 
                        FROM user_actions 
                        WHERE action='cancel_order')),
                        
daily_revenue AS (SELECT date, 
SUM(price) AS revenue
FROM successful_orders 
LEFT JOIN products USING(product_id)
GROUP BY date)

SELECT date, revenue, 
SUM(revenue) OVER (ORDER BY date) AS total_revenue,
ROUND((revenue - LAG(revenue) over(ORDER BY date))/(LAG(revenue) OVER (ORDER BY date))*100, 2) AS revenue_change
FROM daily_revenue
ORDER BY date
