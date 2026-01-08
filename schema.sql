-- Reto 1: Online shop database schema
-- Database Management Systems course
-- Author: Soraya Rodriguez

CREATE DATABASE IF NOT EXISTS online_shop_db;
USE online_shop_db;

-- ======================
-- clients table
-- ======================
CREATE TABLE IF NOT EXISTS clients (
    client_id INT AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_clients PRIMARY KEY (client_id),
    CONSTRAINT uq_clients_email UNIQUE (email)
) ENGINE=InnoDB;
-- ======================
-- products table
-- ======================
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_products PRIMARY KEY (product_id),
    CONSTRAINT chk_products_price CHECK (price >= 0),
    CONSTRAINT chk_products_stock CHECK (stock >= 0)
) ENGINE=InnoDB;
-- ======================
-- orders table
-- ======================
CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT,
    client_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
) ENGINE=InnoDB;
-- ======================
-- order_details table
-- ======================
CREATE TABLE IF NOT EXISTS order_details (
    order_detail_id INT AUTO_INCREMENT,
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
) ENGINE=InnoDB;
