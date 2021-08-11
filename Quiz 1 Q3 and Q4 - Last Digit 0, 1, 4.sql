
-- Last Digit 0, 1, 4

-- Question 3

with temp1 as (
select TerritoryID, year(OrderDate) Year, max(TotalDue) NewYear
from Sales.SalesOrderHeader
where month(OrderDate) = 1 and datepart(d, OrderDate) = 1
group by TerritoryID, year(OrderDate)),

temp2 as (
select TerritoryID, year(OrderDate) Year, max(TotalDue) Christmas
from Sales.SalesOrderHeader
where month(OrderDate) = 12 and datepart(d, OrderDate) = 25
group by TerritoryID, year(OrderDate))

select isnull(t1.Year, t2.Year) Year, 
       isnull(t1.TerritoryID, t2.TerritoryID) TerritoryID, 
       isnull(t1.NewYear, 0) 'New Year', 
	   isnull(t2.Christmas, 0) Christmas
from temp1 t1
full join temp2 t2
on t1.TerritoryID = t2.TerritoryID and t1.Year = t2.year
order by Year, TerritoryID;

-- Question 4

with temp as (
select ProductID, year(OrderDate) Year, 
       month(OrderDate) Month, sum(OrderQty) TotalQuantity,
	   rank() over (partition by month(OrderDate) order by sum(OrderQty) desc) Rank
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID
where year(OrderDate) = (select year(max(OrderDate)) from Sales.SalesOrderHeader)
group by year(OrderDate), month(OrderDate), ProductID)

select Year, Month, ProductID, TotalQuantity
from temp
where Rank = 1
order by Month;


