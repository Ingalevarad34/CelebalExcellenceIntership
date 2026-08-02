# E-Commerce Order Analytics System

# Overview

This project is a mini Data Engineering application that demonstrates an end-to-end data processing workflow using Python, Pandas, and SQLite. The system loads raw e-commerce datasets, performs data cleaning and validation, stores the cleaned data in a relational database, and generates analytical reports.

---

# Objectives

* Load multiple CSV datasets.
* Perform data cleaning and validation.
* Check referential integrity across tables.
* Generate a data cleaning report.
* Store cleaned data in a SQLite database.
* Execute SQL queries for business insights.


# Technologies Used

* Python 3.x
* Pandas
* SQLite
* pathlib
* Jupyter Notebook


# Project Structure


Week8_Mini Project- E-Commerce Order Analytics System/
│
├── data/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   └── order_items.csv
│
├── cleaned data/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   ├── order_items.csv
│   └── cleaning_report.txt
│
├── ecommerce.db
├── Week8_Mini_Project.ipynb
└── README.md
```



# Workflow

# 1. Data Loading

* Read all CSV files using Pandas.
* Validate dataset availability.

# 2. Data Cleaning

* Remove duplicate records.
* Handle missing values.
* Validate email addresses.
* Convert data types.
* Validate date formats.
* Check invalid quantities and prices.
* Verify referential integrity between tables.

# 3. Report Generation

Generate a data cleaning report containing:

* Duplicate records removed
* Invalid email count
* Invalid data count
* Referential integrity issues

# 4. Export Cleaned Data

Save cleaned datasets into the **cleaned data** folder.

# 5. Database Creation

Create a SQLite database with the following tables:

* customers
* products
* orders
* order_items

Indexes are created to improve query performance.

# 6. SQL Analysis

Perform business analysis including:

* Total orders
* Total revenue
* Revenue by category
* Top-selling products
* Top customers
* Monthly sales trends
* Region-wise sales

---

# Output Files

* ecommerce.db
* cleaned data/customers.csv
* cleaned data/products.csv
* cleaned data/orders.csv
* cleaned data/order_items.csv
* cleaned data/cleaning_report.txt



# How to Run

1. Install Python 3.x.
2. Install the required libraries:

```bash
pip install pandas


3. Place all CSV files inside the **data** folder.

4. Open the notebook in Jupyter Notebook.

5. Run all notebook cells in order.

6. Verify that:

   * Cleaned CSV files are generated.
   * `cleaning_report.txt` is created.
   * `ecommerce.db` is created successfully.


# Key Features

* Data validation
* Data cleaning
* Email validation
* Referential integrity checks
* SQLite database creation
* SQL analytics
* Report generation


# Learning Outcomes

Through this project, the following concepts were implemented:

* Data preprocessing
* Data quality validation
* File handling
* SQLite database management
* SQL table creation
* Foreign key relationships
* Index creation
* Data analytics using SQL
* End-to-end ETL workflow



