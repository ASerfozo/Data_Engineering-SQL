-- HW3 - Attila Serfozo

-- Exercise1
-- Do the same with speed. If speed is NULL or speed < 100 create a "LOW SPEED" category, otherwise, mark as "HIGH SPEED". Use IF instead of CASE!

SELECT aircraft, airline, speed, 
	IF(speed < 100 OR SPEED IS NULL,'LOW SPEED','HIGH SPEED') 
AS speed_category 
FROM birdstrikes 
ORDER BY speed_category;
	
-- Exercise2
-- How many distinct 'aircraft' we have in the database?
SELECT COUNT(DISTINCT(aircraft)) FROM birdstrikes;
-- 3

-- Exercise3
-- What was the lowest speed of aircrafts starting with 'H'
SELECT aircraft, MIN(speed) FROM birdstrikes WHERE speed !=" " AND aircraft LIKE "H%";
-- 9

-- Exercise4
-- Which phase_of_flight has the least of incidents?
SELECT phase_of_flight, COUNT(*) AS count FROM birdstrikes GROUP BY phase_of_flight ORDER BY count ASC;
-- Taxi

-- Exercise5
-- What is the rounded highest average cost by phase_of_flight?
SELECT phase_of_flight, ROUND(AVG(cost)) AS avg_cost FROM birdstrikes GROUP BY phase_of_flight ORDER BY avg_cost DESC;
-- 54673

-- Exercise6
-- What is the highest AVG speed of the states with names less than 5 characters?
SELECT state, AVG(speed) AS avg_speed FROM birdstrikes GROUP BY state HAVING length(state) <5 ORDER BY avg_speed DESC;
-- 2862.5000