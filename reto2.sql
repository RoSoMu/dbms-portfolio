-- Reto 2 - Analytical Queries
-- Using CTEs for clarity and readability
USE online_shop_db;

-- Query 1: Total sales by product category
WITH category_sales AS (
    SELECT
        c.name AS category,
        SUM(od.quantity * od.unit_price) AS total_sales
    FROM categories c
    JOIN products p
        ON p.category_id = c.category_id
    JOIN order_details od
        ON od.product_id = p.product_id
    GROUP BY c.name
)
SELECT * FROM category_sales;

-- Query 2: Average amount spent per client
WITH order_totals AS (
    SELECT
        o.order_id,
        o.client_id,
        SUM(od.quantity * od.unit_price) AS order_total
    FROM orders o
    JOIN order_details od
        ON od.order_id = o.order_id
    GROUP BY o.order_id, o.client_id
)
SELECT
    c.client_id,
    CONCAT(c.first_name, ' ', c.last_name) AS client,
    AVG(ot.order_total) AS average_spent
FROM order_totals ot
JOIN clients c
    ON c.client_id = ot.client_id
GROUP BY c.client_id, client;

-- Query 3: Most sold products by quantity

SELECT
    p.product_id,
    p.name AS product,
    SUM(od.quantity) AS total_units_sold
FROM products p
JOIN order_details od
    ON od.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY total_units_sold DESC;

