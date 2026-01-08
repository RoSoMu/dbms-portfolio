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
