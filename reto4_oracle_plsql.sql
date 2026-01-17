-- ============================================================
-- Reto 4 – Oracle SQL & PL/SQL
-- Database Management Systems course
--
-- Description:
--   Oracle implementation of an online shop database
--   with PL/SQL procedures for querying, updating, and deleting data.
--
-- Features:
--   - Relational schema (clients, products, orders, order_details)
--   - Sequences for primary key generation
--   - Sample data insertion
--   - Verification queries
--   - PL/SQL procedures:
--       * search_orders
--       * update_client_address
--       * update_order_total
--       * delete_client_safely
--
-- Environment:
--   - Oracle Database XE (Docker)
--   - SQL Developer
--
-- Author:
--   Soraya Rodríguez
--   (with guided mentoring support)
--
-- Notes:
--   - Script is intended to be run top-to-bottom
--   - DBMS_OUTPUT must be enabled to view procedure output
-- ============================================================

SET SERVEROUTPUT ON;

-- ===============================
-- Clients table
-- ===============================
-- Sequence used to generate primary keys for clients
CREATE SEQUENCE clients_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
    
-- Clients table
-- Stores customer personal and address information
CREATE TABLE clients (
    client_id     NUMBER NOT NULL,
    first_name    VARCHAR2(100) NOT NULL,
    last_name     VARCHAR2(100) NOT NULL,
    email         VARCHAR2(255) NOT NULL,
    address       VARCHAR2(300),
    created_at    DATE DEFAULT SYSDATE NOT NULL,

    CONSTRAINT pk_clients PRIMARY KEY (client_id),
    CONSTRAINT uq_clients_email UNIQUE (email)
);

-- ===============================
-- Sample data for clients
-- ===============================
INSERT INTO clients (client_id, first_name, last_name, email, address)
VALUES (
    clients_seq.NEXTVAL,
    'Ana',
    'García',
    'ana.garcia@example.com',
    'Calle Mayor 12, Madrid'
);

INSERT INTO clients (client_id, first_name, last_name, email, address)
VALUES (
    clients_seq.NEXTVAL,
    'Luis',
    'Rodríguez',
    'luis.rodriguez@example.com',
    'Avenida del Sol 45, Valencia'
);

-- ===============================
-- Products table
-- ===============================
-- Sequence to generate primary keys for products
CREATE SEQUENCE products_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Products table
-- Stores items sold by the online shop (kimonos only)

CREATE TABLE products (
    product_id   NUMBER NOT NULL,
    name         VARCHAR2(150) NOT NULL,
    description  VARCHAR2(500),
    price        NUMBER(10,2) NOT NULL,
    stock        NUMBER NOT NULL,
    created_at   DATE DEFAULT SYSDATE NOT NULL,

    CONSTRAINT pk_products PRIMARY KEY (product_id),
    CONSTRAINT chk_products_price CHECK (price >= 0),
    CONSTRAINT chk_products_stock CHECK (stock >= 0)
);

-- ===============================
-- Sample products
-- ===============================
INSERT INTO products (product_id, name, description, price, stock)
VALUES (
    products_seq.NEXTVAL,
    'Classic White Kimono',
    'Traditional white cotton kimono',
    59.99,
    25
);

INSERT INTO products (product_id, name, description, price, stock)
VALUES (
    products_seq.NEXTVAL,
    'Blue Training Kimono',
    'Durable kimono for martial arts practice',
    74.99,
    15
);

INSERT INTO products (product_id, name, description, price, stock)
VALUES (
    products_seq.NEXTVAL,
    'Children Kimono',
    'Lightweight kimono for school activities',
    39.99,
    30
);

-- ===============================
-- Orders table
-- ===============================
-- Sequence to generate primary keys for orders
CREATE SEQUENCE orders_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Orders table
-- Stores customer orders
CREATE TABLE orders (
    order_id    NUMBER NOT NULL,
    client_id   NUMBER NOT NULL,
    order_date  DATE DEFAULT SYSDATE NOT NULL,
    status      VARCHAR2(50) NOT NULL,
    created_at  DATE DEFAULT SYSDATE NOT NULL,

    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_client
        FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
);

-- ===============================
-- Sample orders
-- ===============================
INSERT INTO orders (order_id, client_id, status)
VALUES (
    orders_seq.NEXTVAL,
    1,
    'COMPLETED'
);

INSERT INTO orders (order_id, client_id, status)
VALUES (
    orders_seq.NEXTVAL,
    2,
    'COMPLETED'
);

-- ===============================
-- Order details table
-- ===============================
-- Sequence to generate primary keys for order details
CREATE SEQUENCE order_details_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

-- Order details table
-- Stores individual products within each order
CREATE TABLE order_details (
    order_detail_id NUMBER NOT NULL,
    order_id        NUMBER NOT NULL,
    product_id      NUMBER NOT NULL,
    quantity        NUMBER NOT NULL,
    unit_price      NUMBER(10,2) NOT NULL,

    CONSTRAINT pk_order_details PRIMARY KEY (order_detail_id),
    CONSTRAINT fk_od_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_od_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),
    CONSTRAINT chk_od_quantity CHECK (quantity > 0),
    CONSTRAINT chk_od_unit_price CHECK (unit_price >= 0)
);

-- ===============================
-- Sample order details
-- ===============================
INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unit_price)
VALUES (
    order_details_seq.NEXTVAL,
    1,
    1,
    1,
    59.99
);

INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unit_price)
VALUES (
    order_details_seq.NEXTVAL,
    1,
    2,
    2,
    74.99
);

INSERT INTO order_details (order_detail_id, order_id, product_id, quantity, unit_price)
VALUES (
    order_details_seq.NEXTVAL,
    2,
    3,
    3,
    39.99
);

-- ===============================
-- Verification queries (manual check)
-- ===============================

SELECT * FROM clients;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_details;

-- ===============================
-- Procedure: search_orders
-- Searches orders by client name and/or date range
-- ===============================
CREATE OR REPLACE PROCEDURE search_orders (
    p_client_name IN VARCHAR2 DEFAULT NULL,
    p_start_date  IN DATE DEFAULT NULL,
    p_end_date    IN DATE DEFAULT NULL
) IS
BEGIN
    FOR rec IN (
        SELECT
            o.order_id,
            c.first_name || ' ' || c.last_name AS client_name,
            o.order_date,
            o.status
        FROM orders o
        JOIN clients c
            ON o.client_id = c.client_id
        WHERE
            (p_client_name IS NULL
             OR LOWER(c.first_name || ' ' || c.last_name)
                LIKE '%' || LOWER(p_client_name) || '%')
        AND
            (p_start_date IS NULL OR o.order_date >= p_start_date)
        AND
            (p_end_date IS NULL OR o.order_date <= p_end_date)
        ORDER BY o.order_date
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Order ' || rec.order_id ||
            ' | Client: ' || rec.client_name ||
            ' | Date: ' || TO_CHAR(rec.order_date, 'YYYY-MM-DD') ||
            ' | Status: ' || rec.status
        );
    END LOOP;
END;
/

-- ============================================================
-- Procedure tests: search_orders
-- ============================================================
-- Purpose:
--   Validate the behavior of the search_orders procedure
--   using different combinations of input parameters.
--
-- Notes:
--   - NULL parameters act as wildcards
--   - Output is printed using DBMS_OUTPUT
-- ============================================================
-- Test 1:
-- No filters applied (all parameters NULL)
-- Expected:
--   Returns all orders in the system
BEGIN
    search_orders;
END;
/

-- Test 2:
-- Search orders by partial client name
-- Expected:
--   Returns all orders placed by clients whose full name
--   contains 'ana' (case-insensitive)
BEGIN
    search_orders(p_client_name => 'Ana');
END;
/

-- Test 3:
-- Search orders within a date range
-- Expected:
--   Returns orders with order_date between 2024-01-01
--   and 2024-12-31
BEGIN
    search_orders(
        p_start_date => DATE '2026-01-01',
        p_end_date   => DATE '2026-12-31'
    );
END;
/

-- ============================================================
-- End of procedure tests: search_orders
-- ============================================================

-- ============================================================
-- Procedure: update_client_address
-- Purpose:
--   Update the address of an existing client
-- ============================================================

CREATE OR REPLACE PROCEDURE update_client_address (
    p_client_id   IN clients.client_id%TYPE,
    p_new_address IN clients.address%TYPE
) IS
    v_rows_updated NUMBER;
BEGIN
    UPDATE clients
    SET address = p_new_address
    WHERE client_id = p_client_id;

    v_rows_updated := SQL%ROWCOUNT;

    IF v_rows_updated = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'No client found with ID ' || p_client_id
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'Address updated successfully for client ID ' || p_client_id
        );
    END IF;

    COMMIT;
END;
/

-- ============================================================
-- Tests: update_client_address
-- ============================================================

-- Test 1:
-- Update address for an existing client
-- Expected:
--   Address updated confirmation message
BEGIN
    update_client_address(
        p_client_id   => 1,
        p_new_address => 'Calle Nueva 45, Madrid'
    );
END;
/

-- Test 2:
-- Attempt update for non-existing client
-- Expected:
--   Informational message indicating no client found
BEGIN
    update_client_address(
        p_client_id   => 999,
        p_new_address => 'Nowhere Street'
    );
END;
/
-- ============================================================
-- End of procedure tests: update_client_address
-- ============================================================

-- ============================================================
-- Procedure: update_order_total
-- Purpose:
--   Recalculate and store the total value of an order
--   based on its order_details
-- ============================================================

-- Add total column
ALTER TABLE orders
ADD total_amount NUMBER(10,2);

CREATE OR REPLACE PROCEDURE update_order_total (
    p_order_id IN orders.order_id%TYPE
) IS
    v_total NUMBER(10,2);
BEGIN
    SELECT NVL(SUM(quantity * unit_price), 0)
    INTO v_total
    FROM order_details
    WHERE order_id = p_order_id;

    UPDATE orders
    SET total_amount = v_total
    WHERE order_id = p_order_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'No order found with ID ' || p_order_id
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE(
            'Order ' || p_order_id ||
            ' total updated to ' || v_total
        );
    END IF;

    COMMIT;
END;
/

-- ============================================================
-- Tests: update_order_total
-- ============================================================

-- Test 1:
-- Update total for an existing order
-- Expected:
--   Correct total printed and stored

BEGIN
    update_order_total(1);
END;
/

-- Test 2:
-- Update total for non-existing order
-- Expected:
--   Informational message, no update

BEGIN
    update_order_total(999);
END;
/
-- ============================================================
-- End of procedure tests: update_order_total
-- ============================================================

-- ============================================================
-- Procedure: delete_client_safely
-- Purpose:
--   Safely delete a client only if no dependent orders exist
-- ============================================================

CREATE OR REPLACE PROCEDURE delete_client_safely (
    p_client_id IN clients.client_id%TYPE
) IS
    v_client_exists NUMBER;
    v_order_count   NUMBER;
BEGIN
    -- Check if client exists
    SELECT COUNT(*)
    INTO v_client_exists
    FROM clients
    WHERE client_id = p_client_id;

    IF v_client_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'No client found with ID ' || p_client_id
        );
        RETURN;
    END IF;

    -- Check for dependent orders
    SELECT COUNT(*)
    INTO v_order_count
    FROM orders
    WHERE client_id = p_client_id;

    IF v_order_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            'Client ID ' || p_client_id ||
            ' cannot be deleted: existing orders found'
        );
        RETURN;
    END IF;

    -- Safe to delete
    DELETE FROM clients
    WHERE client_id = p_client_id;

    DBMS_OUTPUT.PUT_LINE(
        'Client ID ' || p_client_id || ' deleted successfully'
    );

    COMMIT;
END;
/

-- ============================================================
-- Tests: delete_client_safely
-- ============================================================

-- Test 1:
-- Clients with orders should fail
-- Expected output: Client ID 1 cannot be deleted: existing orders found
BEGIN
    delete_client_safely(1);
END;
/

-- Test 2:
-- Non-existing client
-- Expected output: No client found with ID 999
BEGIN
    delete_client_safely(999);
END;
/

-- Test 3:
-- client without orders -insert client with no order first
-- Expected output: Client ID 3 deleted successfully
INSERT INTO clients (client_id, first_name, last_name, email, address)
VALUES (
    clients_seq.NEXTVAL,
    'Test',
    'Client',
    'test.client@example.com',
    'Test Street'
);
COMMIT;

BEGIN
    delete_client_safely(3);
END;
/

-- ============================================================
-- End of procedure tests: delete_client_safely
-- ============================================================

