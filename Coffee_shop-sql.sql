-- Monday Coffee SCHEMAS

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS city;

-- Import Rules
-- 1st import to city
-- 2nd import to products
-- 3rd import to customers
-- 4th import to sales


CREATE TABLE city
(
	city_id	INT PRIMARY KEY,
	city_name VARCHAR(15),	
	population	BIGINT,
	estimated_rent	FLOAT,
	city_rank INT
);

CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(25),	
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);


CREATE TABLE products
(
	product_id	INT PRIMARY KEY,
	product_name VARCHAR(35),	
	Price float
);


CREATE TABLE sales
(
	sale_id	INT PRIMARY KEY,
	sale_date	date,
	product_id	INT,
	customer_id	INT,
	total FLOAT,
	rating INT,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);

-- END of SCHEMAS

SELECT * FROM city;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM sales;

-- Reports and Data Analysis



-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
SELECT 
	city_name,
	ROUND((population * 0.25)/1000000,2) as coffee_consumers_in_millions,
	city_rank
FROM city
ORDER BY 2 DESC;

--Q2. Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
SELECT 
	SUM(total) as total_revenue 
FROM sales
WHERE 
	EXTRACT (YEAR FROM sale_date) = 2023 
	AND
	EXTRACT (QUARTER FROM sale_date) = 4;

-- Calculate as per city
SELECT 
	ct.city_name,
	SUM(total) as total_revenue 
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN city ct
ON ct.city_id = c.city_id
WHERE 
	EXTRACT (YEAR FROM sale_date) = 2023 
	AND
	EXTRACT (QUARTER FROM sale_date) = 4
GROUP BY 1
ORDER BY 2 DESC;

-- Q.3
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?
SELECT * FROM products ;

SELECT 
	p.product_name,
	COUNT(s.total) as sold_count
FROM sales s
JOIN products p
ON s.product_Id = p.product_id
GROUP BY 1 
ORDER BY 1;

-- Q.4
-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?

-- city abd total sale
-- no cus in each these city

SELECT 
	ct.city_name,
	SUM(s.total) as total_revenue,
	COUNT(DISTINCT s.customer_id) as total_customer,
	ROUND(
		SUM(s.total)::numeric/COUNT(DISTINCT s.customer_id)::numeric ,2
	)as avg_sales_pr_customer
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN city ct
ON ct.city_id = c.city_id 
GROUP BY 1
ORDER BY 2 DESC;


-- -- Q.5 City Population and Coffee Consumers (25%)
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- return city_name, total current cx, estimated coffee consumers (25%)
WITH city_cte AS(
SELECT 
	city_name,
	ROUND((population * 0.25)/1000000,2) AS coffee_consumers
FROM city),

customer_cte AS (
SELECT 
	ct.city_name,
	COUNT(DISTINCT c.customer_id) as current_cx 
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN city ct
ON ct.city_id = c.city_id
GROUP BY 1
ORDER BY 1,2
)
SELECT 
	customer_cte.city_name,
	city_cte.coffee_consumers as coffee_consumer_in_millions,
	customer_cte.current_cx as unique_customers
FROM city_cte 
JOIN customer_cte
ON city_cte.city_name = customer_cte.city_name


-- -- Q6
-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?
WITH cte AS (
SELECT 
	ct.city_name,
	p.product_name,
	COUNT(s.sale_id) as total_ordrs,
	DENSE_RANK() OVER(PARTITION BY ct.city_name ORDER BY COUNT(s.sale_id) DESC) as rnk	
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN city ct
ON ct.city_id = c.city_id
JOIN products p
ON s.product_id = p.product_id
GROUP BY 1,2)
SELECT 
	* 
FROM cte
WHERE rnk <=3;


-- Q.7
-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

(SELECT
	ct.city_name,
	COUNT(DISTINCT c.customer_id) AS unique_customer_count
FROM city ct
JOIN customers c
ON ct.city_id = c.city_id
GROUP BY ct.city_name) ;

-- -- Q.8
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer
WITH customer_cte AS (SELECT 
	ct.city_name,
	SUM(total) AS total_revenue,
	COUNT(DISTINCT s.customer_id) as total_customers,
	ROUND(SUM(total)::numeric/COUNT(DISTINCT s.customer_id)::numeric, 2) as avg_sales_pr_customer
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN city ct
ON ct.city_id = c.city_id
GROUP BY 1
ORDER BY 2 DESC),

rent_cte AS (
SELECT 
	ct.city_name,
	ct.estimated_rent,
	ROUND(ct.estimated_rent::numeric/COUNT(DISTINCT s.customer_id)::numeric, 2) as avg_rent_pr_customer
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN city ct
ON ct.city_id = c.city_id
GROUP BY 1,2
)
SELECT 
	customer_cte.city_name,
	customer_cte.avg_sales_pr_customer,
	rent_cte.avg_rent_pr_customer
FROM customer_cte 
JOIN rent_cte
ON customer_cte.city_name = rent_cte.city_name
ORDER BY 2 DESC;



-- Q.9
-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly)
-- by each city
WITH monthly_sales_cte AS (SELECT 
	ct.city_name as city_name,
	EXTRACT(MONTH FROM s.sale_date) as sale_month,
	EXTRACT(YEAR FROM s.sale_date) as sale_year,
	SUM(s.total) as total_sales
FROM sales s
JOIN customers c
ON c.customer_id = s.customer_id
JOIN city ct
ON c.city_id = ct.city_id
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3),

growth_ratio_cte AS(
SELECT
	city_name,
	sale_month,
	sale_year,
	total_sales as current_month_sale,
	LAG(total_sales, 1) OVER(PARTITION BY city_name ORDER BY sale_year, sale_month) as last_month_sale
FROM monthly_sales_cte
)
SELECT 
	city_name,
	sale_month,
	sale_year,
	current_month_sale,
	last_month_sale,
	ROUND((current_month_sale - last_month_sale)::numeric / last_month_sale::numeric *100, 2) as growth_percentage 
FROM growth_ratio_cte
WHERE last_month_sale IS NOT NULL

-- Q.10
-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer

WITH city_cte AS (
SELECT 
	ct.city_name,
	SUM(s.total) AS total_revenue,
	COUNT(DISTINCT s.customer_id) as total_customer,
	ROUND(SUM(s.total)::numeric / COUNT(DISTINCT s.customer_id)::numeric, 2) AS avg_sale_per_customer
FROM sales s
JOIN customers c
ON s.customer_id = c.customer_id
JOIN city ct
ON ct.city_id = c.city_id
GROUP BY 1
ORDER BY 2 DESC),

rent_cte AS (
SELECT
	city_name,
	estimated_rent,
	ROUND((population * 0.25)/1000000,2) as coffee_consumers
FROM city	
)
SELECT 
	cc.city_name,
	cc.total_revenue,
	rc.estimated_rent as total_rent,
	cc.total_customer,
	rc.coffee_consumers as estimated_coffee_consumers,
	cc.avg_sale_per_customer,
	ROUND(rc.estimated_rent :: numeric / cc.total_customer::numeric, 2) as avg_rent_per_customer
FROM city_cte cc
JOIN rent_cte rc
ON cc.city_name = rc.city_name
ORDER BY 6 DESC,7 ASC ;

















