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
