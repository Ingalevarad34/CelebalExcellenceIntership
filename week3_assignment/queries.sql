-- ------------------------------------------------------
-- Week 3 Queries File
-- Dataset: Superstore_clean.csv
-- ------------------------------------------------------

-- 1️ Orders above average sales
-- Meaning: High-value orders
SELECT *
FROM orders
WHERE Sales > (SELECT AVG(Sales) FROM orders);

-- 2️ Highest sales order per customer
-- Meaning: Biggest purchase per customer
SELECT o.Customer_ID, o.Order_ID, o.Sales
FROM orders o
WHERE o.Sales = (
  SELECT MAX(Sales)
  FROM orders
  WHERE Customer_ID = o.Customer_ID
);

-- 3️ Total sales per customer (CTE)
-- Meaning: Aggregate spend per customer
WITH customer_sales AS (
  SELECT Customer_ID, SUM(Sales) AS total_sales
  FROM orders
  GROUP BY Customer_ID
)
SELECT * FROM customer_sales;

-- 4️ Customers above average sales (CTE + Subquery)
-- Meaning: Customers spending more than average
WITH customer_sales AS (
  SELECT Customer_ID, SUM(Sales) AS total_sales
  FROM orders
  GROUP BY Customer_ID
)
SELECT *
FROM customer_sales
WHERE total_sales > (SELECT AVG(total_sales) FROM customer_sales);

-- 5️ Rank customers by sales (Window Function)
-- Meaning: Rank customers by spend
WITH customer_sales AS (
  SELECT Customer_ID, SUM(Sales) AS total_sales
  FROM orders
  GROUP BY Customer_ID
)
SELECT Customer_ID, total_sales,
       RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM customer_sales;

-- 6️ Row numbers per order within customer
-- Meaning: Sequence orders per customer
SELECT Customer_ID, Order_ID, Sales,
       ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS order_row
FROM orders;

-- 7️ Top 3 customers
-- Meaning: Three highest spenders
WITH customer_sales AS (
  SELECT Customer_ID, SUM(Sales) AS total_sales
  FROM orders
  GROUP BY Customer_ID
)
SELECT Customer_ID, total_sales
FROM customer_sales
ORDER BY total_sales DESC
LIMIT 3;

-- ------------------------------------------------------
-- ------------------------------------------------------
