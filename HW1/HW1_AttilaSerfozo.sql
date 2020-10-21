-- HW1 - Attila Serfozo

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
customer_city VARCHAR (255),
customer_state_province VARCHAR (255),
customer_postal_code INTEGER NOT NULL,
customer_country VARCHAR (255),
birthdate DATE NOT NULL,
marital_status VARCHAR (1),
yearly_income VARCHAR (255),
gender VARCHAR (1),
num_children_at_home INTEGER NOT NULL,
education VARCHAR (255),
acct_open_date DATE NOT NULL,
member_card VARCHAR (255),
occupation VARCHAR (255),
homeowner VARCHAR (1),
PRIMARY KEY(customer_id));

-- Load CSV data into customers table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer_Lookup.csv' 
INTO TABLE customers 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(customer_id, customer_city, customer_state_province, customer_postal_code, customer_country, birthdate, marital_status, 
yearly_income, gender, num_children_at_home, education, acct_open_date, member_card, occupation, homeowner);

-- --------------------------
-- Create products table
DROP TABLE IF EXISTS products;
CREATE TABLE products
(product_id INTEGER NOT NULL, 
product_brand VARCHAR (255),
product_name VARCHAR (255),
product_sku BIGINT NOT NULL,
product_retail_price INTEGER NOT NULL,
product_cost INTEGER NOT NULL,
product_weight INTEGER NOT NULL,
recyclable VARCHAR (1),
low_fat VARCHAR (1),
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
store_type VARCHAR (255),
store_name VARCHAR (255),
store_street_address VARCHAR (255),
store_city VARCHAR (255),
store_state VARCHAR (255),
store_country VARCHAR (255),
store_phone VARCHAR (255),
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
sales_district VARCHAR (255),
sales_region VARCHAR (255),
PRIMARY KEY(region_id));

-- Load CSV data into region table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Region_Lookup.csv' 
INTO TABLE region 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(region_id, sales_district, sales_region );