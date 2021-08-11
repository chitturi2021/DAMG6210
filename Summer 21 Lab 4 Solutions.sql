
-- Lab 4

-- Part A

CREATE TABLE dbo.TargetCustomers(    
	TargetID int NOT NULL PRIMARY KEY,    
	FirstName varchar(10),    
	LastName varchar(10),    
	Address varchar(20),    
	City varchar(10),    
	State varchar(10),    
	ZipCode int
);

CREATE TABLE dbo.MailingLists(    
	MailingListID int IDENTITY NOT NULL PRIMARY KEY,    
	 varchar(30)
);

CREATE TABLE dbo.TargetMailingLists(    
	 TargetID int NOT NULL REFERENCES TargetCustomers(TargetID),    
	 MailingListID int NOT NULL REFERENCES MailingLists(MailingListID),    
	 CONSTRAINT pks PRIMARY KEY CLUSTERED(TargetID, MailingListID)
);

-- PART B

-- Solution 1
Select SalesOrderID, 
Stuff((Select top 3 with ties ', ' + rtrim(cast(ProductId as char)) 
       From Sales.SalesOrderDetail 
       Where SalesOrderId = h.SalesOrderId
       Order By OrderQty desc
       FOR XML PATH('')) , 1, 2, '') as Products
From Sales.SalesOrderHeader h
Order by h.SalesOrderID;

-- OR

-- Solution 2
with temp as
(SELECT sh.SalesOrderID, sd.ProductID,
        rank() over (partition by sh.SalesOrderID order by orderqty desc) Ranking
 FROM Sales.SalesOrderHeader sh
 JOIN Sales.SalesOrderDetail sd
 ON sh.SalesOrderID = sd.SalesOrderID
)
SELECT	SalesOrderID,
		STRING_AGG(	cast(ProductID as varchar)
					, ', ')	
					AS Products
FROM temp 
WHERE Ranking <= 3
GROUP BY SalesOrderID
ORDER BY SalesOrderID;


-- PART C 

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
DROP TABLE #TempTable;

WITH Parts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS
(
    -- Top-level compoments
	SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
        b.EndDate, 0 AS ComponentLevel
    FROM Production.BillOfMaterials AS b
    WHERE b.ProductAssemblyID = 992
          AND b.EndDate IS NULL

    UNION ALL

	-- All other sub-compoments
    SELECT bom.ProductAssemblyID, bom.ComponentID, p.PerAssemblyQty,
        bom.EndDate, ComponentLevel + 1
    FROM Production.BillOfMaterials AS bom 
        INNER JOIN Parts AS p
        ON bom.ProductAssemblyID = p.ComponentID
        AND bom.EndDate IS NULL
)
SELECT AssemblyID, ComponentID, Name, ListPrice, PerAssemblyQty, 
       ListPrice * PerAssemblyQty SubTotal, ComponentLevel

into #TempTable

FROM Parts AS p
    INNER JOIN Production.Product AS pr
    ON p.ComponentID = pr.ProductID
ORDER BY ComponentLevel, AssemblyID, ComponentID;

select * from
(select ComponentLevel, ComponentID, Name, ListPrice,
        rank() over (partition by ComponentLevel order by ListPrice DESC) rank
from #TempTable) temp
where rank = 1 and ListPrice > 0
order by ComponentLevel;

