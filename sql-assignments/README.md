# 🛒 ShopEase SQL Assessment — Week 2, Task 2
> Celebal Technologies Internship | MySQL Workbench Setup & Solution Guide

---

#

## 🧰 Prerequisites

| Tool | Version | Download |
|------|---------|----------|
| MySQL Server | 8.0+ | https://dev.mysql.com/downloads/installer/ |
| MySQL Workbench | 8.0+ | Included with MySQL Installer |

---

## ⚙️ Setup — Step by Step

### Step 1 — Install MySQL

1. Go to https://dev.mysql.com/downloads/installer/
2. Download the **MySQL Installer for Windows** (~450 MB full version)
3. Run the installer → choose **"Developer Default"**
4. Set a **root password** during setup — save it somewhere safe
5. Finish installation — MySQL Workbench is included automatically

---

### Step 2 — Open MySQL Workbench

1. Launch **MySQL Workbench** from the Start Menu
2. Click **"Local instance MySQL80"**
3. Enter your root password → click **OK**
4. The SQL editor will open

---

### Step 3 — Create the Database

Open a new query tab and run:

```sql
CREATE DATABASE shopease;
USE shopease;
```

---

### Step 4 — Create Tables

Run the following SQL to create all 4 tables:

```sql
CREATE TABLE customers (
  customer_id  INT           PRIMARY KEY,
  first_name   VARCHAR(50)   NOT NULL,
  last_name    VARCHAR(50)   NOT NULL,
  email        VARCHAR(100)  UNIQUE NOT NULL,
  city         VARCHAR(50)   NOT NULL,
  state        VARCHAR(50)   NOT NULL,
  join_date    DATE          NOT NULL,
  is_premium   BOOLEAN       DEFAULT FALSE
);

CREATE TABLE products (
  product_id   INT           PRIMARY KEY,
  product_name VARCHAR(100)  NOT NULL,
  category     VARCHAR(50)   NOT NULL,
  brand        VARCHAR(50)   NOT NULL,
  unit_price   DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
  stock_qty    INT           NOT NULL DEFAULT 0 CHECK (stock_qty >= 0)
);

CREATE TABLE orders (
  order_id     INT           PRIMARY KEY,
  customer_id  INT           NOT NULL,
  order_date   DATE          NOT NULL,
  status       VARCHAR(20)   NOT NULL DEFAULT 'Pending'
               CHECK (status IN ('Pending','Shipped','Delivered','Cancelled')),
  total_amount DECIMAL(12,2) NOT NULL CHECK (total_amount >= 0),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
  item_id      INT           PRIMARY KEY,
  order_id     INT           NOT NULL,
  product_id   INT           NOT NULL,
  quantity     INT           NOT NULL CHECK (quantity > 0),
  unit_price   DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
  discount_pct DECIMAL(5,2)  DEFAULT 0 CHECK (discount_pct BETWEEN 0 AND 100),
  FOREIGN KEY (order_id)   REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

---

### Step 5 — Create Indexes

```sql
CREATE INDEX idx_customers_city     ON customers(city);
CREATE INDEX idx_customers_state    ON customers(state);
CREATE INDEX idx_products_category  ON products(category);
CREATE INDEX idx_orders_date        ON orders(order_date);
CREATE INDEX idx_orders_status      ON orders(status);
```

---

### Step 6 — Insert Sample Data

```sql
-- Customers
INSERT INTO customers VALUES
(101,'Aarav','Sharma','aarav.s@email.com','Mumbai','Maharashtra','2024-01-15',TRUE),
(102,'Priya','Patel','priya.p@email.com','Ahmedabad','Gujarat','2024-02-20',FALSE),
(103,'Rohan','Gupta','rohan.g@email.com','Delhi','Delhi','2024-03-10',TRUE),
(104,'Sneha','Reddy','sneha.r@email.com','Hyderabad','Telangana','2024-04-05',FALSE),
(105,'Vikram','Singh','vikram.s@email.com','Jaipur','Rajasthan','2024-05-12',TRUE),
(106,'Ananya','Iyer','ananya.i@email.com','Chennai','Tamil Nadu','2024-06-18',FALSE),
(107,'Karan','Mehta','karan.m@email.com','Pune','Maharashtra','2024-07-22',TRUE),
(108,'Divya','Nair','divya.n@email.com','Kochi','Kerala','2024-08-30',FALSE);

-- Products
INSERT INTO products VALUES
(201,'Wireless Earbuds','Electronics','BoAt',1499.00,250),
(202,'Cotton T-Shirt','Clothing','Levis',799.00,500),
(203,'Smart Watch','Electronics','Noise',2999.00,150),
(204,'Running Shoes','Clothing','Nike',4599.00,120),
(205,'Bluetooth Speaker','Electronics','JBL',3499.00,200),
(206,'Bedsheet Set','Home','Spaces',1299.00,300),
(207,'Laptop Stand','Electronics','AmazonBasics',899.00,180),
(208,'Cushion Covers (Set)','Home','HomeCenter',599.00,400);

-- Orders
INSERT INTO orders VALUES
(1001,101,'2024-08-01','Delivered',4498.00),
(1002,102,'2024-08-03','Delivered',799.00),
(1003,103,'2024-08-05','Shipped',7498.00),
(1004,101,'2024-08-10','Delivered',3499.00),
(1005,104,'2024-08-12','Cancelled',2999.00),
(1006,105,'2024-08-15','Delivered',5898.00),
(1007,106,'2024-08-18','Pending',1299.00),
(1008,103,'2024-08-20','Delivered',899.00),
(1009,107,'2024-08-25','Shipped',6098.00),
(1010,108,'2024-08-28','Delivered',1598.00);

-- Order Items
INSERT INTO order_items VALUES
(5001,1001,201,2,1499.00,0),(5002,1001,207,1,899.00,10),
(5003,1002,202,1,799.00,0),(5004,1003,203,1,2999.00,0),
(5005,1003,204,1,4599.00,5),(5006,1004,205,1,3499.00,0),
(5007,1005,203,1,2999.00,0),(5008,1006,201,1,1499.00,10),
(5009,1006,204,1,4599.00,5),(5010,1007,206,1,1299.00,0),
(5011,1008,207,1,899.00,0),(5012,1009,205,1,3499.00,0),
(5013,1009,208,2,599.00,15),(5014,1010,206,1,1299.00,0),
(5015,1010,208,1,599.00,0);
```

---

### Step 7 — Verify Data Loaded

```sql
SELECT COUNT(*) FROM customers;    -- Expected: 8
SELECT COUNT(*) FROM products;     -- Expected: 8
SELECT COUNT(*) FROM orders;       -- Expected: 10
SELECT COUNT(*) FROM order_items;  -- Expected: 15
```

---

## 📝 Solutions

### Section A — SQL Basics

```sql
-- Q1: All customers
SELECT * FROM customers;

-- Q2: Name and city only
SELECT first_name, last_name, city FROM customers;

-- Q3: Unique product categories
SELECT DISTINCT category FROM products;

-- Q6: Demonstrate CHECK constraint violation
INSERT INTO products VALUES (209, 'Broken Item', 'Electronics', 'TestBrand', -50.00, 10);
-- Error: CHECK constraint failed (unit_price > 0)
```

### Section B — Filtering & Indexes

```sql
-- Q7: All delivered orders
SELECT * FROM orders WHERE status = 'Delivered';

-- Q8: Electronics above ₹2000
SELECT * FROM products
WHERE category = 'Electronics' AND unit_price > 2000;

-- Q9: Maharashtra customers who joined in 2024
SELECT * FROM customers
WHERE state = 'Maharashtra'
  AND join_date >= '2024-01-01'
  AND join_date < '2025-01-01';

-- Q10: Orders Aug 10-25, not cancelled
SELECT * FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
  AND status != 'Cancelled';

-- Q12: SARGable rewrite (index-friendly)
-- BAD:  WHERE YEAR(join_date) = 2024
-- GOOD:
SELECT * FROM customers
WHERE join_date >= '2024-01-01' AND join_date < '2025-01-01';
```

### Section C — Aggregation

```sql
-- Q13: Total orders
SELECT COUNT(*) AS total_orders FROM orders;

-- Q14: Revenue from delivered orders
SELECT SUM(total_amount) AS total_revenue
FROM orders WHERE status = 'Delivered';

-- Q15: Average price per category
SELECT category, ROUND(AVG(unit_price), 2) AS avg_price
FROM products GROUP BY category;

-- Q16: Order count and revenue by status
SELECT status, COUNT(*) AS order_count, SUM(total_amount) AS total_revenue
FROM orders GROUP BY status ORDER BY total_revenue DESC;

-- Q17: Most expensive and cheapest per category
SELECT category, MAX(unit_price) AS most_expensive, MIN(unit_price) AS cheapest
FROM products GROUP BY category;

-- Q18: Categories with avg price > ₹2000
SELECT category, ROUND(AVG(unit_price), 2) AS avg_price
FROM products GROUP BY category HAVING AVG(unit_price) > 2000;
```

### Section D — Joins

```sql
-- Q19: INNER JOIN orders with customer names
SELECT o.order_id, o.order_date, c.first_name, c.last_name, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Q20: LEFT JOIN — all customers, orders optional
SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Q21: Three-table JOIN
SELECT oi.order_id, p.product_name, oi.quantity, oi.unit_price, oi.discount_pct
FROM order_items oi
INNER JOIN orders   o ON oi.order_id   = o.order_id
INNER JOIN products p ON oi.product_id = p.product_id;
```

### Section E — Advanced

```sql
-- Q24: Price tier using CASE
SELECT product_name, unit_price,
  CASE
    WHEN unit_price < 1000               THEN 'Budget'
    WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
    ELSE                                      'Premium'
  END AS price_tier
FROM products ORDER BY unit_price;

-- Q25: Delivered vs Not Delivered count
SELECT
  SUM(CASE WHEN status = 'Delivered'  THEN 1 ELSE 0 END) AS delivered_count,
  SUM(CASE WHEN status != 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_count
FROM orders;

-- Q27: Full transaction — insert order + items + update stock
START TRANSACTION;
  INSERT INTO orders VALUES (1011, 102, CURDATE(), 'Pending', 1598.00);
  INSERT INTO order_items VALUES
    (5016, 1011, 206, 1, 1299.00, 0),
    (5017, 1011, 208, 1,  599.00, 0);
  UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 206;
  UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 208;
COMMIT;
-- Run ROLLBACK; instead if any step fails
```

---

## 🗂️ Schema Overview

```
customers
  └── customer_id (PK), first_name, last_name, email (UNIQUE), city, state, join_date, is_premium

products
  └── product_id (PK), product_name, category, brand, unit_price (CHECK > 0), stock_qty

orders
  └── order_id (PK), customer_id (FK → customers), order_date, status (CHECK), total_amount

order_items
  └── item_id (PK), order_id (FK → orders), product_id (FK → products),
      quantity, unit_price, discount_pct
```

---

## 🔑 Key Concepts Covered

| Concept | Where Used |
|--------|-----------|
| Primary Key | All 4 tables |
| Foreign Key | orders, order_items |
| CHECK Constraint | unit_price, stock_qty, status, discount_pct |
| UNIQUE Constraint | customers.email |
| Indexes | city, state, category, order_date, status |
| WHERE / AND / BETWEEN | Section B |
| GROUP BY / HAVING | Section C |
| INNER / LEFT JOIN | Section D |
| CASE Statement | Section E |
| ACID / Transactions | Section E |

---

## ⚠️ Common Errors & Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `No database selected` | Forgot USE statement | Run `USE shopease;` first |
| `Foreign key constraint fails` | Inserting child before parent | Insert in order: customers → products → orders → order_items |
| `CHECK constraint failed` | Negative price or invalid status | Ensure `unit_price > 0` and status is one of the allowed values |
| `Duplicate entry for key 'PRIMARY'` | Inserting existing ID again | Drop and recreate table, or use different IDs |
| `Can't connect to MySQL server` | MySQL service not running | Open Windows Services → Start **MySQL80** |

---

## 👨‍💻 Author

**Celebal Technologies Internship — SQL Week 2 Task 2**  
Tools: MySQL 8.0 · MySQL Workbench