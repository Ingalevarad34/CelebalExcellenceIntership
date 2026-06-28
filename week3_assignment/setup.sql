-- ------------------------------------------------------
-- Week 3 Setup File
-- Dataset: Superstore_clean.csv
-- ------------------------------------------------------

-- Create database
-- Meaning: database for assignment
CREATE DATABASE superstore_db;
USE superstore_db;

-- Create staging table
-- Meaning: Raw data import table
CREATE TABLE superstore_raw (
    Row_ID INT,
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(20),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(200),
    Sales DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(10,2)
);

-- Create customers table
-- Meaning: Store customer details
CREATE TABLE customers AS
SELECT DISTINCT Customer_ID, Customer_Name, Segment, Country, City, State, Postal_Code, Region
FROM superstore_raw;

-- Create orders table
-- Meaning: Store order details
CREATE TABLE orders AS
SELECT DISTINCT Order_ID, Order_Date, Ship_Date, Ship_Mode, Customer_ID, Sales, Quantity, Discount, Profit
FROM superstore_raw;

-- Create products table
-- Meaning: Store product details
CREATE TABLE products AS
SELECT DISTINCT Product_ID, Category, Sub_Category, Product_Name
FROM superstore_raw;

-- ------------------------------------------------------
-- ------------------------------------------------------
