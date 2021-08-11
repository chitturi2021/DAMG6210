
-- Last Digit 7, 9

-- Question 3

with temp1 as (
select top 1 with ties so.SalesOrderID, year(OrderDate) Year, sum(orderqty) NewYear
from Sales.SalesOrderHeader so
join Sales.SalesOrderDetail sd
on so.SalesOrderID = sd.SalesOrderID
where month(OrderDate) = 1 and datepart(d, OrderDate) = 1 
group by so.SalesOrderID, year(OrderDate)
order by sum(orderqty) desc),

temp2 as (
select top 1 with ties so.SalesOrderID, year(OrderDate) Year, sum(orderqty) Christmas
from Sales.SalesOrderHeader so
join Sales.SalesOrderDetail sd
on so.SalesOrderID = sd.SalesOrderID
where month(OrderDate) = 12 and datepart(d, OrderDate) = 25 
group by so.SalesOrderID, year(OrderDate)
order by sum(orderqty) desc)

select isnull(t1.Year, t2.Year) Year, 
       isnull(t1.SalesOrderID, t2.SalesOrderID) OrderID, 
       isnull(t1.NewYear, 0) 'New Year', 
	   isnull(t2.Christmas, 0) Christmas
from temp1 t1
full join temp2 t2
on t1.Year = t2.year
order by Year, t1.SalesOrderID;


-- Question 4

with temp as (
select TerritoryID, year(OrderDate) Year, 
       month(OrderDate) Month, sum(OrderQty) TotalQuantity,
	   rank() over (partition by month(OrderDate) order by sum(OrderQty) desc) Rank
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID
where year(OrderDate) = (select year(max(OrderDate)) from Sales.SalesOrderHeader)
group by year(OrderDate), month(OrderDate), TerritoryID)

select Year, Month, TerritoryID, TotalQuantity
from temp
where Rank = 1
order by Month;
