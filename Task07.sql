use AdventureWorks2025;

select * from Production.Product;

--Create a view called VW_Products that displays a list of the products from the Production.Product table joined to the Production.ProductCostHistory table. Include columnsthat show the cost history for each product.

create view VW_Products as
select p.ProductID,p.Name,
p.ProductNumber,p.Color,
pch.StandardCost,pch.StartDate,
pch.EndDate
from Production.Product p
inner join Production.ProductCostHistory pch
on p.ProductID=pch.ProductID;

SELECT * FROM dbo.VW_Products;

--Write a SQL query that concatenate the columns name, productnumber, colour, and a new line character from the following table, each separated by a specified character. (Use production.product)

select 
Name +' | '+ ProductNumber + ' | ' + ISNULL(Color,'') + CHAR(10) as ProductDetails
from Production.Product;

--Write a query in SQL to return the five leftmost characters of each product name. 
  --(Use production.product)

select Name,
left(Name,5) as FirstFiveChars
from Production.Product;

--Write a query in SQL to remove the substring 'HN' from the start of the column productnumber. Filter the results to only show those productnumbers that start with "HN". Return original productnumber column and 'TrimmedProductnumber'. (Use production.Product)

select ProductNumber,
STUFF(ProductNumber,1,2,'') as TrimmedProductNumber
from Production.Product
where ProductNumber like 'HN%';

--Write a query in SQL to replace null values with 'N/A' and return the names separated by commas in a single row. (Use Person.Person)

select STRING_AGG(cast(isnull(FirstName,'N/A') as varchar(max)),', ') as AllNames
from Person.Person;

--Create a view called VW_CustomerTotals that displays the total sales from the TotalDuecolumn per year and month for each customer. (use Sales.SalesOrderHeader tables)

create view VW_CustomerTotals as 
select CustomerID,
YEAR(OrderDate) as OrderYear,
MONTH(OrderDate) as OrderMonth,
SUM(TotalDue) as TotalSales
from Sales.SalesOrderHeader
group by CustomerID,
YEAR(OrderDate),
MONTH(OrderDate);

SELECT * FROM dbo.VW_CustomerTotals;

--Create a temp table called #CustInfo that contains CustomerID, FirstName, and LastNamecolumns. Include CountOfSales (use COUNT()) andSumOfTotalDue(use SUM()) columns. Populate the table with a query using the Sales.Customer, Person.Person, and Sales.SalesOrderHeader tables.

CREATE TABLE #CustInfo (
    CustomerID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    CountOfSales INT,
    SumOfTotalDue MONEY
);

INSERT INTO #CustInfo
SELECT 
    c.CustomerID,
    p.FirstName,
    p.LastName,
    COUNT(soh.SalesOrderID) AS CountOfSales,
    SUM(soh.TotalDue) AS SumOfTotalDue
FROM Sales.Customer c
INNER JOIN Person.Person p
    ON c.PersonID = p.BusinessEntityID
LEFT JOIN Sales.SalesOrderHeader soh
    ON c.CustomerID = soh.CustomerID
GROUP BY 
    c.CustomerID,
    p.FirstName,
    p.LastName;

select * from #CustInfo;

--Create a global table called ##Test that contains two columns (id int identity, random int).use a loop to insert the table with 1000 random integers data using the following formula: CAST(RAND()*1000 AS INT). display the data from global table in another tab.

CREATE TABLE ##Test (
    id INT IDENTITY(1,1),
    random INT
);

DECLARE @i INT = 1;

WHILE @i <= 1000
BEGIN
    INSERT INTO ##Test (random)
    VALUES (CAST(RAND()*1000 AS INT));

    SET @i = @i + 1;
END;

-- Display data

SELECT * FROM ##Test;