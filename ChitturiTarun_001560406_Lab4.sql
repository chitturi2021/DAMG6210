
/* Lab 4 Questions
Part A (2 points)
Create 3 tables and the corresponding relationships to implement the ERD below in your own database. */

CREATE DATABASE "Lab4_Tarun_mydb";
GO

USE Lab4_Tarun_mydb;

CREATE TABLE dbo.TargetCustomers (
  TargetID INT NOT NULL,
  FirstName VARCHAR(45) NULL,
  LastName VARCHAR(45) NULL,
  Address VARCHAR(45) NULL,
  City VARCHAR(45) NULL,
  State VARCHAR(45) NULL,
  Zipcode INT NULL,
  PRIMARY KEY (TargetID));


CREATE TABLE dbo.MailingLists (
  MailingListID INT NOT NULL,
  MailingList VARCHAR(45) NULL,
  PRIMARY KEY (MailingListID));


CREATE TABLE dbo.TargetMailingLists (
  TargetID INT NOT NULL,
  MailingListID INT NOT NULL,	
  PRIMARY KEY (TargetID, MailingListID),
  CONSTRAINT TargetID
	FOREIGN KEY (TargetID)
	REFERENCES dbo.TargetCustomers (TargetID),
  CONSTRAINT MailingListID
	FOREIGN KEY (MailingListID)
	REFERENCES dbo.MailingLists (MailingListID));
  

/* other method

CREATE TABLE dbo.TargetMailingLists (
  TargetID INT NOT NULL
	REFERENCES dbo.TargetCustomers (TargetID),
  MailingListID INT NOT NULL
	REFERENCES dbo.MailingLists (MailingListID),
  CONSTRAINT PKTargetMailingListID PRIMARY KEY CLUSTERED (TargetID, MailingListID));
  

*/



/* Part B (2 points)
Use the content of AdventureWorks and write a query to list the top 3 products included in an order for
all orders. The top 3 products have the 3 highest order quantities. If there is a tie, it needs to be
retrieved. The report needs to have the following format. Sort the returned data by the sales order
column.
SalesOrderID Products
43659 709, 711, 777, 714
43660 762, 758
43661 708, 776, 712, 715
43662 758, 770, 762
43663 760 */

USE AdventureWorks2008R2;

WITH Temp AS(
SELECT sod.SalesOrderID as SalesOrderID, sod.ProductID as ProductID, (sod.OrderQty) as Qty, 
RANK() OVER (PARTITION BY sod.SalesOrderID ORDER BY (sod.OrderQty) DESC) as Rank
FROM Sales.SalesOrderDetail sod
)
SELECT t1.SalesOrderID, STRING_AGG( CAST(t1.ProductID as Varchar), ', ') as Products
FROM Temp t1
WHERE Rank<=3
GROUP BY t1.SalesOrderID
ORDER BY t1.SalesOrderID;




/* Part C (2 points)
 Bill of Materials - Recursive */
/* The following code retrieves the components required for manufacturing "Mountain-500 Black, 48"
(Product 992). Modify the code to retrieve the most expensive component(s) at each component level.
Use the list price of a component to determine the most expensive component for each level. Exclude
the components which have a list price of 0. Sort the returned data by the component level. */


WITH Parts(AssemblyID, ComponentID,  PerAssemblyQty, EndDate, ComponentLevel) AS
(
SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
b.EndDate, 0 AS ComponentLevel
FROM Production.BillOfMaterials AS b
WHERE b.ProductAssemblyID = 992 AND b.EndDate IS NULL
UNION ALL
SELECT bom.ProductAssemblyID, bom.ComponentID, p.PerAssemblyQty,
bom.EndDate, ComponentLevel + 1
FROM Production.BillOfMaterials AS bom
INNER JOIN Parts AS p
ON bom.ProductAssemblyID = p.ComponentID AND bom.EndDate IS NULL
)
SELECT AssemblyID, ComponentID,ListPrice, Name, PerAssemblyQty, ComponentLevel FROM (
SELECT RANK() OVER (PARTITION BY ComponentLevel ORDER BY ListPrice DESC) as Rank,
AssemblyID, ComponentID,ListPrice, Name, PerAssemblyQty, ComponentLevel
FROM Parts AS p
INNER JOIN Production.Product AS pr
ON p.ComponentID = pr.ProductID) as test
WHERE ListPrice!=0 and Rank=1
ORDER BY ComponentLevel, AssemblyID, ComponentID; 


