USE AdventureWorks2008R2
-- 2-1
/* Write a query to retrieve all orders made after July 3, 2008
and had an total due value less than $5. Include
the customer id, sales order id, order date and total due columns
in the returned data.
Use the CAST function in the SELECT clause to display the date
only for the order date. Use ROUND to display only two decimal
places for the total due amount. Use an alias to give a descriptive
column heading if a column heading is missing. Sort the returned
data first by the customer id, then order date.
Hint: (a) Use the Sales.SalesOrderHeader table.
(b) The syntax for CAST is CAST(expression AS data_type),
where expression is the column name we want to format and
we can use DATE as data_type for this question to display
just the date.
(c) The syntax for ROUND is ROUND(expression, position_to_round),
where expression is the column name we want to format and
we can use 2 for position_to_round to display two decimal
places. */

SELECT CustomerID, SalesOrderID, Cast(OrderDate as date) 'OrderDate',Round(TotalDue,2) 'TotalDue'
FROM Sales.SalesOrderHeader
WHERE OrderDate> '2008-07-03' and TotalDue <5
ORDER BY CustomerID, OrderDate;



-- 2.2
/* Retrieve the salesperson ID, the most recent order date
and total number of orders processed by each salesperson.
Use a column alias to make the report more presentable
if a column heading is missing. Display only the date of
the order date. Exclude the orders which don't have a
salesperson specified.
Sort the returned data by the total number of orders in
descending.
Hint: You need to work with the Sales.SalesOrderHeader table. */

SELECT SalesPersonID, Cast(MAX(OrderDate) as date) 'OrderDate', Count(SalesOrderID) AS 'TotalOrders'
FROM Sales.SalesOrderHeader
GROUP BY SalesPersonID
HAVING SalesPersonID IS NOT NULL
ORDER BY 'TotalOrders' DESC;



--2-3
/* Write a query to select the product id, name, and list pricefor the product(s) that have a list price greater than the
average list price plus $25.
Use a column alias to make the report more presentable
if a column heading is missing. Sort the returned data by the
list price in descending.
Hint: You’ll need to use a simple subquery to get the average
list price and use it in a WHERE clause. */

SELECT ProductID, Product.Name AS "ProductName", ListPrice
FROM Production.Product
WHERE ListPrice> (SELECT AVG(ListPrice) FROM Production.Product)+25
ORDER BY ListPrice DESC;



-- 2-4
/* Write a query to retrieve the "orders to customer ratio"
(number of orders / unique customers) for all territories.
Return the Territory ID, Territory Name, and Ratio columns.
Use a column alias to make the report more presentable
if a column heading is missing. Sort the returned data by
TerritoryID.*/

WITH AP AS 
(SELECT TerritoryID,COUNT(SalesOrderID) AS "Orders" FROM Sales.SalesOrderHeader 
GROUP BY TerritoryID)
SELECT oh.TerritoryID, t.Name AS "TerritoryName" ,
(CAST(ap.Orders AS FLOAT)/ CAST((COUNT(DISTINCT oh.CustomerID)) AS FLOAT)) AS "OrderToCusomerRatio"
FROM Sales.SalesOrderHeader oh 
INNER JOIN AP ap ON ap.TerritoryID = oh.TerritoryID
INNER JOIN Sales.SalesTerritory t ON oh.TerritoryID = t.TerritoryID
Group BY oh.TerritoryID,t.Name,ap.Orders
ORDER BY oh.TerritoryID;



-- 2-5
/* Write a query to retrieve the salespersons who have processed
more than 200 orders and have sold products of more than
7 different colors. Exclude the orders that don't have a salesperson
specified.
Return the salesperson ID, Total Order Count, Total Unique Colors
columns for each salesperson. Use a column alias to make the report
more presentable if a column heading is missing. Sort the returned data
by SalespersonID. */

SELECT count(distinct oh.SalesOrderID) AS "SalesOrderID", oh.SalesPersonID, COUNT(DISTINCT p.COLOR) AS "UniqueColorCount"
FROM Sales.SalesOrderHeader oh
INNER JOIN Sales.SalesOrderDetail sd ON oh.SalesOrderID=sd.SalesOrderID
INNER JOIN Production.Product p ON sd.ProductID=p.ProductID
WHERE oh.SalesPersonID IS NOT NULL
GROUP BY oh.SalesPersonID
HAVING COUNT(oh.SalesOrderID) > 200 and COUNT(DISTINCT p.COLOR) >7
ORDER BY oh.SalesPersonID;

select SalesPersonID,
       count(distinct sh.SalesOrderID) TotalOrderCount,
       count(distinct p.Color) TotalUniqueColors
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID
join Production.Product p
on sd.ProductID = p.ProductID
where sh.SalesPersonID is not null
group by SalesPersonID
having count(distinct p.Color) > 7 and count(distinct sh.SalesOrderID) > 200
order by SalesPersonID;

-- 2-6
/* Write a query to retrieve the dates in which
there was at least one order placed but no order
worth more than $1000 was placed. Use TotalDue
in Sales.SalesOrderHeader as the order value.
Return the "order date" and "total product quantity sold
for the date" columns. The order quantity column is
in SalesOrderDetail. Display only the date part of the
order date.
Sort the returned data by the
"total product quantity sold for the date" column in desc. */

SELECT CAST(oh.OrderDate as date) AS "OrderDate", SUM(sod.OrderQty) AS "TotalProductQuantitySold"
From Sales.SalesOrderHeader oh
INNER JOIN Sales.SalesOrderDetail sod ON oh.SalesOrderID=sod.SalesOrderID
WHERE oh.TotalDue<=1000
GROUP BY oh.OrderDate
ORDER BY "TotalProductQuantitySold" DESC;


SELECT cast(OrderDate as date) Date, sum(OrderQty) TotalProductQuantitySold
FROM Sales.SalesOrderHeader so
JOIN Sales.SalesOrderDetail sd
ON so.SalesOrderID = sd.SalesOrderID
WHERE OrderDate NOT IN
(SELECT OrderDate
 FROM Sales.SalesOrderHeader
 WHERE TotalDue >1000)
GROUP BY OrderDate
ORDER BY TotalProductQuantitySold desc;


