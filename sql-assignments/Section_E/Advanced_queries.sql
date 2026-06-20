-- Section E — Advanced Concepts (CASE, ACID, Transactions)

/*Q24. Write a query using CASE to classify products into price tiers:
  • 'Budget'    → unit_price < 1000
  • 'Mid-Range' → unit_price BETWEEN 1000 AND 3000
  • 'Premium'   → unit_price > 3000
Display: product_name, unit_price, price_tier.*/

SELECT product_name,
       unit_price,
       CASE
         WHEN unit_price < 1000              THEN 'Budget'
         WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
         ELSE                                     'Premium'
       END AS price_tier
FROM products
ORDER BY unit_price;

-- Q25. Using a CASE statement inside an aggregate function, count how many orders are 'Delivered' vs 'Not Delivered' (all other statuses). Display the result in a single row.

SELECT
  SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
  SUM(CASE WHEN status != 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_count
FROM orders;



/*Q26. Explain each letter of ACID:
  • A – Atomicity
  • C – Consistency
  • I – Isolation
  • D – Durability
Give a real-world example (e.g., bank transfer) showing why each property is important.*/

-- ANSWER
/* A — Atomicity: All steps in a transaction succeed together, or none at all.
 In a bank transfer, if the debit succeeds but the credit fails, the whole transaction rolls back — money is never lost.

C — Consistency: The database moves from one valid state to another. 
Constraints (NOT NULL, FK, CHECK) are always satisfied after the transaction — a transfer can't create money out of thin air.

I — Isolation: Concurrent transactions don't interfere. 
If two people transfer money at the same moment, each transaction sees a consistent snapshot — no dirty reads.

D — Durability: Once committed, the data survives crashes. 
Even if the server loses power right after COMMIT, the bank transfer is permanently recorded.*/

/*Q27. Write a SQL transaction that does the following atomically:
  1. Insert a new order (order_id=1011, customer_id=102, today's date, 'Pending', 1598.00)
  2. Insert two order items for that order
  3. Update the stock_qty of the purchased products
  4. If any step fails, ROLLBACK the entire transaction. Otherwise, COMMIT.
Write the complete BEGIN...COMMIT/ROLLBACK block.*/

START TRANSACTION;

-- Step 1: Insert the new order
INSERT INTO orders VALUES
(1011, 102, CURDATE(), 'Pending', 1598.00);

-- Step 2: Insert two order items for order 1011
INSERT INTO order_items VALUES
(5016, 1011, 206, 1, 1299.00, 0),
(5017, 1011, 208, 1, 599.00,  0);

-- Step 3: Reduce stock for the purchased products
UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 206;

UPDATE products
SET stock_qty = stock_qty - 1
WHERE product_id = 208;

-- Step 4: Commit if all steps succeeded
COMMIT;

-- If any step above fails, run this instead:
-- ROLLBACK;
