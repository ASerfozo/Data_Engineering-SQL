-- --------------------------
/* 	Attila Serfozo - Business Analytics 2020/2021
	TERM PROJECT - Data Engineering 1
	Date: 2020.11.18. 
    Dataset: Transactions of Food Mart between 1997-1998*/
-- --------------------------

-- --------------------------
-- IMPORTING DATASET - OPERATIONAL LAYER
-- --------------------------

DROP SCHEMA IF EXISTS food_mart;
CREATE SCHEMA food_mart;

USE food_mart;

-- --------------------------
-- Create transactions table
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions
(transaction_date DATE NOT NULL,
stock_date DATE NOT NULL,
product_id INTEGER NOT NULL,
customer_id INTEGER NOT NULL,
store_id INTEGER NOT NULL,
quantity INTEGER NOT NULL);

-- Load CSV data into transactions table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/FoodMart_Transactions_1997-1998.csv' 
INTO TABLE transactions 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(transaction_date, stock_date, product_id, customer_id, store_id, quantity);

-- --------------------------
-- Create customers table
DROP TABLE IF EXISTS customers;
CREATE TABLE customers
(customer_id INTEGER NOT NULL, 
customer_city VARCHAR (50),
customer_state_province VARCHAR (50),
customer_country VARCHAR (50),
birthdate DATE NOT NULL,
marital_status VARCHAR (1),
yearly_income VARCHAR (15),
gender VARCHAR (1),
num_children_at_home INTEGER NOT NULL,
education VARCHAR (50),
acct_open_date DATE NOT NULL,
member_card VARCHAR (50),
PRIMARY KEY(customer_id));

-- Load CSV data into customers table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer_Lookup.csv' 
INTO TABLE customers 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(customer_id, customer_city, customer_state_province, customer_country, birthdate, marital_status, 
yearly_income, gender, num_children_at_home, education, acct_open_date, member_card);

-- --------------------------
-- Create products table
DROP TABLE IF EXISTS products;
CREATE TABLE products
(product_id INTEGER NOT NULL, 
product_brand VARCHAR (50),
product_name VARCHAR (50),
product_sku VARCHAR (11),
product_retail_price DECIMAL (10,2),
product_cost DECIMAL (10,2),
product_weight DECIMAL (10,2),
recyclable VARCHAR (3),
low_fat VARCHAR (3),
PRIMARY KEY(product_id));

-- Load CSV data into products table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Product_Lookup.csv' 
INTO TABLE products 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(product_id, product_brand, product_name, product_sku, product_retail_price, product_cost, product_weight, recyclable, low_fat );

-- --------------------------
-- Create stores table
DROP TABLE IF EXISTS stores;
CREATE TABLE stores
(store_id INTEGER NOT NULL, 
region_id INTEGER NOT NULL,
store_type VARCHAR (50),
store_name VARCHAR (50),
store_street_address VARCHAR (50),
store_city VARCHAR (50),
store_state VARCHAR (50),
store_country VARCHAR (50),
store_phone VARCHAR (50),
first_opened_date DATE NOT NULL,
last_remodel_date DATE NOT NULL,
total_sqft INTEGER NOT NULL,
grocery_sqft INTEGER NOT NULL,
PRIMARY KEY(store_id));

-- Load CSV data into stores table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Store_Lookup.csv' 
INTO TABLE stores 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(store_id, region_id, store_type, store_name, store_street_address, store_city, store_state, 
store_country, store_phone, first_opened_date, last_remodel_date, total_sqft, grocery_sqft );

-- --------------------------
-- Create region table
DROP TABLE IF EXISTS region;
CREATE TABLE region
(region_id INTEGER NOT NULL,
sales_district VARCHAR (50),
sales_region VARCHAR (50),
PRIMARY KEY(region_id));

-- Load CSV data into region table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Region_Lookup.csv' 
INTO TABLE region 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(region_id, sales_district, sales_region );


-- --------------------------------
-- ANALYTICS PLAN
-- --------------------------------

/*
There are plenty of analytics that could be done in this database, I would like to list a couple as an example.
Business decision analytics can be conducted to help creating partnership with brands, financials can be checked to 
see the profitability of products and stores:
- Most sold products of the chain (Top 10 by quantity).
- Most sold brands (Top 10 by revenue).
- Most profitable products in total (Top 5).
- Revenue and Profit grouped by stores.
- Profit per stores sqft.
- Compare number of customers and quality of store (last refurbished) to see a possible connection.

Customer Analytics maybefor Marketing purposes
- Largest Transaction (by revenue - Group by date).
- Compare AVG spending of customers with member card and without member card.
- Compare AVG spending of customers born before 1960 and after 1960 (40 years old) .
- Create a category variable based on their gender and children (Women, Parent_Mom, Parent_Father, Men) to see the composition of customers.

For the tasks further I would like to choose the:
- Profit per stores sqft,
- Compare number of customers and quality of store (last refurbished) to see a possible connection,
to create an Analytics layer and Data mart to answere these questions.
*/    

-- --------------------------------
-- ANALYTICAL LAYER
-- --------------------------------

DROP PROCEDURE IF EXISTS ProductSales;

DELIMITER //
CREATE PROCEDURE ProductSales()
BEGIN

	DROP TABLE IF EXISTS product_sales;
	CREATE TABLE product_sales AS
    
	SELECT 
	   products.product_retail_price AS Price,
       transactions.quantity AS Quantity,
       products.product_cost AS Cost,
       stores.store_city AS City,
       stores.store_name AS Store_Name,
       stores.store_type AS Store_Type,
       stores.total_sqft AS Size,
       stores.last_remodel_date AS Last_Renewed,
       customers.customer_id AS customer_id,
       transaction_date AS Date
       
    FROM
		transactions
	INNER JOIN
		stores USING (store_id)
	INNER JOIN
		products USING (product_id)
	INNER JOIN
		customers USING (customer_id)
	INNER JOIN
		region USING (region_id);
END //
DELIMITER ;

CALL ProductSales();

       
-- --------------------------------
-- ETL PIPELINE
-- --------------------------------

-- create log table
CREATE TABLE IF NOT EXISTS messages (message varchar(100) NOT NULL);
-- empty log table
TRUNCATE messages;
    
-- ETL Trigger
DROP TRIGGER IF EXISTS after_transaction_insert; 

DELIMITER //

CREATE TRIGGER after_transaction_insert
AFTER INSERT
ON transactions FOR EACH ROW
BEGIN
   
	-- log the order number of the newley inserted transaction
    INSERT INTO messages SELECT CONCAT('new transaction: ', NEW.transaction_date);

  	INSERT INTO product_sales
	SELECT 
	   products.product_retail_price AS Price,
       transactions.quantity AS Quantity,
       products.product_cost AS Cost,
       stores.store_city AS City,
       stores.store_name AS Store_Name,
       stores.store_type AS Store_Type,
       stores.total_sqft AS Size,
       stores.last_remodel_date AS Last_Renewed,
       customers.customer_id AS customer_id,
       transaction_date AS Date
       
    FROM
		transactions
	INNER JOIN
		stores USING (store_id)
	INNER JOIN
		products USING (product_id)
	INNER JOIN
		customers USING (customer_id)
	INNER JOIN
		region USING (region_id)
	WHERE
		transaction_date = NEW.transaction_date;
        
END //

DELIMITER ;

-- Checking current state of product_sales table
SELECT * FROM product_sales ORDER BY Date DESC;
SELECT COUNT(*) FROM product_sales;

-- Add a new transaction into the transactions database
INSERT INTO transactions VALUES('2020-11-07','2020-11-01',869,3449,6,4);

-- Check whether the record got written into product_sales
SELECT * FROM messages;
SELECT * FROM product_sales WHERE Date LIKE '2020%';
SELECT COUNT(*) FROM product_sales;

-- --------------------------------
-- DATA MART
-- --------------------------------

-- Create the view for the Profit per SQFT
DROP VIEW IF EXISTS Profit_per_sqft;

CREATE VIEW Profit_per_sqft AS
SELECT 
	Store_Name, 
    City, 
    Store_Type, 
    Size, 
	SUM((Quantity*Price)) AS Revenue,
    SUM((Quantity*(Price-Cost))) AS Profit,
    SUM((Quantity*(Price-Cost)))/Size AS Profit_per_sqft
FROM product_sales
    GROUP BY Store_Name
    ORDER BY Profit_per_sqft DESC;

SELECT * FROM Profit_per_sqft;
-- Small-size and middle-size groceries are well below supermarket and deluxe supermarket profitability

-- Create the view for the Customers and Store quality
DROP VIEW IF EXISTS Customers_and_Store_Quality;

CREATE VIEW Customers_and_Store_Quality AS
SELECT
	Store_Name, 
    City, 
    Store_Type,
    Last_Renewed,
    COUNT(DISTINCT(customer_id)) AS Number_of_Customers    
FROM product_sales
	GROUP BY Store_Name
    ORDER BY Number_of_Customers DESC;

SELECT * FROM Customers_and_Store_Quality;
-- There doesn't seem to be a connection between number of customers and date of refurbishment