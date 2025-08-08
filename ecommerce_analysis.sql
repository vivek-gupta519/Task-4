-- ========================================
-- BASIC SELECT, WHERE, ORDER BY
-- ========================================

-- 1. List all customers from the USA, sorted by last name
SELECT customer_id, first_name, last_name, country
FROM customers
WHERE country = 'USA'
ORDER BY last_name ASC;


-- ========================================
-- JOINS: INNER JOIN, LEFT JOIN, RIGHT JOIN
-- ========================================

-- 2. INNER JOIN: Get all orders and customer names
SELECT o.order_id, c.first_name, c.last_name, o.order_date
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- 3. LEFT JOIN: Show all customers and any orders (if present)
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 4. RIGHT JOIN: Show all orders and customer info (MySQL/PostgreSQL only)
-- Skip if using SQLite (does not support RIGHT JOIN)
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;


-- ========================================
-- AGGREGATE FUNCTIONS
-- ========================================

-- 5. Total revenue from all orders
SELECT SUM(quantity * unit_price) AS total_revenue
FROM order_items;

-- 6. Average order value
SELECT AVG(order_total) AS avg_order_value
FROM (
    SELECT order_id, SUM(quantity * unit_price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals;


-- ========================================
-- GROUP BY
-- ========================================

-- 7. Total spending per customer
SELECT c.customer_id, c.first_name, c.last_name, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;


-- ========================================
-- SUBQUERIES
-- ========================================

-- 8. Customers who placed more than 1 order (for small dataset demo)
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
);


-- ========================================
-- VIEWS
-- ========================================

-- 9. Create a view of frequent customers (more than 1 order)
CREATE VIEW frequent_customers AS
SELECT customer_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1;

-- 10. Select from the view
SELECT * FROM frequent_customers;


-- ========================================
-- INDEXES (for optimization)
-- ========================================

-- 11. Index on order_id in order_items
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- 12. Index on customer_id in orders
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- 13. Index on category_id in products
CREATE INDEX idx_products_category_id ON products(category_id);
