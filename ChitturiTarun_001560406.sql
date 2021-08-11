/*
Using AdventureWorks2008R2, write a query to retrieve
the total order values on 1/1 and 12/25 of a year for
every year and all years of a customer. To be more specific,
it's the total order value on 1/1 and the total order value
on 12/25 of a year. If there are 4 years, there may be
4 pairs of values.
Your solution should consider all years and all customers
as reflected by the data contained in AdventureWorks2008R2.
Exclude the years and/or customers which don't have an
order on these dates. Use TotalDue in SalesOrderHeader as
the order value.
Return the Year, CustomerID, "Total Order Value on New Year",
and "Total Order Value on Christmas" columns. Sort the returned data
first by Year, then by CustomerID.
*/

WITH Temp1 as(
SELECT soh.CustomerID as 'CustomerID', Year(soh.OrderDate) as 'Year',SUM(soh.TotalDue) as 'TOTAL ORDER VAlUE ON NEW YEAR'
FROM Sales.SalesOrderHeader soh
WHERE DAY(soh.OrderDate)=1 AND MONTH(soh.OrderDate) =1
GROUP BY soh.CustomerID,Year(soh.OrderDate),soh.SalesOrderID
),
Temp2 as(
SELECT soh.CustomerID as 'CustomerID', Year(soh.OrderDate) as 'Year',SUM(soh.TotalDue) as 'TOTAL ORDER VAlUE ON CHRISTMAS'
FROM Sales.SalesOrderHeader soh
WHERE DAY(soh.OrderDate)=25 AND MONTH(soh.OrderDate) =12
GROUP BY soh.CustomerID,Year(soh.OrderDate),soh.SalesOrderID
)
SELECT  t1.Year,t1.CustomerID, t1.[TOTAL ORDER VAlUE ON NEW YEAR], t2.[TOTAL ORDER VAlUE ON CHRISTMAS]
FROM Temp1 t1
JOIN Temp2 t2 ON t1.Year =t2.Year --and t1.CustomerID =t2.CustomerID
ORDER BY t1.Year, t1.CustomerID;

/*
Using AdventureWorks2008R2, write a query to retrieve
the salesperson which had the highest total quarterly sold quantity
for each quarter of the most recent year as reflected by the data
stored in the database. Your solution needs to determine the
most recent year at the run time. The sold quantity is
stored in SalesOrderDetail. If there is a tie, your solution
must retrieve it. Exclude the order which don't have a salesperson.
Return the Year, Quarter, Salesperson ID, Total Quarterly sold Quantity
columns. Sort the returned data by Quarter.
*/


WITH Temp1 as(
SELECT soh.SalesPersonID as 'SalesPersonID', Year(MAX(soh.OrderDate)) as 'OrderYear', MONTH(soh.OrderDate) as 'OrderMonth', soh.SalesOrderID as 'oid'
FROM Sales.SalesOrderHeader soh
WHERE soh.SalesPersonID IS NOT NULL AND
MONTH(soh.OrderDate) IN (9,10,11,12)
Group By soh.SalesPersonID,MONTH(soh.OrderDate),soh.SalesOrderID
),
Temp2 as
(SELECT soh.SalesPersonID as 'SalesPersonID', SUM(sod.OrderQty) as 'TotalQuartlySoldQty',soh.SalesOrderID as 'Oid',
RANK() OVER (PARTITION BY soh.SalesPersonID ORDER BY sum(sod.OrderQty) DESC) as 'Rank'
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID=sod.SalesOrderID
Where soh.SalesPersonID IS NOT NULL
Group By soh.SalesPersonID,soh.SalesOrderID)

SELECT DISTINCT t1.OrderMonth,t1.OrderYear,t1.SalesPersonID,t2.TotalQuartlySoldQty
FROM Temp1 t1
JOIN Temp2 t2 on t1.SalesPersonID=t2.SalesPersonID and t1.oid =t2.Oid
WHERE Rank=1
Order By t1.OrderMonth DESC;

