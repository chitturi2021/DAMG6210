
-- Lab 3-1

SELECT o.TerritoryID, s.Name,
       COUNT(o.SalesOrderid) [Total Orders],
	   CASE
		  WHEN COUNT(o.SalesOrderID) BETWEEN 1 AND 2000
			 THEN 'Underperforming'
		  WHEN COUNT(o.SalesOrderID) BETWEEN 2001 AND 4000
			 THEN 'Average'
		  ELSE 'Successful'
	   END AS Performance
FROM Sales.SalesOrderHeader o
JOIN Sales.SalesTerritory s
   ON o.TerritoryID = s.TerritoryID
GROUP BY o.TerritoryID, s.Name
ORDER BY o.TerritoryID;



-- Lab 3-2

SELECT o.TerritoryID, s.Name, o.SalesPersonID,
  COUNT(o.SalesOrderid) [Total Orders],
  RANK() OVER (PARTITION BY o.TerritoryID ORDER BY COUNT(o.SalesOrderid) DESC) [Rank]
FROM Sales.SalesOrderHeader o
JOIN Sales.SalesTerritory s
   ON o.TerritoryID = s.TerritoryID
WHERE SalesPersonID IS NOT NULL
GROUP BY o.TerritoryID, s.Name, o.SalesPersonID
ORDER BY o.TerritoryID;



-- Lab 3-3

select * from
   (select CAST(a.OrderDate as DATE) AS OrderDate,
           b.ProductID, c.Name, sum(b.OrderQty) as total,
           RANK() OVER (PARTITION BY a.OrderDate 
	           ORDER BY sum(b.OrderQty)) AS Rank
    from [Sales].[SalesOrderHeader] a
    join [Sales].[SalesOrderDetail] b
         on a.SalesOrderID = b.SalesOrderID
    join [Production].[Product] c
         on c.ProductID = b.ProductID
    group by a.OrderDate, b.ProductID, c.Name
   ) temp
where rank = 1
order by OrderDate desc;


-- Lab 3-4

select Year, temp.SalesPersonID, round(TotalSale, 2) [Total Sales], Bonus from
(
  select year(OrderDate) Year, SalesPersonID, sum(TotalDue) TotalSale,
         rank() over (partition by year(OrderDate) order by sum(TotalDue) desc) as rank
  from Sales.SalesOrderHeader
  where SalesPersonID is not null
  group by year(OrderDate), SalesPersonID) temp
join Sales.SalesPerson s
on temp.SalesPersonID = s.BusinessEntityID
where rank =1
order by Year;


-- Lab 3-5

select sh.CustomerID
   from Sales.SalesOrderHeader sh
   join Sales.SalesOrderDetail sd
   on sh.SalesOrderID = sd.SalesOrderID
   where sh.OrderDate > '8-3-2007'
         and sd.ProductID = 711
intersect
   select sh.CustomerID
   from Sales.SalesOrderHeader sh
   join Sales.SalesOrderDetail sd
   on sh.SalesOrderID = sd.SalesOrderID
   where sh.OrderDate > '8-3-2007'
         and sd.ProductID = 715
order by CustomerID;


