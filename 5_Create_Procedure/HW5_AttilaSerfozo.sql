-- HW5 - Attila Serfozo

/* Continue the last script: complete the US local phones to international using the city code. 
Hint: for this you need to find a data source with domestic prefixes mapped to cities, 
import as a table to the database and add new business logic to the procedure. */

USE classicmodels;

-- Create city codes table
DROP TABLE IF EXISTS city_codes;
CREATE TABLE city_codes
(city VARCHAR(50),
AreaCode VARCHAR(3));

-- Load data into table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/city_codes.csv' 
INTO TABLE city_codes
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES 
(city, AreaCode);


DROP PROCEDURE IF EXISTS FixUSPhones; 

DELIMITER $$

CREATE PROCEDURE FixUSPhones ()
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE phone varchar(50) DEFAULT "x";
	DECLARE customerNumber INT DEFAULT 0;
	DECLARE country varchar(50) DEFAULT "";
    DECLARE AreaCode varchar(50) DEFAULT "y";

	-- declare cursor for customer
	DECLARE curPhone
		CURSOR FOR 
            SELECT customers.customerNumber, customers.phone, customers.country, city_codes.AreaCode -- adding area code
            FROM classicmodels.customers 
            INNER JOIN city_codes USING (city); -- joining area code into the table with city

	-- declare NOT FOUND handler
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curPhone;
    
		-- create a copy of the customer table 
	DROP TABLE IF EXISTS classicmodels.fixed_customers;
	CREATE TABLE classicmodels.fixed_customers LIKE classicmodels.customers;
	INSERT fixed_customers SELECT * FROM classicmodels.customers;
  
	fixPhone: LOOP
		FETCH curPhone INTO customerNumber,phone, country, AreaCode; -- add areacode to the loop
		IF finished = 1 THEN 
			LEAVE fixPhone;
		END IF;
		 
		-- insert into messages select concat('country is: ', country, ' and phone is: ', phone);
         
		IF country = 'USA'  THEN
			IF phone NOT LIKE '+%' THEN
				IF LENGTH(phone) = 7 THEN -- for phone numbers with 7 character (1 observation) create the international number
					SET  phone = CONCAT('+1', AreaCode, phone);
					UPDATE classicmodels.fixed_customers 
						SET fixed_customers.phone=phone
							WHERE fixed_customers.customerNumber = customerNumber;
				ELSE 
					SET  phone = CONCAT('+1', phone); -- for the rest (they have the 10 numbers) add only the +1 before the number
					UPDATE classicmodels.fixed_customers 
						SET fixed_customers.phone=phone
							WHERE fixed_customers.customerNumber = customerNumber;
				END IF;    
			END IF;
		END IF;

	END LOOP fixPhone;
	CLOSE curPhone;

END$$
DELIMITER ;

CALL FixUSPhones();

SELECT * FROM fixed_customers WHERE country = 'USA';