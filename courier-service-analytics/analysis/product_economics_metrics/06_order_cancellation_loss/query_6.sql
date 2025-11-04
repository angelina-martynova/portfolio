-- =========================================================
-- Project: Courier Service Analytics
-- Query 06: Order Cancellation Loss
-- Goal: Analyze product-level revenue performance and calculate
--       each product's share of total revenue, grouping minor products.
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
                        
product_revenues AS (
       SELECT name AS product_name,
              SUM(price) AS revenue
       FROM successful_orders 
       LEFT JOIN products USING(product_id)
       GROUP BY name
),

total_revenue AS (
       SELECT SUM(price) AS total
       FROM successful_orders 
       LEFT JOIN products USING(product_id)
),

products_with_share AS (
       SELECT product_name,
              revenue,
              ROUND(revenue/(SELECT total FROM total_revenue)*100, 2) AS share_in_revenue
       FROM product_revenues
)

SELECT SUM(revenue) AS revenue,
       CASE
              WHEN share_in_revenue<0.5 THEN 'ДРУГОЕ'
              ELSE product_name
       END AS product_name,
       ROUND(SUM(share_in_revenue), 2) AS share_in_revenue
FROM products_with_share
GROUP BY 
       CASE
              WHEN share_in_revenue<0.5 THEN 'ДРУГОЕ'
              ELSE product_name
       END 
ORDER BY revenue DESC
