
-- CUSTOMER SEGMENTATION PER LOCATION

SELECT
	state,
	COUNT(DISTINCT customer_id) AS customer_count
FROM customers
GROUP BY state;


-- SALES AND QUANTITY TABLES

-- Sales
SELECT
	brands.brand_name,
    products.product_name,
    categories.category_name AS category,
    SUM(total) AS sales
FROM order_items
	LEFT JOIN products ON order_items.product_id = products.product_id
	LEFT JOIN brands ON products.brand_id = brands.brand_id
	LEFT JOIN categories ON products.category_id = categories.category_id
GROUP BY brands.brand_name, products.product_name, categories.category_name
ORDER BY sales DESC;


-- Quantity
SELECT
	brands.brand_name,
    products.product_name,
    categories.category_name AS category,
    SUM(quantity) AS quantity_sold
FROM order_items
	LEFT JOIN products ON order_items.product_id = products.product_id
	LEFT JOIN brands ON products.brand_id = brands.brand_id
	LEFT JOIN categories ON products.category_id = categories.category_id
GROUP BY brands.brand_name, products.product_name,categories.category_name
ORDER BY quantity_sold DESC;


-- STORE PERFORMANCE ANALYSIS
SELECT
	stores.store_id,
    stores.store_name AS store,
    COUNT(DISTINCT customers.customer_id) AS customer_count,
    COUNT(DISTINCT customers.customer_id) / 
		(SELECT DISTINCT COUNT(customers.customer_id) FROM customers) AS customer_share,
    SUM(order_items.total) AS sales,
    SUM(order_items.total) / 
		(SELECT SUM(order_items.total) FROM order_items) AS sales_share,
    AVG(order_items.total) AS avg_sales_per_cust
FROM stores
	LEFT JOIN orders ON stores.store_id = orders.store_id
	LEFT JOIN customers ON orders.customer_id = customers.customer_id
	LEFT JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY stores.store_id, stores.store_name;


-- SALES AND ORDER TREND ANALYSIS

-- Determine when the first and last order was made
SELECT 
    MIN(order_date) AS first_order_date, -- first order
    MAX(order_date) AS last_order_date -- last order
FROM orders;

-- Sales Trend over the years (3 years)
SELECT
	YEAR(order_date) AS yr,
    MONTH(order_date) AS mo,
    SUM(total) AS sales
FROM orders
LEFT JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY yr, mo
ORDER BY yr, mo;

-- Sales Trend per store
SELECT
	YEAR(order_date) AS yr,
    MONTH(order_date) AS mo,
    SUM(CASE WHEN orders.store_id = 1 THEN order_items.total ELSE NULL END) AS store1_sales,
    SUM(CASE WHEN orders.store_id = 2 THEN order_items.total ELSE NULL END) AS store2_sales,
    SUM(CASE WHEN orders.store_id = 3 THEN order_items.total ELSE NULL END) AS store3_sales
FROM order_items
LEFT JOIN orders ON orders.order_id = order_items.order_id
GROUP BY yr, mo
ORDER BY yr, mo;

-- Order Trend
SELECT
	YEAR(order_date) AS yr,
    MONTH(order_date) AS mo,
    COUNT(order_id) AS order_count
FROM orders
GROUP BY yr, mo
ORDER BY yr, mo;

-- Order Trend per store
SELECT
	YEAR(order_date) AS yr,
    MONTH(order_date) AS mo,
	COUNT(CASE WHEN orders.store_id = 1 THEN orders.order_id ELSE NULL END) AS store1_order_count,
    COUNT(CASE WHEN orders.store_id = 2 THEN orders.order_id ELSE NULL END) AS store2_order_count,
    COUNT(CASE WHEN orders.store_id = 3 THEN orders.order_id ELSE NULL END) AS store3_order_count
FROM orders
LEFT JOIN stores ON orders.store_id = stores.store_id
GROUP BY yr, mo
ORDER BY yr, mo;

-- How are current stocks distributed per store?
SELECT
	stocks.store_id,
	COUNT(stocks.quantity) AS quantity
FROM stocks
GROUP BY 1;


-- ORDER-TO-STAFF-RATIO per Quarter
SELECT
	YEAR(orders.order_date) AS yr,
	QUARTER(orders.order_date) AS qtr,
	COUNT(DISTINCT staffs.staff_id) AS staff_count,
    COUNT(DISTINCT orders.order_id) AS order_count,
    COUNT(DISTINCT orders.order_id) / 
		COUNT(DISTINCT staffs.staff_id) AS order_to_staff_ratio
FROM staffs
LEFT JOIN orders ON staffs.staff_id = orders.staff_id
GROUP BY yr, qtr;
