
-- Lab 5 Solutions

-- 5-1

CREATE FUNCTION dbo.ufGetTerritorySale
(@y SMALLINT, @m SMALLINT)
RETURNS TABLE
AS
RETURN
SELECT TOP 100 PERCENT t.TerritoryID, t.Name, 
      ROUND(SUM(sh.TotalDue), 2) TotalSale
FROM Sales.SalesOrderHeader sh
JOIN Sales.SalesTerritory t
ON sh.TerritoryID = t.TerritoryID
WHERE YEAR(sh.OrderDate) = @y and MONTH(sh.OrderDate) = @m
GROUP BY t.TerritoryID, t.Name
ORDER BY t.Name;


-- 5-2

CREATE PROC dbo.uspDate
@d DATE, @n INT
AS
BEGIN
  WHILE @n <>0
    BEGIN
      INSERT INTO dbo.DateRange (DateValue, DayOfWeek,
	         Week, Month, Quarter, Year)
      SELECT @d, DATEPART(dw, @d), DATEPART(wk, @d),
	         MONTH(@d), DATEPART(q, @d), YEAR(@d)
      SET @d = DATEADD(d, 1, @d);
      SET @n = @n -1;
    END
END


-- 5-3

CREATE TRIGGER UpdateOrderAmount
    ON SaleOrderDetail
    FOR INSERT, UPDATE, DELETE
AS
BEGIN
   SET NOCOUNT ON;

   declare @oid int, @total int;

   select @oid = isnull(i.OrderID, d.OrderID)
          from inserted i full join deleted d
          ON i.OrderID = d.OrderID and i.ProductID = d.ProductID;

   select @total = sum(UnitPrice*Quantity)
          from SaleOrderDetail
		  where OrderID = @oid;

   UPDATE SaleOrder SET OrderAmountBeforeTax = @total
          WHERE OrderID = @oid;
END


-- 5-4

select t.TerritoryID, Name, round(max(TotalDue), 2) HighestOrderValue
from Sales.SalesTerritory t
join Sales.SalesOrderHeader sh
on t.TerritoryID = sh.TerritoryID
where t.TerritoryID not in
(select TerritoryID
 from Sales.SalesOrderHeader
 where TotalDue > 120000)
group by t.TerritoryID, name
order by t.TerritoryID;
