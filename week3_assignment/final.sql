-- ------------------------------------------------------
-- Week 3 Final Combined Query + Mini Project
-- Dataset: Superstore_clean.csv
-- ------------------------------------------------------

-- 1️ Final Combined Query
-- Meaning: Show each customer's name, total sales, and rank
WITH customer_sales AS (
  SELECT c.Customer_Name, SUM(o.Sales) AS total_sales
  FROM customers c
  JOIN orders o ON c.Customer_ID = o.Customer_ID
  GROUP BY c.Customer_Name
)
SELECT Customer_Name, total_sales,
       RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM customer_sales;

-- ------------------------------------------------------

-- 2️ Mini Project: Customer Sales Insights

-- Top 5 customers
-- Meaning: Five highest spenders
WITH customer_sales AS (
  SELECT Customer_ID, SUM(Sales) AS total_sales
  FROM orders
  GROUP BY Customer_ID
)
SELECT Customer_ID, total_sales
FROM customer_sales
ORDER BY total_sales DESC
LIMIT 5;

-- ------------------------------------------------------

-- Bottom 5 customers
-- Meaning: Five lowest spenders
WITH customer_sales AS (
  SELECT Customer_ID, SUM(Sales) AS total_sales
  FROM orders
  GROUP BY Customer_ID
)
SELECT Customer_ID, total_sales
FROM customer_sales
ORDER BY total_sales ASC
LIMIT 5;

-- ------------------------------------------------------

-- Customers with only one order
-- Meaning: One-time buyers
SELECT Customer_ID
FROM orders
GROUP BY Customer_ID
HAVING COUNT(Order_ID) = 1;

-- ------------------------------------------------------

-- Customers with above-average sales
-- Meaning: Customers spending more than average
WITH customer_sales AS (
  SELECT Customer_ID, SUM(Sales) AS total_sales
  FROM orders
  GROUP BY Customer_ID
)
SELECT *
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales);

-- ------------------------------------------------------

-- Highest order value per customer
-- Meaning: Largest single order per customer
SELECT Customer_ID, MAX(Sales) AS highest_order
FROM orders
GROUP BY Customer_ID;

-- ------------------------------------------------------
-- ------------------------------------------------------
