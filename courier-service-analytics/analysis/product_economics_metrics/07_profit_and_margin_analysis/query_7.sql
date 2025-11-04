-- =========================================================
-- Project: Courier Service Analytics
-- Query 07: Profit and Margin Analysis
-- Goal: Calculate detailed profitability metrics including revenue, costs,
--       taxes, gross profit, and cumulative financial performance.
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
                        
daily_count_orders AS (
       SELECT date, 
              COUNT(DISTINCT order_id) AS count_orders
       FROM successful_orders
       GROUP BY date
),

delivered_orders_count  AS (
       SELECT time::DATE AS date, 
              COUNT(DISTINCT order_id) AS delivered_orders
       FROM courier_actions
       WHERE action = 'deliver_order'
       GROUP BY date
),

couriers_daily_deliveries AS (
       SELECT time::DATE AS date, 
              courier_id,
              COUNT(DISTINCT order_id) AS delivered_per_courier
       FROM courier_actions
       WHERE action = 'deliver_order'
       GROUP BY date, courier_id
),

courier_bonus AS (
       SELECT date,
              COUNT(courier_id) AS bonus_couriers
       FROM couriers_daily_deliveries
       WHERE delivered_per_courier>=5
       GROUP BY date
),

daily_revenue AS (
       SELECT date, 
              ROUND(SUM(price), 2) AS revenue
       FROM successful_orders 
       LEFT JOIN products USING(product_id)
       GROUP BY date
),

daily_total_revenue AS (
       SELECT date,
              ROUND(SUM(revenue) OVER (ORDER BY date), 2) AS total_revenue
       FROM daily_revenue
),

daily_costs AS (
       SELECT dco.date,
       (CASE 
              WHEN EXTRACT(month FROM dco.date)=8 THEN 120000.0+140.0*count_orders+150.0*delivered_orders+400.0*COALESCE(bonus_couriers, 0)
              WHEN EXTRACT(month FROM dco.date)=9 THEN 150000.0+115.0*count_orders+150.0*delivered_orders+500.0*COALESCE(bonus_couriers, 0)
              ELSE 0
       END) AS costs
       FROM daily_count_orders dco
       LEFT JOIN courier_bonus USING(date)
       LEFT JOIN delivered_orders_count USING(date)
),

daily_total_costs AS (
       SELECT date,
              SUM(costs) OVER (ORDER BY date) AS total_costs
       FROM daily_costs
),

product_tax AS (
       SELECT product_id,
              CASE 
                     WHEN name IN (
                            'сахар', 'сухарики', 'сушки', 'семечки', 
                            'масло льняное', 'виноград', 'масло оливковое', 
                            'арбуз', 'батон', 'йогурт', 'сливки', 'гречка', 
                            'овсянка', 'макароны', 'баранина', 'апельсины', 
                            'бублики', 'хлеб', 'горох', 'сметана', 'рыба копченая', 
                            'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 
                            'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 
                            'соль', 'рыба вяленая', 'масло подсолнечное', 'яблоки', 
                            'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') 
                     THEN ROUND(price*10/110, 2)
                     ELSE ROUND(price*20/120, 2)
              END AS taxes
       FROM products
),

daily_tax AS (
       SELECT date, 
              ROUND(SUM(taxes), 2) AS tax
       FROM product_tax 
       LEFT JOIN successful_orders USING(product_id)
       GROUP BY date
),

daily_total_tax AS (
       SELECT date,
              ROUND(SUM(tax) OVER (ORDER BY date), 2) AS total_tax
       FROM daily_tax
),

daily_gross_profit AS (
       SELECT date,
              ROUND(revenue-costs-tax, 2) AS gross_profit
       FROM daily_revenue
       LEFT JOIN daily_costs USING(date)
       LEFT JOIN daily_tax USING(date)
),

daily_total_gross_profit AS (
       SELECT date,
              ROUND(SUM(gross_profit) OVER (ORDER BY date), 2) AS total_gross_profit
       FROM daily_gross_profit
),

daily_gross_profit_ratio AS (
       SELECT date,
              ROUND(gross_profit/revenue*100, 2) AS gross_profit_ratio
       FROM daily_revenue
       LEFT JOIN daily_gross_profit USING(date)
),

daily_total_gross_profit_ratio AS (
       SELECT date,
              ROUND(total_gross_profit/total_revenue*100, 2) AS total_gross_profit_ratio
       FROM daily_total_revenue
       LEFT JOIN daily_total_gross_profit USING(date)
)

SELECT date, 
       revenue, 
       costs, 
       tax, 
       gross_profit, 
       total_revenue, 
       total_costs, 
       total_tax, 
       total_gross_profit,
       gross_profit_ratio, 
       total_gross_profit_ratio
FROM daily_revenue
LEFT JOIN daily_costs USING(date)
LEFT JOIN daily_tax USING(date)
LEFT JOIN daily_gross_profit USING(date)
LEFT JOIN daily_total_revenue USING(date)
LEFT JOIN daily_total_costs USING(date)
LEFT JOIN daily_total_tax USING(date)
LEFT JOIN daily_total_gross_profit USING(date)
LEFT JOIN daily_gross_profit_ratio USING(date)
LEFT JOIN daily_total_gross_profit_ratio USING(date)
ORDER BY date

