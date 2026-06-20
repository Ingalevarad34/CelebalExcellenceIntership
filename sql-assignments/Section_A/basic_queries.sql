-- Section A — SQL Basics (SELECT, Constraints, Primary Keys)

-- Q1. Write a query to display all columns and rows from the customer's table.

SELECT * FROM customers;

-- Q2. Retrieve only the first_name, last_name, and city of all customers.

SELECT first_name, last_name, city FROM customers;

-- Q3. List all unique categories available in the products table.

SELECT DISTINCT category FROM products;

-- Q4. Identify the Primary Key of each table in the schema. Explain why a Primary Key must be unique and NOT NULL.

/*Primary Keys in this schema:
• customers → customer_id
• products → product_id
• orders → order_id
• order_items → item_id

Why UNIQUE & NOT NULL? A primary key uniquely identifies every row. 
If it were NULL, the row has no identity and cannot be referenced. 
If two rows had the same PK, the database couldn't tell them apart — causing data integrity failures in JOINs and foreign key references.*/


-- Q5. What constraints are applied to the email column in the customers table? What would happen if you tried to insert a duplicate email?

/*The email column has two constraints: UNIQUE and NOT NULL.

If you insert a duplicate email, the database raises a unique constraint violation error and rejects the INSERT. 
The row is not added. This protects against duplicate accounts.*/


-- Q6Try inserting a product with unit_price = -50. What happens and which constraint prevents it? Write both the INSERT statement and explain the error.

-- This INSERT will FAIL

INSERT INTO products VALUES
(209, 'Broken Item', 'Electronics', 'TestBrand', -50.00, 10);

/*Error produced: CHECK constraint violation on unit_price > 0.
The database rejects the row because –50 fails the check. This prevents nonsensical pricing data from entering the system.*/