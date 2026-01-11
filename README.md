# DBMS Portfolio – Online Shop Database

## Overview

This repository contains a small but complete **Database Management Systems (DBMS)** portfolio built around an **online sho**p use case.

The work is structured as three incremental challenges (Retos), progressing from:
- relational schema design,
- to analytical SQL queries,
- to cross-database portability and procedural SQL.

The same conceptual data model is implemented using **MySQL** and **SQL Server**, highlighting both similarities and engine-specific differences.

## Database Model

The core domain models an online shop with the following entities:
- **clients** – customers placing orders
- **products** – items for sale
- **categories** – product classification
- **orders** – customer purchases
- **order_details** – line items linking orders and products

Relationships are enforced using **primary keys, foreign keys, and constraints**, and visualized via ER diagrams.

## Repository Structure

```text
dbms-portfolio/
│
├── schema.sql
│   MySQL schema definition (Reto 1)
│
├── data.sql
│   Sample data for MySQL (Reto 2)
│
├── reto2.sql
│   Analytical queries in MySQL (Reto 2)
│
├── reto3_sqlserver.sql
│   Full SQL Server (T-SQL) implementation:
│   schema, queries, and procedural logic (Reto 3)
│
├── er_diagram_online_shop.png
│   ER diagram for the initial schema
│
├── er_diagram_online_shop_reto2.png
│   Updated ER diagram including categories
│
├── .gitignore
│   Git ignore rules (macOS artifacts, etc.)
│
└── README.md
```

## Reto Breakdown

**Reto 1 – Relational Schema (MySQL)**
- Database and table creation
- Primary keys, foreign keys, and constraints
- InnoDB engine usage
- ER diagram export

**Reto 2 – Queries and Data (MySQL**)
- Sample data insertion
- Analytical queries using JOIN, GROUP BY, and CTEs:
	- total sales by category
 	- average spending per client
  	- most sold products
- Updated ER diagram reflecting schema evolution

**Reto 3 – SQL Server (T-SQL**)
- Full schema rewritten for SQL Server:
	- IDENTITY(1,1)
 	- DATETIME2
  	- strict GROUP BY semantics
- Queries rewritten in T-SQL
- Procedural SQL example using:
	- variables
 	- WHILE loop
  	- PRINT
- Focus on engine-aware, portable SQL design

## Technologies Used

- **MySQL 8.x**
- **SQL Server (T-SQL syntax)**
- **MySQL Workbench** (ER diagrams)
- **Git & GitHub** (version control)
  
## Notes
- MySQL and SQL Server scripts are intentionally kept separate.
- SQL Server scripts are not meant to be executed in MySQL.
- Emphasis is placed on **clarity, correctness, and portability**, not optimization.

## Author

**Soraya Rodríguez**

---

## Acknowledgements

This project was developed with the assistance of an AI-based instructor
(ChatGPT), which provided guidance, explanations, and code reviews throughout
the learning process.

All design decisions, implementation, and final results reflect the author's
understanding and work.
