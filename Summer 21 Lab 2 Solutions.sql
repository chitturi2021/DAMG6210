
-- 2-1

select CustomerID, SalesOrderID, cast(OrderDate as date) 'Order Date',
       round(TotalDue, 2) 'Total Due'
from Sales.SalesOrderHeader
where OrderDate > '7-3-2008' and TotalDue < 5
order by CustomerID, OrderDate;


-- 2.2

SELECT SalesPersonID, COUNT(SalesPersonID) AS TotalOrders, 
       CAST(MAX(OrderDate) AS DATE) AS MostRecentOrderDate
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID
ORDER BY TotalOrders DESC;


--2-3

select ProductID, Name, ListPrice
from Production.Product
where ListPrice > (select AVG(ListPrice) from Production.Product)+25
order by ListPrice desc;


-- 2-4

select h.TerritoryID, t.name, 
       (count(SalesOrderID) / count(distinct CustomerID)) Ratio
from Sales.SalesOrderHeader h
join Sales.SalesTerritory t
on h.TerritoryID = t.TerritoryID
group by h.TerritoryID, t.name
order by h.TerritoryID;


-- 2-5

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


