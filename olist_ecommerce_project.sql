USE olist_ecommerce;
SELECT COUNT(*) AS imported_rows
FROM orders_raw;
SELECT COUNT(*) AS total_rows
FROM orders_raw;
-- Olist E-Commerce SQL Analytics Project
-- Database setup and data preparation
USE olist_ecommerce;
-- Verify imported customer data
SELECT COUNT(*) AS total_customers
FROM customers;
-- Verify orders staging table
SELECT COUNT(*) AS total_orders_raw
FROM orders_raw;
-- Verify complete orders raw data import
SELECT COUNT(*) AS total_orders_raw
FROM orders_raw;
-- Check order status distribution
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM orders_raw
GROUP BY order_status
ORDER BY total_orders DESC;
SELECT
    SUM(order_purchase_timestamp IS NULL OR TRIM(order_purchase_timestamp) = '') 
        AS missing_purchase_date,
    SUM(order_approved_at IS NULL OR TRIM(order_approved_at) = '') 
        AS missing_approved_date,
    SUM(order_delivered_carrier_date IS NULL OR TRIM(order_delivered_carrier_date) = '') 
        AS missing_carrier_date,
    SUM(order_delivered_customer_date IS NULL OR TRIM(order_delivered_customer_date) = '') 
        AS missing_customer_delivery_date,
    SUM(order_estimated_delivery_date IS NULL OR TRIM(order_estimated_delivery_date) = '') 
        AS missing_estimated_date
FROM orders_raw;
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME NULL,
    order_delivered_carrier_date DATETIME NULL,
    order_delivered_customer_date DATETIME NULL,
    order_estimated_delivery_date DATETIME
);
DESCRIBE orders;
-- Transform raw orders data into clean orders table
INSERT INTO orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    NULLIF(TRIM(order_approved_at), ''),
    NULLIF(TRIM(order_delivered_carrier_date), ''),
    NULLIF(TRIM(order_delivered_customer_date), ''),
    order_estimated_delivery_date
FROM orders_raw;
SELECT COUNT(*) AS raw_orders FROM orders_raw;
SELECT COUNT(*) AS clean_orders FROM orders;
SELECT COUNT(*) AS customers_count FROM customers;
SELECT COUNT(*) AS orders_count FROM orders;
SELECT COUNT(*) AS orders_count FROM orders;
SELECT order_status,
    COUNT(*) AS total_orders
FROM orders_raw
GROUP BY order_status
ORDER BY total_orders DESC;
-- Transform raw orders data into clean orders table
INSERT INTO orders (
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT
    TRIM(order_id),
    TRIM(customer_id),
    TRIM(order_status),
    STR_TO_DATE(NULLIF(TRIM(order_purchase_timestamp), ''), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(NULLIF(TRIM(order_approved_at), ''), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(NULLIF(TRIM(order_delivered_carrier_date), ''), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(NULLIF(TRIM(order_delivered_customer_date), ''), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(NULLIF(TRIM(order_estimated_delivery_date), ''), '%Y-%m-%d %H:%i:%s')
FROM orders_raw;
SELECT COUNT(*) AS total_clean_orders FROM orders;
SELECT
    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_date,
    SUM(order_approved_at IS NULL) AS missing_approved_date,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_customer_delivery_date,
    SUM(order_estimated_delivery_date IS NULL) AS missing_estimated_date
FROM orders;
SELECT
    MIN(CAST(price AS DECIMAL(10,2))) AS minimum_price,
    MAX(CAST(price AS DECIMAL(10,2))) AS maximum_price,
    MIN(CAST(freight_value AS DECIMAL(10,2))) AS minimum_freight,
    MAX(CAST(freight_value AS DECIMAL(10,2))) AS maximum_freight
FROM order_items_raw;
SELECT
    MIN(CAST(order_item_id AS UNSIGNED)) AS minimum_item_id,
    MAX(CAST(order_item_id AS UNSIGNED)) AS maximum_item_id,
    MIN(STR_TO_DATE(shipping_limit_date, '%Y-%m-%d %H:%i:%s')) AS earliest_shipping_limit,
    MAX(STR_TO_DATE(shipping_limit_date, '%Y-%m-%d %H:%i:%s')) AS latest_shipping_limit
FROM order_items_raw;
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);
DESCRIBE order_items;
INSERT INTO order_items (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    TRIM(order_id),
    CAST(TRIM(order_item_id) AS UNSIGNED),
    TRIM(product_id),
    TRIM(seller_id),
    STR_TO_DATE(TRIM(shipping_limit_date), '%Y-%m-%d %H:%i:%s'),
    CAST(TRIM(price) AS DECIMAL(10,2)),
    CAST(TRIM(freight_value) AS DECIMAL(10,2))
FROM order_items_raw;
SELECT COUNT(*) AS total_clean_order_items FROM order_items;
CREATE TABLE order_payments_raw (
    order_id VARCHAR(50),
    payment_sequential VARCHAR(10),
    payment_type VARCHAR(30),
    payment_installments VARCHAR(10),
    payment_value VARCHAR(30)
);
DESCRIBE order_payments_raw;
SELECT COUNT(*) AS total_payments_raw FROM order_payments_raw;
SELECT
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_id,
    SUM(payment_sequential IS NULL OR TRIM(payment_sequential) = '') AS missing_payment_sequential,
    SUM(payment_type IS NULL OR TRIM(payment_type) = '') AS missing_payment_type,
    SUM(payment_installments IS NULL OR TRIM(payment_installments) = '') AS missing_installments,
    SUM(payment_value IS NULL OR TRIM(payment_value) = '') AS missing_payment_value
FROM order_payments_raw;
SELECT payment_type,
    COUNT(*) AS payment_count
FROM order_payments_raw
GROUP BY payment_type
ORDER BY payment_count DESC;
SELECT
    MIN(CAST(payment_sequential AS UNSIGNED)) AS minimum_payment_sequence,
    MAX(CAST(payment_sequential AS UNSIGNED)) AS maximum_payment_sequence,
    MIN(CAST(payment_installments AS UNSIGNED)) AS minimum_installments,
    MAX(CAST(payment_installments AS UNSIGNED)) AS maximum_installments,
    MIN(CAST(payment_value AS DECIMAL(10,2))) AS minimum_payment_value,
    MAX(CAST(payment_value AS DECIMAL(10,2))) AS maximum_payment_value
FROM order_payments_raw;
SELECT
    SUM(CAST(payment_installments AS UNSIGNED) = 0) AS zero_installment_records,
    SUM(CAST(payment_value AS DECIMAL(10,2)) = 0) AS zero_payment_records
FROM order_payments_raw;
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS occurrence_count
FROM order_payments_raw
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);
DESCRIBE order_payments;
INSERT INTO order_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT TRIM(order_id),
    CAST(TRIM(payment_sequential) AS UNSIGNED),
    TRIM(payment_type),
    CAST(TRIM(payment_installments) AS UNSIGNED),
    CAST(TRIM(payment_value) AS DECIMAL(10,2))
FROM order_payments_raw;
SELECT COUNT(*) AS total_clean_payments FROM order_payments;
CREATE TABLE order_reviews_raw (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score VARCHAR(10),
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date VARCHAR(50),
    review_answer_timestamp VARCHAR(50)
);
DESCRIBE order_reviews_raw;
SELECT
    COUNT(*) AS imported_rows,
    MIN(review_score) AS minimum_score,
    MAX(review_score) AS maximum_score
FROM order_reviews_raw;
SELECT review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp
FROM order_reviews_raw
LIMIT 270, 9;
SELECT COUNT(*) AS total_reviews_raw FROM order_reviews_raw;
DROP TABLE order_reviews_raw;
CREATE TABLE order_reviews_raw (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score VARCHAR(10),
    review_creation_date VARCHAR(50),
    review_answer_timestamp VARCHAR(50)
);
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
INSERT INTO order_reviews (
    review_id,
    order_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    TRIM(review_id),
    TRIM(order_id),
    CAST(TRIM(review_score) AS UNSIGNED),
    STR_TO_DATE(
        NULLIF(TRIM(review_creation_date), ''),
        '%Y-%m-%d %H:%i:%s'
    ),
    STR_TO_DATE(
        NULLIF(TRIM(review_answer_timestamp), ''),
        '%Y-%m-%d %H:%i:%s'
    )
FROM order_reviews_raw;
SELECT COUNT(*) AS total_reviews FROM order_reviews;
CREATE TABLE products_raw (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght VARCHAR(20),
    product_description_lenght VARCHAR(20),
    product_photos_qty VARCHAR(20),
    product_weight_g VARCHAR(20),
    product_length_cm VARCHAR(20),
    product_height_cm VARCHAR(20),
    product_width_cm VARCHAR(20)
);
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2)
);
INSERT INTO products (
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    TRIM(product_id),
    NULLIF(TRIM(product_category_name), ''),
    CAST(NULLIF(TRIM(product_name_lenght), '') AS UNSIGNED),
    CAST(NULLIF(TRIM(product_description_lenght), '') AS UNSIGNED),
    CAST(NULLIF(TRIM(product_photos_qty), '') AS UNSIGNED),
    CAST(NULLIF(TRIM(product_weight_g), '') AS DECIMAL(10,2)),
    CAST(NULLIF(TRIM(product_length_cm), '') AS DECIMAL(10,2)),
    CAST(NULLIF(TRIM(product_height_cm), '') AS DECIMAL(10,2)),
    CAST(NULLIF(TRIM(product_width_cm), '') AS DECIMAL(10,2))
FROM products_raw;
SELECT COUNT(*) AS total_products FROM products;
CREATE TABLE sellers_raw (
    seller_id VARCHAR(50),
    seller_zip_code_prefix VARCHAR(20),
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);
INSERT INTO sellers (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    TRIM(seller_id),
    CAST(NULLIF(TRIM(seller_zip_code_prefix), '') AS UNSIGNED),
    TRIM(seller_city),
    TRIM(seller_state)
FROM sellers_raw;
SELECT COUNT(*) AS total_sellers FROM sellers;
CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);
SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers UNION ALL
SELECT 'orders', COUNT(*) FROM orders UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items UNION ALL
SELECT 'order_payments', COUNT(*) FROM order_payments UNION ALL
SELECT 'order_reviews', COUNT(*) FROM order_reviews UNION ALL
SELECT 'products', COUNT(*) FROM products UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers UNION ALL
SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;

-- Task Solutions
-- Task 1 – Revenue & Category Intelligence

-- Task 1.1
SELECT pct.product_category_name_english AS category,
ROUND(SUM(oi.price), 2) AS total_revenue,
COUNT(DISTINCT o.order_id) AS total_orders
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation AS pct ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY pct.product_category_name_english
ORDER BY total_revenue DESC;

-- Task 1.2
WITH category_revenue AS (
SELECT pct.product_category_name_english AS category, SUM(oi.price) AS total_revenue
    FROM orders AS o
    JOIN order_items AS oi ON o.order_id = oi.order_id
    JOIN products AS p ON oi.product_id = p.product_id
    LEFT JOIN product_category_translation AS pct ON p.product_category_name = pct.product_category_name
    WHERE o.order_status = 'delivered' AND pct.product_category_name_english IS NOT NULL
    GROUP BY pct.product_category_name_english
)
SELECT category, ROUND(total_revenue, 2) AS total_revenue
FROM category_revenue
ORDER BY total_revenue DESC
LIMIT 5;
WITH category_revenue AS (
SELECT pct.product_category_name_english AS category, SUM(oi.price) AS total_revenue
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation AS pct ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
AND pct.product_category_name_english IS NOT NULL
GROUP BY pct.product_category_name_english
),
top_5_categories AS (
SELECT category FROM category_revenue
ORDER BY total_revenue DESC
LIMIT 5
)
SELECT * FROM top_5_categories;
WITH category_revenue AS (
    SELECT
        pct.product_category_name_english AS category,
        SUM(oi.price) AS total_revenue
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    JOIN products AS p
        ON oi.product_id = p.product_id
    LEFT JOIN product_category_translation AS pct
        ON p.product_category_name = pct.product_category_name
    WHERE o.order_status = 'delivered'
      AND pct.product_category_name_english IS NOT NULL
    GROUP BY pct.product_category_name_english
),

top_5_categories AS (
    SELECT category
    FROM category_revenue
    ORDER BY total_revenue DESC
    LIMIT 5
),
WITH category_revenue AS (
SELECT pct.product_category_name_english AS category,
SUM(oi.price) AS total_revenue FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation AS pct ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
AND pct.product_category_name_english IS NOT NULL
GROUP BY pct.product_category_name_english
),
top_5_categories AS (
SELECT category FROM category_revenue
ORDER BY total_revenue DESC
LIMIT 5
),
monthly_revenue AS (
SELECT pct.product_category_name_english AS category,
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
SUM(oi.price) AS monthly_revenue FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation AS pct ON p.product_category_name = pct.product_category_name
JOIN top_5_categories AS t ON pct.product_category_name_english = t.category
WHERE o.order_status = 'delivered'
GROUP BY pct.product_category_name_english,
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT category, order_month,
ROUND(monthly_revenue, 2) AS monthly_revenue
FROM monthly_revenue
ORDER BY category, order_month;
WITH category_revenue AS (
SELECT pct.product_category_name_english AS category, SUM(oi.price) AS total_revenue
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation AS pct ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered' AND pct.product_category_name_english IS NOT NULL
GROUP BY pct.product_category_name_english
),
top_5_categories AS (
SELECT category
FROM category_revenue
ORDER BY total_revenue DESC
LIMIT 5
),
monthly_revenue AS (
SELECT pct.product_category_name_english AS category,
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
SUM(oi.price) AS monthly_revenue
FROM orders AS o
JOIN order_items AS oi ON o.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
LEFT JOIN product_category_translation AS pct ON p.product_category_name = pct.product_category_name
JOIN top_5_categories AS t ON pct.product_category_name_english = t.category
WHERE o.order_status = 'delivered'
AND o.order_purchase_timestamp >= '2017-09-01'
AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY pct.product_category_name_english,
	DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
),
revenue_with_previous AS (
SELECT category, order_month, monthly_revenue,
LAG(monthly_revenue) OVER (PARTITION BY category
ORDER BY order_month) AS previous_month_revenue
FROM monthly_revenue
)
SELECT category, order_month, 
ROUND(monthly_revenue, 2) AS monthly_revenue,
ROUND(previous_month_revenue, 2) AS previous_month_revenue,
ROUND(((monthly_revenue - previous_month_revenue) / NULLIF(previous_month_revenue, 0)) * 100, 2
) AS mom_growth_pct
FROM revenue_with_previous
ORDER BY category, order_month;

-- Task 1.3
WITH delivered_items AS (
SELECT
COALESCE(t.product_category_name_english, 'unknown') AS category,
oi.product_id, oi.price
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
AND o.order_status = 'delivered'
LEFT JOIN products p ON p.product_id = oi.product_id
LEFT JOIN product_category_translation t ON t.product_category_name = p.product_category_name
),
top5 AS (
    SELECT category
    FROM delivered_items
    GROUP BY category
    ORDER BY SUM(price) DESC
    LIMIT 5
),
product_rev AS (
    SELECT d.category, d.product_id,
	ROUND(SUM(d.price), 2) AS product_revenue,
	RANK() OVER (
	PARTITION BY d.category
	ORDER BY SUM(d.price) DESC
        ) AS rnk
    FROM delivered_items d
    JOIN top5 t ON t.category = d.category
    GROUP BY d.category, d.product_id
)
SELECT category, product_id, product_revenue, rnk FROM product_rev
WHERE rnk <= 3
ORDER BY category, rnk;

-- Task 1.4
WITH delivered_items AS (
    SELECT
	COALESCE(t.product_category_name_english, 'unknown') AS category,
	oi.product_id, oi.order_id, oi.price
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
	AND o.order_status = 'delivered'
    LEFT JOIN products p ON p.product_id = oi.product_id
    LEFT JOIN product_category_translation t ON t.product_category_name = p.product_category_name
),
top5 AS (
    SELECT category
    FROM delivered_items
    GROUP BY category
    ORDER BY SUM(price) DESC
    LIMIT 5
),
product_rev AS (
SELECT d.category, d.product_id,
	RANK() OVER (PARTITION BY d.category ORDER BY SUM(d.price) DESC) AS rnk
    FROM delivered_items d
    JOIN top5 t ON t.category = d.category
    GROUP BY d.category, d.product_id
),
top_products AS (
    SELECT category, product_id
    FROM product_rev
    WHERE rnk <= 3
)
SELECT tp.category, tp.product_id,
    ROUND(AVG(r.review_score), 2) AS avg_review_score,
    ROUND(100.0 * SUM(CASE WHEN r.review_score <= 3 THEN 1 ELSE 0 END)
	/ COUNT(r.review_score), 2) AS pct_reviews_3_or_less
FROM top_products tp
JOIN delivered_items d ON d.category = tp.category
AND d.product_id = tp.product_id
JOIN order_reviews r ON r.order_id = d.order_id
GROUP BY tp.category, tp.product_id
ORDER BY tp.category, tp.product_id;

-- Task 2 – RFM Customer Segmentation
WITH customer_rfm AS (
SELECT c.customer_unique_id,
MAX(c.customer_city) AS customer_city,
MAX(c.customer_state) AS customer_state,
DATEDIFF('2018-10-17',
MAX(o.order_purchase_timestamp)
) AS recency,
COUNT(DISTINCT o.order_id) AS frequency,
ROUND(SUM(oi.price), 2) AS monetary
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id AND o.order_status = 'delivered'
JOIN order_items oi ON oi.order_id = o.order_id GROUP BY c.customer_unique_id
),
rfm_scores AS (SELECT *, NTILE(5) OVER (
ORDER BY recency DESC) AS r_score,
NTILE(5) OVER (ORDER BY frequency) AS f_score,
NTILE(5) OVER (ORDER BY monetary) AS m_score
FROM customer_rfm
),
final_rfm AS (SELECT *,
CONCAT(r_score, '-', f_score, '-', m_score) AS rfm_score
FROM rfm_scores
)
SELECT customer_unique_id, customer_city, customer_state, recency, frequency, monetary, r_score, f_score, m_score, rfm_score
FROM final_rfm
ORDER BY r_score DESC, f_score DESC, m_score DESC, monetary DESC
LIMIT 10;

-- Task 3 - Seller Performance & Underperformers

-- Task 3.1
SELECT s.seller_id, s.seller_state,
ROUND(SUM(oi.price), 2) AS revenue,
ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days,
ROUND(AVG(r.review_score), 2) AS avg_review_score,
COUNT(DISTINCT o.order_id) AS fulfilled_orders
FROM sellers s
JOIN order_items oi ON oi.seller_id = s.seller_id
JOIN orders o ON o.order_id = oi.order_id AND o.order_status = 'delivered'
LEFT JOIN order_reviews r ON r.order_id = o.order_id
GROUP BY s.seller_id, s.seller_state
ORDER BY revenue DESC;

-- Task 3.2
WITH seller_revenue AS (
SELECT s.seller_id, s.seller_state,
ROUND(SUM(oi.price), 2) AS revenue FROM sellers s
JOIN order_items oi ON oi.seller_id = s.seller_id
JOIN orders o ON o.order_id = oi.order_id AND o.order_status = 'delivered'
GROUP BY s.seller_id, s.seller_state)
SELECT seller_id, seller_state, revenue,
RANK() OVER (PARTITION BY seller_state
ORDER BY revenue DESC) AS state_revenue_rank
FROM seller_revenue
ORDER BY seller_state, state_revenue_rank;

-- Task 3.3
WITH seller_metrics AS (
SELECT s.seller_id,
ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days,
ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM sellers s
JOIN order_items oi ON oi.seller_id = s.seller_id
JOIN orders o ON o.order_id = oi.order_id AND o.order_status = 'delivered'
LEFT JOIN order_reviews r ON r.order_id = o.order_id
GROUP BY s.seller_id
),
overall_metrics AS (
SELECT
AVG(avg_delivery_days) AS overall_avg_delivery,
STDDEV_POP(avg_delivery_days) AS delivery_stddev,
AVG(avg_review_score) AS overall_avg_review
FROM seller_metrics
)
SELECT sm.seller_id, sm.avg_delivery_days, sm.avg_review_score
FROM seller_metrics sm
CROSS JOIN overall_metrics om
WHERE sm.avg_delivery_days >
      om.overall_avg_delivery + (2 * om.delivery_stddev)
  AND sm.avg_review_score < om.overall_avg_review
ORDER BY sm.avg_delivery_days DESC;

-- Task 4 Geographical & Shipping Analysis

-- Task 4.1
WITH state_orders AS (SELECT c.customer_state, c.customer_unique_id, o.order_id,
DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_days,
CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
THEN 1 ELSE 0 END AS is_late FROM customers c
JOIN orders o ON o.customer_id = c.customer_id AND o.order_status = 'delivered'
),
state_revenue AS (SELECT c.customer_state,
	SUM(oi.price) AS revenue
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id AND o.order_status = 'delivered'
    JOIN order_items oi ON oi.order_id = o.order_id
    GROUP BY c.customer_state
)
SELECT so.customer_state,
ROUND(sr.revenue, 2) AS revenue,
COUNT(DISTINCT so.customer_unique_id) AS unique_customers,
ROUND(AVG(so.delivery_days), 2) AS avg_delivery_days,
ROUND(100.0 * AVG(so.is_late), 2) AS pct_late_deliveries
FROM state_orders so
JOIN state_revenue sr ON sr.customer_state = so.customer_state
GROUP BY so.customer_state, sr.revenue
ORDER BY revenue DESC;

-- Task 4.2
SELECT c.customer_city, c.customer_state,
COUNT(DISTINCT o.order_id) AS total_orders,
ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN order_reviews r ON r.order_id = o.order_id
GROUP BY c.customer_city, c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 50
ORDER BY avg_review_score DESC
LIMIT 5;

-- Task 4.3
SELECT
CASE
WHEN c.customer_state = s.seller_state
THEN 'Same State'
ELSE 'Different State'
END AS shipping_type,
ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 2) AS avg_delivery_days,
ROUND(AVG(oi.freight_value), 2) AS avg_freight_value
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN sellers s ON s.seller_id = oi.seller_id
WHERE o.order_status = 'delivered'
GROUP BY
CASE
	WHEN c.customer_state = s.seller_state THEN 'Same State' ELSE 'Different State'
    END;
    
-- Task 5 - Payment Behavior & Installments Impact

-- Task 5.1 
SELECT payment_type,
COUNT(*) AS payment_count
FROM order_payments
GROUP BY payment_type
ORDER BY payment_count DESC
LIMIT 1;

-- Task 5.2
WITH order_payment AS (
SELECT order_id,
SUM(payment_value) AS order_total,
AVG(payment_installments) AS avg_installments,
MAX(CASE
	WHEN payment_type = 'credit_card' THEN 1 ELSE 0 END) AS used_credit_card
    FROM order_payments
    GROUP BY order_id
),
payment_bins AS (
SELECT *,
CASE
WHEN order_total < 50 THEN '0-50'
WHEN order_total < 100 THEN '50-100'
WHEN order_total < 200 THEN '100-200'
WHEN order_total < 500 THEN '200-500'
ELSE '500+' END AS order_value_bin
FROM order_payment
)
SELECT order_value_bin,
ROUND(AVG(avg_installments), 2) AS avg_installments,
ROUND(100.0 * AVG(used_credit_card), 2) AS pct_credit_card
FROM payment_bins
GROUP BY order_value_bin
ORDER BY
CASE order_value_bin
WHEN '0-50' THEN 1
WHEN '50-100' THEN 2
WHEN '100-200' THEN 3
WHEN '200-500' THEN 4
WHEN '500+' THEN 5
END;

-- Task 5.3
WITH credit_card_orders AS (
SELECT op.order_id,
MAX(op.payment_installments) AS installments
FROM order_payments op
WHERE op.payment_type = 'credit_card'
GROUP BY op.order_id),
installment_groups AS (
SELECT order_id,
CASE
      WHEN installments = 1 THEN '1'
      WHEN installments BETWEEN 2 AND 3 THEN '2-3'
      WHEN installments BETWEEN 4 AND 6 THEN '4-6' ELSE '7+'
	  END AS installment_group
	FROM credit_card_orders)
SELECT ig.installment_group,
ROUND(AVG(r.review_score), 2) AS avg_review_score,
ROUND(100.0 * SUM(
CASE
    WHEN r.review_score <= 3 THEN 1 ELSE 0
    END) / COUNT(r.review_score), 2) AS pct_reviews_3_or_less
FROM installment_groups ig
JOIN order_reviews r ON r.order_id = ig.order_id
GROUP BY ig.installment_group
ORDER BY
    CASE ig.installment_group
        WHEN '1' THEN 1
        WHEN '2-3' THEN 2
        WHEN '4-6' THEN 3
        WHEN '7+' THEN 4
    END;
    
-- Task 6 – Monthly Cohort Retention

WITH customer_orders AS (
SELECT c.customer_unique_id,
DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS order_month
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id AND o.order_status = 'delivered'),
customer_cohort AS (
SELECT customer_unique_id,
MIN(order_month) AS cohort_month
FROM customer_orders
GROUP BY customer_unique_id),
cohort_activity AS (
SELECT DISTINCT co.customer_unique_id, cc.cohort_month, co.order_month,
TIMESTAMPDIFF(MONTH, cc.cohort_month, co.order_month) AS month_number
FROM customer_orders co
JOIN customer_cohort cc ON cc.customer_unique_id = co.customer_unique_id),
cohort_size AS (
SELECT cohort_month, COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customer_cohort
GROUP BY cohort_month)
SELECT ca.cohort_month, cs.total_customers,
ROUND(100.0 * COUNT(DISTINCT CASE WHEN month_number = 0
THEN ca.customer_unique_id END) / cs.total_customers, 2) AS month_0,
ROUND(100.0 * COUNT(DISTINCT CASE WHEN month_number = 1
THEN ca.customer_unique_id END) / cs.total_customers, 2) AS month_1,
ROUND(100.0 * COUNT(DISTINCT CASE WHEN month_number = 2
THEN ca.customer_unique_id END) / cs.total_customers, 2) AS month_2,
ROUND(100.0 * COUNT(DISTINCT CASE WHEN month_number = 3
THEN ca.customer_unique_id END) / cs.total_customers, 2) AS month_3,
ROUND(100.0 * COUNT(DISTINCT CASE WHEN month_number = 4
THEN ca.customer_unique_id END) / cs.total_customers, 2) AS month_4,
ROUND(100.0 * COUNT(DISTINCT CASE WHEN month_number = 5
THEN ca.customer_unique_id END) / cs.total_customers, 2) AS month_5,
ROUND(100.0 * COUNT(DISTINCT CASE WHEN month_number = 6
THEN ca.customer_unique_id END) / cs.total_customers, 2) AS month_6
FROM cohort_activity ca
JOIN cohort_size cs ON cs.cohort_month = ca.cohort_month
WHERE ca.cohort_month < '2018-10-01'
GROUP BY ca.cohort_month, cs.total_customers
ORDER BY ca.cohort_month;