
-- Last Digit 2, 3, 8

-- Question 3

with temp1 as (
select SalesPersonID, year(OrderDate) Year, round(avg(TotalDue), 2) JAN1
from Sales.SalesOrderHeader
where month(OrderDate) = 1 and datepart(d, OrderDate) = 1 and SalesPersonID is not null
group by SalesPersonID, year(OrderDate)),

temp2 as (
select SalesPersonID, year(OrderDate) Year, round(avg(TotalDue), 2) DEC25
from Sales.SalesOrderHeader
where month(OrderDate) = 12 and datepart(d, OrderDate) = 25 and SalesPersonID is not null
group by SalesPersonID, year(OrderDate))

select isnull(t1.Year, t2.Year) Year, 
       isnull(t1.SalesPersonID, t2.SalesPersonID) SalesPersonID, 
       isnull(t1.JAN1, 0) JAN1, 
	   isnull(t2.DEC25, 0) DEC25
from temp1 t1
full join temp2 t2
on t1.SalesPersonID = t2.SalesPersonID and t1.Year = t2.year
order by Year, SalesPersonID;


-- Question 4

with temp as (
select CustomerID, year(OrderDate) Year, 
       DATEPART(qq, OrderDate) Quarter, sum(OrderQty) TotalQuantity,
	   rank() over (partition by DATEPART(qq, OrderDate) order by sum(OrderQty) desc) Rank
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID
where year(OrderDate) = (select year(max(OrderDate)) from Sales.SalesOrderHeader)
group by year(OrderDate), DATEPART(qq, OrderDate), CustomerID)

select Year, Quarter, CustomerID, TotalQuantity
from temp
where Rank = 1
order by Quarter;


