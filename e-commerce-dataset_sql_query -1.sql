#  NOW IT'S TIME FOR ANALYSIS PHASE 

use olist_db;

# 1. Delivery Delay vs Reviews
SELECT 
    r.review_score,
		ROUND(
			AVG(
				DATEDIFF(
					o.order_delivered_customer_date,
					o.order_estimated_delivery_date
            )
        ),0
    ) AS avg_delay_days

FROM orders_stage o
JOIN order_reviews_stage r
ON o.order_id = r.order_id

WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY r.review_score
ORDER BY r.review_score;

# 2. Customer Satisfaction vs Delivery Days       # delivery late Rating decrease

SELECT 
    r.review_score,
	Round(
		AVG(
			DATEDIFF(
				o.order_delivered_customer_date,
				o.order_purchase_timestamp
        )
	  ),0
    ) AS avg_delivery_days

FROM orders_stage o
JOIN order_reviews_stage r
ON o.order_id = r.order_id

GROUP BY r.review_score
ORDER BY r.review_score;

# 3. Repeat Customer Analysis            

SELECT 
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM customers_stage as c
join orders_stage as o
on c.customer_id =o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

# 4. Cancellation Analysis

SELECT 
    c.customer_state,
    COUNT(*) AS cancelled_orders
FROM orders_stage o
JOIN customers_stage c
ON o.customer_id = c.customer_id

WHERE order_status = 'canceled'

GROUP BY c.customer_state
ORDER BY cancelled_orders DESC;

# 5. Seller Delivery Efficiency                 Which sellers deliver fastest?

SELECT 
    oi.seller_id,
	round(
		AVG(
			DATEDIFF(
				o.order_delivered_customer_date,
				o.order_purchase_timestamp
        )
	  ),0
    ) AS avg_delivery_days,

    COUNT(*) AS total_orders

FROM orders_stage o
JOIN order_items_stage oi
ON o.order_id = oi.order_id

WHERE o.order_delivered_customer_date IS NOT NULL

GROUP BY oi.seller_id
HAVING COUNT(*) > 50

ORDER BY avg_delivery_days;

# 6. On-Time vs Late Deliveries

SELECT 
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
        THEN 'ON_TIME'

        ELSE 'LATE'
    END AS deliver_status,

    COUNT(*) AS total_orders

FROM orders_stage

WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL

GROUP BY deliver_status;

# 7. Monthly Revenue Trend

SELECT 
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,

    round(sum(p.payment_value),0) AS total_revenue

FROM orders_stage o
JOIN order_payments_stage p
ON o.order_id = p.order_id

GROUP BY year, month
ORDER BY year, month;

# 8. Top Categories by Revenue

SELECT 
    t.product_category_name_english,

    round(SUM(p.payment_value),2) AS revenue

FROM order_items_stage oi  

JOIN products_stage pr
ON oi.product_id = pr.product_id

JOIN product_category_translation_stage t
ON pr.product_category_name = t.product_category_name

JOIN order_payments_stage p
ON oi.order_id = p.order_id

GROUP BY t.product_category_name_english

ORDER BY revenue DESC
LIMIT 10;

# 9. Region Revenue

SELECT 
    c.customer_state,

    round(SUM(p.payment_value),2) AS revenue

FROM customers_stage c

JOIN orders_stage o
ON c.customer_id = o.customer_id

JOIN order_payments_stage p
ON o.order_id = p.order_id

GROUP BY c.customer_state

ORDER BY revenue DESC;

# 10. Seller Performance 

SELECT 
    s.seller_id,s.seller_state,

    round(SUM(p.payment_value),2) AS revenue,

    COUNT(DISTINCT oi.order_id) AS total_orders

FROM sellers_stage s

JOIN order_items_stage oi
ON s.seller_id = oi.seller_id

JOIN order_payments_stage p
ON oi.order_id = p.order_id

GROUP BY s.seller_id,s.seller_state

ORDER BY revenue DESC
LIMIT 10;

# 11. Delivery Analysis

SELECT 
    round(AVG(
        DATEDIFF(
            o.order_delivered_customer_date,
            o.order_purchase_timestamp
        )
         ),0
    ) AS avg_actual_delivery_days,

    round(AVG(
		DATEDIFF(
            o.order_estimated_delivery_date,
            o.order_purchase_timestamp
        )
         ),0
    ) AS avg_estimated_delivery_days

FROM orders_stage o

WHERE o.order_delivered_customer_date IS NOT NULL;

# 12 . Payment Distribution

SELECT 
    payment_type,

    COUNT(*) AS total_orders,

    round(AVG(payment_installments),0) AS avg_installments,

    round(SUM(payment_value),0) AS total_revenue

FROM order_payments_stage

GROUP BY payment_type;

# 13. Review Distribution

SELECT 
    review_score,

    COUNT(*) AS total_reviews

FROM order_reviews_stage

GROUP BY review_score

ORDER BY review_score;
