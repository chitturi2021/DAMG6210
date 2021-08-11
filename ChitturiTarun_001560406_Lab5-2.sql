--Lab 5-1
/* Create a function in your own database that takes two
parameters:
1) A year parameter
2) A month parameter
The function then calculates and returns the total sale
of the requested period for each territory. The function
returns data sorted by the territory name.
Hints: a) Use the TotalDue column of the
Sales.SalesOrderHeader table in an
AdventureWorks database for
calculating the total sale.
b) The year and month parameters should have
the SMALLINT data type.
*/

CREATE DATABASE "Tarun_mydb";
GO
USE Tarun_mydb;

--DROP FUNCTION GetTotalSalesForEachTerritory;
GO
CREATE FUNCTION GetTotalSalesForEachTerritory 
(@YearT smallint, @MonthT smallint)
RETURNS TABLE AS
RETURN (
SELECT st.Name, SUM(soh.TotalDue) as TotalDue
FROM AdventureWorks2008R2.Sales.SalesOrderHeader soh
JOIN AdventureWorks2008R2.Sales.SalesTerritory st ON st.TerritoryID = soh.TerritoryID 
WHERE @YearT = DATEPART(yy, soh.OrderDate) and @MonthT = DATEPART(mm, soh.OrderDate)
GROUP BY st.Name
--ORDER BY st.Name DESC
);
GO

SELECT * 
FROM GetTotalSalesForEachTerritory(2006,1)
ORDER BY Name;


--Lab 5-2
/*
Create a table in your own database using the following statement.
Write a stored procedure that accepts two parameters:
1) A starting date
2) The number of the consecutive dates beginning with the starting
date
The stored procedure then inserts data into all columns of the
DateRange table according to the two provided parameters.*/

CREATE TABLE DateRange
(DateID INT IDENTITY,
DateValue DATE,
DayOfWeek SMALLINT,
Week SMALLINT,
Month SMALLINT,
Quarter SMALLINT,
Year SMALLINT
);

--DROP PROC InsertDataForRange;
GO
CREATE PROCEDURE InsertDataForRange
@StartDate date,
@ReqNumber int
AS
WHILE @ReqNumber >=0
BEGIN 
--SET NOCOUNT ON;
INSERT INTO DateRange(DateValue,DayOfWeek,Week,Month,Quarter,Year)
VALUES (@StartDate, DATEPART(dw,@StartDate), DATEPART(wk,@StartDate), DATEPART(m,@StartDate), DATEPART(q,@StartDate), YEAR(@StartDate))
SET @StartDate = DATEADD(d,1,@StartDate)
SET @ReqNumber= @ReqNumber-1
END

EXEC InsertDataForRange '2008-9-29',10;

--SELECT * FROM DateRange;
--DELETE FROM DateRange;


--Lab 5-3
/* CREATE 3 tables as listed below in your own database. 
Write a trigger to put the total sale order amount before tax
(unit price * quantity for all items included in an order)
in the OrderAmountBeforeTax column of SaleOrder
whenever there is a change in SaleOrderDetail. */
GO

CREATE TABLE Customer
(CustomerID VARCHAR(20) PRIMARY KEY,
CustomerLName VARCHAR(30),
CustomerFName VARCHAR(30),
CustomerStatus VARCHAR(10));

CREATE TABLE SaleOrder
(OrderID INT IDENTITY PRIMARY KEY,
CustomerID VARCHAR(20) REFERENCES Customer(CustomerID),
OrderDate DATE,
OrderAmountBeforeTax INT);

CREATE TABLE SaleOrderDetail
(OrderID INT REFERENCES SaleOrder(OrderID),
ProductID INT,
Quantity INT,
UnitPrice INT,
PRIMARY KEY (OrderID, ProductID));

/*
INSERT INTO Customer(CustomerID,CustomerLName,CustomerFName,CustomerStatus) 
VALUES (101, 'T', 'C', 'g'); 

INSERT INTO SaleOrder (CustomerID,OrderDate)
VALUES(101,'2020-01-01');
INSERT INTO SaleOrder (CustomerID,OrderDate)
VALUES(101,'2020-01-03');
INSERT INTO SaleOrder (CustomerID,OrderDate)
VALUES(101,'2020-01-06');

INSERT INTO SaleOrderDetail(OrderID,ProductID,Quantity,UnitPrice)
VALUES (4,3001,5,100);
INSERT INTO SaleOrderDetail(OrderID,ProductID,Quantity,UnitPrice)
VALUES (5,3002,15,10);
INSERT INTO SaleOrderDetail(OrderID,ProductID,Quantity,UnitPrice)
VALUES (6,3003,1,10);

SELECT *
FROM Customer;
SELECT *
FROM SaleOrder;
SELECT *
FROM SaleOrderDetail;

DELETE FROM Customer;
DELETE FROM SaleOrder;
DELETE FROM SaleOrderDetail;
*/

--DROP TRIGGER OrderAmountBeforeTaxCol;

GO

CREATE TRIGGER OrderAmountBeforeTaxCol 
ON SaleOrderDetail
AFTER INSERT, UPDATE
AS
IF EXISTS
	(
	SELECT 'True'
	FROM INSERTED i
	JOIN SaleOrder s ON s.OrderID = i.OrderID)
BEGIN
	SET NOCOUNT ON;
	DECLARE @uprice money
	DECLARE @qty int
	DECLARE @total money
	DECLARE @oid int
	SELECT @uprice=INSERTED.UnitPrice FROM INSERTED 
	SELECT @qty=INSERTED.Quantity FROM INSERTED
	SELECT @oid=INSERTED.OrderID FROM INSERTED
	SET @total= @uprice * @qty
	UPDATE SaleOrder
	SET OrderAmountBeforeTax=@total
	WHERE OrderID=@oid
END


--Lab 5-4
/* Using AdventureWorks, write a query to return the
sales territories which have never had an order worth
more than $120000. Include the territory id, territory name
and highest order value in the returned data. Use TotalDue
of SalesOrderHeader as the order value. Sort the returned data
by the territory id. */

SELECT st.TerritoryID, st.Name, MAX(soh.TotalDue) as TotalDue
FROM AdventureWorks2008R2.Sales.SalesOrderHeader soh
JOIN AdventureWorks2008R2.Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID 
WHERE st.TerritoryID NOT IN 
(SELECT soh.TerritoryID
FROM AdventureWorks2008R2.Sales.SalesOrderHeader soh
WHERE soh.TotalDue > 120000)
GROUP BY st.TerritoryID, st.Name
ORDER BY st.TerritoryID;
