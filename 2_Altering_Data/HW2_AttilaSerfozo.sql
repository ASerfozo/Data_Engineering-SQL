-- HW2 - Attila Serfozo

-- Exercise1
-- What state figures in the 145th line of our database?
SELECT state FROM birdstrikes LIMIT 144,1;
-- TENNESSEE

-- Exercise2
-- What is flight_date of the latest birstrike in this database?
SELECT FLIGHT_DATE FROM birdstrikes ORDER BY flight_date DESC LIMIT 1;
-- 2000-04-18

-- Exercise3
-- What was the cost of the 50th most expensive damage?
SELECT DISTINCT COST FROM birdstrikes ORDER BY COST DESC LIMIT 49,1;
-- 5345

-- Exercise4
-- What state figures in the 2nd record, if you filter out all records which have no state and no bird_size specified?
SELECT STATE FROM birdstrikes WHERE state IS NOT NULL AND bird_size IS NOT NULL;
-- " "
SELECT STATE FROM birdstrikes WHERE state != '' AND bird_size != " ";
--  Colorado
SELECT STATE FROM birdstrikes WHERE state IS NOT NULL AND state != '' AND bird_size IS NOT NULL AND bird_size != " ";
--  Colorado

-- Exercise5
-- How many days elapsed between the current date and the flights happening in week 52,
-- for incidents from Colorado? (Hint: use NOW, DATEDIFF, WEEKOFYEAR)
Select flight_date, WEEKOFYEAR(flight_date) AS week_of_flight FROM birdstrikes ORDER BY week_of_flight DESC, flight_date DESC LIMIT 1;
-- 2000-01-02
SELECT DATEDIFF(NOW(), '2000/01/02');
-- Now: 2020/10/02 -> Result: 7579