-- Reto 3 - SQL Server (T-SQL)
-- Database Management Systems course
-- Engine: Microsoft SQL Server
-- Note: This script is NOT intended for MySQL-- Reto 3 - SQL Server (T-SQL)

-- ======================
-- clients table
-- ======================
CREATE TABLE clients (
    client_id INT IDENTITY(1,1),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT pk_clients PRIMARY KEY (client_id),
    CONSTRAINT uq_clients_email UNIQUE (email)
);

-- insert values
INSERT INTO clients (first_name, last_name, email)
VALUES ('Ana', 'García', 'ana.garcia@example.com');

-- ======================
-- products table
-- ======================
CREATE TABLE products (
    product_id INT IDENTITY(1,1),
    name VARCHAR(150) NOT NULL,
    description VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT pk_products PRIMARY KEY (product_id),
    CONSTRAINT chk_products_price CHECK (price >= 0),
    CONSTRAINT chk_products_stock CHECK (stock >= 0)
);

-- Sample products
INSERT INTO products (name, description, price, stock)
VALUES
('SQL Fundamentals Book', 'Introductory SQL book', 29.99, 50),
('Wireless Mouse', 'Ergonomic wireless mouse', 19.99, 100),
('T-Shirt', 'Cotton t-shirt', 14.99, 200);

-- ======================
-- categories table
-- ======================
CREATE TABLE categories (
    category_id INT IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_categories PRIMARY KEY (category_id),
    CONSTRAINT uq_categories_name UNIQUE (name)
);

-- ======================
-- products → categories relationship
-- ======================
ALTER TABLE products
ADD category_id INT;

ALTER TABLE products
ADD CONSTRAINT fk_products_category
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id);

-- Sample categories
INSERT INTO categories (name)
VALUES
('Books'),
('Electronics'),
('Clothing');

-- ======================
-- orders table
-- ======================
CREATE TABLE orders (
    order_id INT IDENTITY(1,1),
    client_id INT NOT NULL,
    order_date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    status VARCHAR(50) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
);

-- Sample orders
INSERT INTO orders (client_id, status)
VALUES
(1, 'completed'),
(2, 'completed');

-- ======================
-- order_details table
-- ======================
CREATE TABLE order_details (
    order_detail_id INT IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_order_details PRIMARY KEY (order_detail_id),
    CONSTRAINT fk_order_details_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_order_details_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    CONSTRAINT chk_order_details_quantity CHECK (quantity > 0),
    CONSTRAINT chk_order_details_unit_price CHECK (unit_price >= 0)
);

-- Sample order details
INSERT INTO order_details (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 29.99),
(1, 2, 2, 19.99),
(2, 3, 3, 14.99);

-- ======================
-- Reto 3 - Query 1
-- Total sales by product category
-- ======================

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
SELECT
    category,
    total_sales
FROM category_sales;

-- ======================
-- Reto 3 - Query 2
-- Average amount spent per client
-- ======================

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
    c.first_name + ' ' + c.last_name AS client,
    AVG(ot.order_total) AS average_spent
FROM order_totals ot
JOIN clients c
    ON c.client_id = ot.client_id
GROUP BY
    c.client_id,
    c.first_name,
    c.last_name;

-- ======================
-- Reto 3 - Query 3
-- Most sold products by quantity
-- ======================

SELECT
    p.product_id,
    p.name AS product,
    SUM(od.quantity) AS total_units_sold
FROM products p
JOIN order_details od
    ON od.product_id = p.product_id
GROUP BY
    p.product_id,
    p.name
ORDER BY
    total_units_sold DESC;

-- ======================
-- Reto 3 - T-SQL Procedural Element
-- Example: Calculate and print total value per order
-- Loop through all order IDs and calculate totals procedurally
-- ======================

DECLARE @current_order_id INT;
DECLARE @max_order_id INT;
DECLARE @order_total DECIMAL(10,2);

-- Get the maximum order_id
SELECT @max_order_id = MAX(order_id)
FROM orders;

-- Start with the first order
SET @current_order_id = 1;

WHILE @current_order_id <= @max_order_id
BEGIN
    -- Calculate total for the current order
    SELECT @order_total = SUM(quantity * unit_price)
    FROM order_details
    WHERE order_id = @current_order_id;

    -- Print the result
    PRINT 'Order ID ' + CAST(@current_order_id AS VARCHAR)
          + ' total value: '
          + CAST(ISNULL(@order_total, 0) AS VARCHAR);

    -- Move to next order
    SET @current_order_id = @current_order_id + 1;
END;


