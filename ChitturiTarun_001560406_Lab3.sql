USE AdventureWorks2008R2

--Lab 3-1
/* Modify the following query to add a column that shows the
sales performance of a territory and contains the following
criteria based on the number of orders:
'Underperforming' for the total order count between 1 and 2000
'Average' for between 2001 and 4000
'Successful' for greater than 4000
Give the new column an alias to make the report more readable.
*/

SELECT o.TerritoryID, s.Name,
COUNT(o.SalesOrderid) [Total Orders],
CASE 
	WHEN COUNT(o.SalesOrderid) BETWEEN 1 AND 2000 THEN 'Underperforming'
	WHEN COUNT(o.SalesOrderid) BETWEEN 2001 AND 4000 THEN 'Average'
	WHEN COUNT(o.SalesOrderid) >4000 THEN 'Successful'
	END AS 'SalesPerformance'
FROM Sales.SalesOrderHeader o
JOIN Sales.SalesTerritory s
ON o.TerritoryID = s.TerritoryID
GROUP BY o.TerritoryID, s.Name
ORDER BY o.TerritoryID;



--Lab 3-2
/* Modify the following query to add a new column named rank.
The new column is based on ranking with gaps according to
the total orders in descending. Also partition by the territory.*/

SELECT Rank() OVER (PARTITION BY o.TerritoryID ORDER BY COUNT(o.SalesOrderid) DESC) AS 'Rank' ,o.TerritoryID, s.Name, o.SalesPersonID,
COUNT(o.SalesOrderid) [Total Orders]
FROM Sales.SalesOrderHeader o
JOIN Sales.SalesTerritory s
ON o.TerritoryID = s.TerritoryID
WHERE SalesPersonID IS NOT NULL
GROUP BY o.TerritoryID, s.Name, o.SalesPersonID
ORDER BY o.TerritoryID;



--Lab 3-3
/* Retrieve the product id, product name, and the total
sold quantity of the worst selling (by total quantity sold)
product of each date. If there is a tie for a date, it needs
to be retrieved.
Sort the returned data by date in descending. */

WITH Temp as
(SELECT sod.ProductID AS 'ProductID', p.Name AS 'ProductName', 
SUM(sod.OrderQty) AS 'TotalQtySold', CAST(soh.OrderDate as Date) as 'OrderDate', 
RANK() OVER (PARTITION BY soh.OrderDate ORDER BY SUM(sod.OrderQty)) as 'Rank'
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
INNER JOIN Production.Product p ON sod.ProductID=p.ProductID
GROUP BY soh.OrderDate,sod.ProductID, p.Name)

SELECT ProductID, ProductName, TotalQtySold, OrderDate FROM Temp
WHERE Rank =1
ORDER BY OrderDate DESC;


--Lab 3-4
/* Write a query to retrieve the most valuable salesperson of each year.
The most valuable salesperson for each year is the salesperson who has
made most sales for AdventureWorks in the year.
Calculate the yearly total of the TotalDue column of SalesOrderHeader
as the yearly total sales for each salesperson. If there is a tie
for the most valuable salesperson, your solution should retrieve it.
Exclude the orders which didn't have a salesperson specified.
Include the salesperson id, the bonus the salesperson earned,
and the most valuable salesperson's total sales for the year
columns in the report. Display 2 decimal places for the total sales.
Sort the returned data by the year. */
/*
WITH Temp AS
(SELECT soh.SalesPersonID as 'SalesPersonID', sp.Bonus as 'Bonus',
COUNT(soh.SalesOrderID) AS 'TotalSales', YEAR(soh.OrderDate) as 'Year',
ROUND(SUM(soh.TotalDue),2) as 'TotalDue',
RANK() OVER (PARTITION BY YEAR(soh.OrderDate) ORDER BY COUNT(soh.SalesOrderID) DESC) AS 'Rank'
FROM Sales.SalesOrderHeader soh
--JOIN Sales.Store s ON soh.SalesPersonID= s.SalesPersonID
JOIN Sales.SalesPerson sp ON sp.BusinessEntityID=soh.SalesPersonID
WHERE soh.SalesPersonID IS NOT NULL
GROUP BY YEAR(soh.OrderDate),soh.SalesPersonID,sp.Bonus
)
--SalesPersonID, Bonus, TotalSales, Year, TotalDue
SELECT * FROM Temp
WHERE Rank = 1
ORDER BY Year;
*/

WITH Temp AS
(SELECT soh.SalesPersonID as 'SalesPersonID', sp.Bonus as 'Bonus',
 YEAR(soh.OrderDate) as 'Year',
ROUND(SUM(soh.TotalDue),2) as 'YearlyTotalSales',
RANK() OVER (PARTITION BY YEAR(soh.OrderDate) ORDER BY SUM(soh.TotalDue) DESC) AS 'Rank'
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesPerson sp ON sp.BusinessEntityID=soh.SalesPersonID
WHERE soh.SalesPersonID IS NOT NULL
GROUP BY YEAR(soh.OrderDate),soh.SalesPersonID,sp.Bonus)
--SalesPersonID, Bonus, TotalSales, Year, TotalDue
SELECT SalesPersonID, Bonus, Year, YearlyTotalSales FROM Temp
WHERE Rank = 1
ORDER BY Year;


--SELECT * FROM Sales.SalesPerson s;
--SELECT * FROM Sales.Store s WHERE s.SalesPersonID = 277;


--Lab 3-5
/* Write a query to return a unique list of customer id’s which
have ordered both products 711 and 715 after August 3, 2007.
Sort the list by customer id. */

(SELECT DISTINCT soh.CustomerID
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod ON (soh.SalesOrderID=sod.SalesOrderID AND sod.ProductID =711)
WHERE soh.OrderDate>'2007-08-03')
INTERSECT
(SELECT DISTINCT soh.CustomerID
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod ON (soh.SalesOrderID=sod.SalesOrderID AND sod.ProductID =715)
WHERE soh.OrderDate>'2007-08-03')
ORDER BY soh.CustomerID;

