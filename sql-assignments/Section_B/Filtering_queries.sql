-- Section B — Filtering & Optimization (WHERE, Indexes)

-- Q7. Retrieve all orders with status = 'Delivered'.

SELECT * FROM orders
WHERE status = 'Delivered';

-- Q8. Find all products in the 'Electronics' category with a unit_price greater than ₹2000.

SELECT * FROM products
WHERE category = 'Electronics'
  AND unit_price > 2000;


-- Q9. List all customers who joined in the year 2024 and belong to the state 'Maharashtra'.

SELECT * FROM customers
WHERE state = 'Maharashtra'
  AND join_date >= '2024-01-01'
  AND join_date < '2025-01-01';
  
-- Q10. Find all orders placed between '2024-08-10' and '2024-08-25' (inclusive) that are NOT cancelled.

SELECT * FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
  AND status != 'Cancelled';
  
-- Q11. Explain what the index idx_orders_date does. How would it improve the performance of a query that filters orders by order_date? Write a sample query that would benefit from this index.

/*What it does: idx_orders_date creates a B-Tree index on the order_date column.
 Instead of scanning every row in orders, the database uses the index to jump directly to the matching date range — much faster on large tables.

Query that benefits from it:*/

SELECT * FROM orders
WHERE order_date BETWEEN '2024-08-01' AND '2024-08-31';



-- Q12. If you run: SELECT * FROM customers WHERE YEAR(join_date) = 2024; — would the index on join_date be used? Explain why or why not, and rewrite the query to be index-friendly (SARGable).

/*Problem: YEAR(join_date) = 2024 wraps the column in a function, so the index cannot be used — the DB must scan every row and compute YEAR() on each one.
Index-friendly rewrite (SARGable):*/

-- BAD (not index-friendly)
SELECT * FROM customers WHERE YEAR(join_date) = 2024;

-- GOOD (SARGable — index on join_date can be used)
SELECT * FROM customers
WHERE join_date >= '2024-01-01'
  AND join_date < '2025-01-01';
