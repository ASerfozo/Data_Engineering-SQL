-- HW4 - Attila Serfozo

USE classicmodels;

-- INNER join orders,orderdetails,products and customers. Return back:

SELECT 
	t1.orderNumber,
	t2.priceEach,
	t2.quantityOrdered,
	t3.productName,
	t3.productLine,
	t4.city,
	t4.country,
	t1.orderDate
FROM orders t1
INNER JOIN orderdetails t2
ON t1.orderNumber = t2.orderNumber
INNER JOIN products t3
ON t2.productCode = t3.productCode
INNER JOIN customers t4
ON t1.customerNumber = t4.customerNumber;