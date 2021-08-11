
-- Last Digit 5, 6

-- Question 3

with temp1 as (
select CustomerID, year(OrderDate) Year, round(sum(TotalDue), 2) NewYear
from Sales.SalesOrderHeader
where month(OrderDate) = 1 and datepart(d, OrderDate) = 1 -- and CustomerID between 10000 and 20000
group by CustomerID, year(OrderDate)),

temp2 as (
select CustomerID, year(OrderDate) Year, round(sum(TotalDue), 2) Christmas
from Sales.SalesOrderHeader
where month(OrderDate) = 12 and datepart(d, OrderDate) = 25 -- and CustomerID between 10000 and 20000
group by CustomerID, year(OrderDate))

select isnull(t1.Year, t2.Year) Year, 
       isnull(t1.CustomerID, t2.CustomerID) CustomerID, 
       isnull(t1.NewYear, 0) 'New Year', 
	   isnull(t2.Christmas, 0) Christmas
from temp1 t1
full join temp2 t2
on t1.CustomerID = t2.CustomerID and t1.Year = t2.year
order by Year, CustomerID;


-- Question 4

with temp as (
select SalesPersonID, year(OrderDate) Year, 
       DATEPART(qq, OrderDate) Quarter, sum(OrderQty) TotalQuantity,
	   rank() over (partition by DATEPART(qq, OrderDate) order by sum(OrderQty) desc) Rank
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID
where year(OrderDate) = (select year(max(OrderDate)) from Sales.SalesOrderHeader)
      and SalesPersonID is not null
group by year(OrderDate), DATEPART(qq, OrderDate), SalesPersonID)

select Year, Quarter, SalesPersonID, TotalQuantity
from temp
where Rank = 1
order by Quarter;

