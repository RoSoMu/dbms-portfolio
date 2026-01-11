-- Sample data for Reto 2 and Reto 3

-- Categories
INSERT INTO categories (name) VALUES
('Books'),
('Electronics'),
('Clothing');

-- Products
INSERT INTO products (name, description, price, stock, category_id) VALUES
('SQL Fundamentals Book', 'Introductory SQL book', 29.99, 50, 1),
('Wireless Mouse', 'Ergonomic wireless mouse', 19.99, 100, 2),
('T-Shirt', 'Cotton t-shirt', 14.99, 200, 3);

-- Clients
INSERT INTO clients (first_name, last_name, email) VALUES
('Ana', 'García', 'ana.garcia@example.com'),
('Luis', 'Pérez', 'luis.perez@example.com');

-- Orders
INSERT INTO orders (client_id, status) VALUES
(1, 'completed'),
(2, 'completed');

-- Order details
INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 29.99),
(1, 2, 2, 19.99),
(2, 3, 3, 14.99);

