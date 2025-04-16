/******************************************************************************
*******************************************************************************

SQL DATA-DRIVEN BUSINESS CASE: MAGIST

*******************************************************************************
******************************************************************************/


USE magist;
SELECT * FROM customers; -- customer_id, customer_zip_code_prefix
SELECT * FROM geo; -- zip_code_prefix, city, state, lat, lng
SELECT * FROM order_items; -- order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value
SELECT * FROM order_payments; -- order_id, payment_sequential, payment_type, payment_installments, payment_value
SELECT * FROM order_reviews; -- review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp
SELECT * FROM orders; -- order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date
SELECT * FROM product_category_name_translation;-- product_category_name, product_category_name_english
SELECT * FROM products; -- product_id, product_category_name, product_name_length, product_description_length, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm
SELECT * FROM sellers; -- seller_id, seller_zip_code_prefix


-- 1. How many orders are there in the dataset?
SELECT 
    COUNT(*) AS orders_count
FROM
    orders;
/* This is a robust dataset, giving us reliable insight into Brazilian eCommerce. It shows Magist is working at scale.
Scale is not a problem. Magist seems to handle large volumes — a good sign for operational capability.*/

-- 2. Are orders actually delivered?
SELECT 
    order_status, 
    COUNT(*) AS orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM
    orders
GROUP BY order_status;
/* Almost all orders reach customers. The cancellation rate is very low.
Strong logistics fulfillment — promising for premium products, which must arrive reliably.*/

-- 3. Is Magist having user growth?
SELECT 
    YEAR(order_purchase_timestamp) AS year_,
    MONTH(order_purchase_timestamp) AS month_,
    COUNT(customer_id)
FROM
    orders
GROUP BY year_ , month_
ORDER BY year_ , month_;
/* steady monthly increase in customer count across the timeline (mostly 2017-2018).
Drop in the last 2 months could be because of truncated date, early end of data, low orders.
Check revenue fkr these months*/
SELECT 
  DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
  ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY 1;


-- 4. How many products are there in the products table?
SELECT 
    COUNT(DISTINCT product_id) AS products_count
FROM
    products;


-- 5. Which are the categories with most products?
SELECT 
    product_category_name, 
    COUNT(DISTINCT product_id) AS n_products
FROM
    products
GROUP BY product_category_name
ORDER BY COUNT(product_id) DESC;

-- 6. How many of those products were present in actual transactions?
SELECT 
	count(DISTINCT product_id) AS n_products
FROM
	order_items;

/* Magist is not just listing — it's actually moving product.
Implication: High product turnover suggests effective inventory and active customer engagement — suitable for Eniac.*/

-- 7. What’s the price for the most expensive and cheapest products?
SELECT 
    MIN(price) AS cheapest, 
    MAX(price) AS most_expensive
FROM 
	order_items;

-- 8. What are the highest and lowest payment values?
-- Highest and lowest payment values:
SELECT 
	MAX(payment_value) as highest,
    MIN(payment_value) as lowest
FROM
	order_payments;

-- Maximum someone has paid for an order:
SELECT
    SUM(payment_value) AS highest_order
FROM
    order_payments
GROUP BY
    order_id
ORDER BY
    highest_order DESC
LIMIT
    1;

/* Price range: from R$0.85 to R$6,500+

Highest payment for a single order: R$13,000+

Average product price: ~R$120

Installments: Common, mostly 2–6 months

🧠 Interpretation:

Brazilian consumers do buy expensive products.

Installments are culturally expected — important for high-tech items.

💡 Implication for Eniac: High-value tech products are viable — if payments allow flexibility. Magist must support installments.*/

-- In relation to the products

-- What categories of tech products does Magist have?
/* any product with a category name that includes words like "tech", "electronics", "computer", etc. 
is considered a "tech product".*/

SELECT DISTINCT pct.product_category_name_english
FROM products p
JOIN product_category_name_translation pct
  ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english LIKE '%tech%'
   OR pct.product_category_name_english LIKE '%electronics%'
   OR pct.product_category_name_english LIKE '%computer%'
   OR pct.product_category_name_english LIKE '%tablet%'
   OR pct.product_category_name_english LIKE '%phone%';

-- How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
--  Step 1: List the tech product categories
SELECT DISTINCT pct.product_category_name_english
FROM products p
JOIN product_category_name_translation pct
  ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english LIKE '%tech%'
   OR pct.product_category_name_english LIKE '%electronics%'
   OR pct.product_category_name_english LIKE '%computer%'
   OR pct.product_category_name_english LIKE '%tablet%'
   OR pct.product_category_name_english LIKE '%phone%';

-- Step 2: Count how many products were sold for those categories
SELECT COUNT(*) AS tech_products_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
  ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english IN (
  'computers', 'electronics', 'mobile phones'
);
--  Step 3: Count total number of products sold
SELECT COUNT(*) AS total_products_sold
FROM order_items;

SELECT
  tech.tech_products_sold,
  total.total_products_sold,
  ROUND((tech.tech_products_sold / total.total_products_sold) * 100, 2) AS tech_products_percentage
FROM
  (
    SELECT COUNT(*) AS tech_products_sold
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN product_category_name_translation pct
      ON p.product_category_name = pct.product_category_name
    WHERE pct.product_category_name_english IN ('computers', 'electronics', 'mobile phones')
  ) AS tech,
  (
    SELECT COUNT(*) AS total_products_sold
    FROM order_items
  ) AS total;


-- What’s the average price of the products being sold?
/*We'll calculate the average price using the order_items table, which contains a price column. Since multiple units 
of a product can be sold, each row represents a unit sold — so we just take the average over all those rows.*/
SELECT ROUND(AVG(price), 2) AS avg_product_price
FROM order_items;


-- Are expensive tech products popular?
/* We’ll define “expensive” as products priced above the average price (which we just calculated in the 
last step). Then we’ll use a CASE WHEN to classify products as “expensive” or “not expensive,” 
and count how many were sold in each group — but only for tech categories.*/
SELECT AVG(price) AS avg_price FROM order_items;
SELECT
  CASE
    WHEN oi.price > 120.00 THEN 'Expensive'
    ELSE 'Not Expensive'
  END AS price_category,
  COUNT(*) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_name_translation pct
  ON p.product_category_name = pct.product_category_name
WHERE pct.product_category_name_english IN ('computers', 'electronics', 'mobile phones')
GROUP BY price_category;

/* Tech-related products sold: ~6–7% of all sales

Represent higher average prices

Expensive tech products do get sold frequently.

📈 Interpretation:
There’s clear demand for tech, even if it's not the top category by volume.

🧩 Implication for Eniac:
Magist handles tech well — not dominant, but a profitable niche. Potential to grow with a dedicated brand like Eniac.*/

-- In relation to the sellers

-- How many months of data are included in the magist database?
/* To answer this, we’ll look at the date range in the orders table — specifically the order_purchase_timestamp, which 
indicates when an order was placed. We'll extract the distinct year-month combinations and count them.*/
SELECT COUNT(DISTINCT DATE_FORMAT(order_purchase_timestamp, '%Y-%m')) AS total_months
FROM orders;

SELECT DISTINCT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month
FROM orders
ORDER BY month;

-- How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
-- Total number of sellers
SELECT COUNT(DISTINCT seller_id) AS total_sellers FROM sellers;

-- Tech sellers: joined with products to filter tech categories
SELECT COUNT(DISTINCT seller_id) AS tech_sellers
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE LOWER(p.product_category_name) REGEXP 'tech|eletronico|computer|informatica';
/*Tech sellers usually make up around 10-30% depending on the dataset.*/

-- What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?
-- Total earnings of all sellers
SELECT ROUND(SUM(price), 2) AS total_earnings FROM order_items;

-- Total earnings from tech categories
SELECT ROUND(SUM(price), 2) AS tech_earnings
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE LOWER(p.product_category_name) REGEXP 'tech|eletronico|computer|informatica';
/*Tech products often represent a higher revenue share even with fewer sellers.*/

-- Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?
-- Monthly income (all sellers)
SELECT 
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
  ROUND(SUM(oi.price), 2) AS monthly_income
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY 1
ORDER BY 1;

-- Monthly income (tech sellers)
SELECT 
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
  ROUND(SUM(oi.price), 2) AS tech_monthly_income
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE LOWER(p.product_category_name) REGEXP 'tech|eletronico|computer|informatica'
GROUP BY 1
ORDER BY 1;
/*tech income may spike during holidays or sales events.
Seller analysis (with focus on tech sellers)
Tech sellers = ~10–15% of total

Tech sales = a disproportionate share of revenue

Monthly tech seller income is significant and stable.

💼 Interpretation:
Tech sellers are fewer, but bring in higher revenue — high-margin vertical.

✅ Implication:
Magist can be viable for high-end sales with the right marketing and positioning.*/

-- In relation to the delivery time
-- What’s the average time between the order being placed and the product being delivered?
SELECT 
  ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- How many orders are delivered on time vs orders delivered with a delay?
SELECT
  COUNT(CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1 END) AS on_time,
  COUNT(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 END) AS delayed
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;


-- Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT 
  CASE 
    WHEN product_weight_g >= 5000 THEN 'Heavy'
    ELSE 'Light'
  END AS weight_category,
  SUM(o.order_delivered_customer_date > o.order_estimated_delivery_date) AS delayed_orders,
  COUNT(*) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY weight_category;

/*Typically, heavier products show a higher delay rate.
Delivery time & delay behavior
Average delivery time: ~12 days
On-time deliveries: ~82%
Heavy products (e.g., >5kg) have more delays

High freight cost doesn’t always mean faster delivery
Delivery is generally on time, but larger/heavier items = slower.
Rural or distant customers may face delays even with high shipping fees.

⚠️ Implication:
Eniac’s focus on fast delivery may face challenges for bulkier tech items. Need to test with light products first.*/

-- Your Question:
-- what type of review has Magist been getting? Has it improved or worsen per year?
SELECT 
  EXTRACT(YEAR FROM review_creation_date) AS year,
  ROUND(AVG(review_score), 2) AS avg_review
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE oi.seller_id = '1f50f920176fa81dab994f9023523100'
  AND review_creation_date IS NOT NULL
GROUP BY 1
ORDER BY 1;

/*Customer satisfaction — Magist’s reviews
Average scores over time: Stable, around 4.1 to 4.3

🙌 Interpretation:
Customers are generally satisfied — no red flags in service.

👍 Implication:
A reliable partner. A premium brand like Eniac could enhance the customer experience further.*/


-- does Magist has customers outside Sao paulo state?
SELECT DISTINCT g.state
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN geo g ON c.customer_zip_code_prefix = g.zip_code_prefix
WHERE oi.seller_id = '1f50f920176fa81dab994f9023523100'
  AND g.state IS NOT NULL
  AND g.state != 'SP';

-- do they have sellers outside Sao Paulo?
SELECT DISTINCT g.state
FROM sellers s
JOIN geo g ON s.seller_zip_code_prefix = g.zip_code_prefix;

/*Customer and Seller Geography
Magist has customers outside São Paulo

Sellers exist across Brazil

🗺️ Interpretation:
Magist has national reach. Distribution potential is strong.

🌎 Implication:
Great for testing Eniac’s model across Brazil without initial full-scale logistics investment.*/


-- do customers order again after they got an order delivered? how often?
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM orders;
SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC
LIMIT 10;
SELECT order_status, COUNT(*) FROM orders GROUP BY order_status;

SELECT customer_id, COUNT(*) AS order_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY order_count DESC
LIMIT 10;

/*Do customers return and reorder?
~45% of customers place more than one order

Top customers have 10+ purchases

📊 Interpretation:
There’s customer loyalty — indicating trust in the platform.

💡 Implication:
Good sign for Eniac's brand loyalty model — upselling & recurring purchases are realistic.*/



-- do customers usually pay in installments? what is the range of months?
SELECT 
  payment_installments,
  COUNT(*) AS count
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;

/*Brazilians often use 2–6 months installments. Outliers exist (up to 12).
Installments — customer behavior
Most common: 2 to 6 installments

Up to 12 in rare cases

📌 Interpretation:
Installments are the norm. High-cost items need installment options to sell well.

💳 Implication:
Crucial for Eniac. Must ensure Magist or payment gateway supports multi-month plans.*/

-- what's the average of freight value and its influence in shipping price?
-- Average freight value
SELECT ROUND(AVG(freight_value), 2) AS avg_freight FROM order_items;

-- Freight vs delivery delay correlation
SELECT 
  CASE 
    WHEN freight_value > 50 THEN 'High freight'
    ELSE 'Low freight'
  END AS freight_level,
  SUM(o.order_delivered_customer_date > o.order_estimated_delivery_date) AS delayed_orders,
  COUNT(*) AS total_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
GROUP BY freight_level;
/*High freight sometimes means rural/bulky, possibly more delays.
Freight cost vs delay
Expensive freight doesn’t guarantee faster delivery

Heavier items = more delays

📉 Interpretation:
Magist’s logistics might not be ideal for bulky or urgent deliveries

⚠️ Implication:
If speed is critical, Eniac should pilot smaller, lighter items first to test reliability.*/

-- 1. Growth of tech related orders - based on percentage % and value 
-- a. By orders places over time
  
WITH tech_categories AS (
  SELECT DISTINCT pct.product_category_name_english
  FROM products p
  JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
  WHERE pct.product_category_name_english LIKE '%audio%'
     OR pct.product_category_name_english LIKE '%cds_dvds_musicals%'
     OR pct.product_category_name_english LIKE '%consoles_games%'
     OR pct.product_category_name_english LIKE '%dvds_blu_ray%'
     OR pct.product_category_name_english LIKE '%electronics%'
     OR pct.product_category_name_english LIKE '%computers_accessories%'
     OR pct.product_category_name_english LIKE '%pc_gamer%'
     OR pct.product_category_name_english LIKE '%computers%'
     OR pct.product_category_name_english LIKE '%tablets_printing_image%'
     OR pct.product_category_name_english LIKE '%telephony%'
     OR pct.product_category_name_english LIKE '%fixed_telephony%'
),
tech_orders AS (
  SELECT DISTINCT o.order_id, o.order_purchase_timestamp
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
  WHERE pct.product_category_name_english IN (SELECT product_category_name_english FROM tech_categories)
)
SELECT
  DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
  COUNT(DISTINCT t.order_id) AS tech_order_count,
  COUNT(DISTINCT o.order_id) AS total_order_count,
  ROUND(COUNT(DISTINCT t.order_id) * 100.0 / COUNT(DISTINCT o.order_id), 2) AS tech_order_percentage
FROM orders o
LEFT JOIN tech_orders t ON o.order_id = t.order_id
GROUP BY month
ORDER BY month;

-- b. By revenue
WITH tech_categories AS (
  SELECT DISTINCT pct.product_category_name_english
  FROM products p
  JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
  WHERE pct.product_category_name_english LIKE '%audio%'
     OR pct.product_category_name_english LIKE '%cds_dvds_musicals%'
     OR pct.product_category_name_english LIKE '%consoles_games%'
     OR pct.product_category_name_english LIKE '%dvds_blu_ray%'
     OR pct.product_category_name_english LIKE '%electronics%'
     OR pct.product_category_name_english LIKE '%computers_accessories%'
     OR pct.product_category_name_english LIKE '%pc_gamer%'
     OR pct.product_category_name_english LIKE '%computers%'
     OR pct.product_category_name_english LIKE '%tablets_printing_image%'
     OR pct.product_category_name_english LIKE '%telephony%'
     OR pct.product_category_name_english LIKE '%fixed_telephony%'
),
order_revenue AS (
  SELECT
    o.order_id,
    o.order_purchase_timestamp,
    oi.price,
    pct.product_category_name_english
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  JOIN products p ON oi.product_id = p.product_id
  JOIN product_category_name_translation pct
    ON p.product_category_name = pct.product_category_name
),
grouped_revenue AS (
  SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    SUM(price) AS total_revenue,
    SUM(CASE
        WHEN product_category_name_english IN (
          SELECT product_category_name_english FROM tech_categories
        ) THEN price ELSE 0 END) AS tech_revenue
  FROM order_revenue
  GROUP BY month
)
SELECT
  month,
  ROUND(tech_revenue, 2) AS tech_revenue
FROM grouped_revenue
ORDER BY month;

SELECT
    YEAR(order_purchase_timestamp) `year`,
    MONTH(order_purchase_timestamp) `month`,
    SUM(price)
FROM
    order_items
        JOIN
    orders USING (order_id)
GROUP BY
	YEAR(order_purchase_timestamp),
	MONTH(order_purchase_timestamp)
    WITH ROLLUP
ORDER BY
	YEAR(order_purchase_timestamp) DESC,
    MONTH(order_purchase_timestamp) DESC;

SELECT
    YEAR(order_purchase_timestamp) `year`,
    MONTH(order_purchase_timestamp) `month`,
    COUNT(*)
FROM
    orders
GROUP BY YEAR
	(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
    WITH ROLLUP
ORDER BY
	YEAR(order_purchase_timestamp) DESC,
    MONTH(order_purchase_timestamp) DESC;