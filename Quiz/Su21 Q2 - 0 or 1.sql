

-- SECOND LAST DIGIT OF NUID: 0, 1

-- Question 1

with temp
as
 (select TerritoryID, sum(OrderQty) as TotalSales
  from Sales.SalesOrderHeader sh
  join Sales.SalesOrderDetail sd
  on sh.SalesOrderID = sd.SalesOrderID
  group by TerritoryID
  having sum(OrderQty) > 20000)

select 'Sold Quantity' as 'Territory ID',
       [1], [4], [6], [10]

from
( select TerritoryID, totalsales from temp) vertical
pivot
(max(TotalSales) for TerritoryID in ([1], [4], [6], [10])) horizontal;


-- Question 2

with temp as
(select TerritoryID, ProductID, sum(OrderQty) TotalQty,
	   rank() over (partition by TerritoryID order by sum(OrderQty) desc) Position
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID
group by TerritoryID, ProductID)

select distinct t.TerritoryID, name,
STUFF((SELECT  ', ' + cast(ProductID as varchar(10)) + ' ' + cast(TotalQty as varchar(10))
       FROM temp t1
       WHERE t1.TerritoryID = t.TerritoryID and Position <=4
       FOR XML PATH('')) , 1, 2, '') AS Top4Products
from temp t
join Sales.SalesTerritory st
on t.TerritoryID = st.TerritoryID
order by t.TerritoryID;


-- Question 3

create trigger trProcessingFee on Orderdetail
after insert, update, delete
as
begin
   declare @TotalQuantity int, @oid int, @fee money;

   set @oid = (select coalesce(i.OrderID, d.OrderID)
							   from inserted i
							   full join deleted d
							        on i.OrderID=d.OrderID);

   set @TotalQuantity = (select sum(Quantity) from OrderDetail 
                         where OrderID = @oid);
   
   if (select OrderValue from SalesOrder where OrderID = @oid) > 500
      set @fee = 0
      else set @fee = 5 * @TotalQuantity;

   update SalesOrder set ProcessingFee = @fee
          where OrderID = @oid;
end

drop trigger trProcessingFee

