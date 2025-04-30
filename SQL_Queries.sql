CREATE DATABASE ALT_MOBILITY;

#Total Orders by Order Status:
SELECT order_status, COUNT(*) AS total_orders
FROM customer_orders
GROUP BY order_status;


#Total Sales (Revenue) Month-wise:
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    SUM(order_amount) AS total_sales
FROM customer_orders
WHERE order_status = 'delivered'  -- Only completed orders are considered sales
GROUP BY order_month
ORDER BY order_month;


#Average Order Value (for completed orders):
SELECT 
    AVG(order_amount) AS avg_order_value
FROM customer_orders
WHERE order_status = 'delivered';


#Status-wise Revenue:
SELECT 
    order_status,
    SUM(order_amount) AS total_revenue
FROM customer_orders
GROUP BY order_status;


#Customers with Repeat Orders:
SELECT customer_id, COUNT(*) AS total_orders
FROM customer_orders
GROUP BY customer_id
HAVING total_orders > 1
ORDER BY total_orders DESC;


#Customer Segmentation Based on Total Spend:
SELECT 
    customer_id,
    SUM(order_amount) AS total_spent,
    CASE
        WHEN SUM(order_amount) >= 1000 THEN 'High Value'
        WHEN SUM(order_amount) BETWEEN 500 AND 999 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_orders
GROUP BY customer_id;


#Payment Status Counts:
SELECT payment_status, COUNT(*) AS total_payments
FROM payments
GROUP BY payment_status;


# Failed Payment Details:
SELECT 
    p.order_id,
    c.customer_id,
    c.order_date,
    c.order_amount,
    p.payment_amount,
    p.payment_method,
    p.payment_status
FROM payments p
JOIN customer_orders c ON p.order_id = c.order_id
WHERE p.payment_status = 'Failed';



# Full report combining orders and payments.
SELECT 
    c.order_id,
    c.customer_id,
    c.order_date,
    c.order_amount,
    c.shipping_address,
    c.order_status,
    p.payment_id,
    p.payment_date,
    p.payment_amount,
    p.payment_method,
    p.payment_status
FROM customer_orders c
LEFT JOIN payments p ON c.order_id = p.order_id
ORDER BY c.order_date;


#Identify top 10 customers contributing the most to revenue.
SELECT 
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_spent
FROM customer_orders
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;


# Monthly Order Volume & Revenue Trend
# Helps identify seasonal patterns or growth trends.
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(*) AS order_count,
    SUM(order_amount) AS total_revenue
FROM customer_orders
WHERE order_status = 'delivered'
GROUP BY month
ORDER BY total_revenue DESC;


#Orders with No Payment Recorded
SELECT *
FROM customer_orders c
LEFT JOIN payments p ON c.order_id = p.order_id
WHERE p.payment_id IS NULL;

