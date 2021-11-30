/* Final Project Procedures

--#3
Use PotterSupplies;
CREATE PROC spProduct
AS
SELECT * FROM Products
GO
--Execute code
EXEC spProduct


--#4
USE PottersSupplies;
GO
CREATE PROC spEmployeeList
    @EmpID int =1
AS
BEGIN
    SELECT *
    FROM Employees
    WHERE EmployeeID = @EmpID
END
GO

--Execute code
EXEC spEmployeeList;
EXEC spEmployeeList 2;
EXEC spEmployeeList 3;
EXEC spEmployeeList 4;


--#5
USE PottersSupplies;
GO
IF object_id('dbo.spTotalInventoryProducts') is not null 
     DROP PROC dbo.spTotalInventoryProducts
GO
CREATE PROC spTotalInventoryProducts
@SupplierID int, @TotalProducts int OUTPUT
AS
SELECT SupplierID, TotalProducts = COUNT(ProductNumber)
FROM Products
WHERE SupplierID=@SupplierID
GROUP BY SupplierID
GO

DECLARE @TotalProducts int
EXEC spTotalInventoryProducts 1, @TotalProducts OUTPUT
PRINT 'Total Number of Products';
PRINT @TotalProducts


--#5 (2nd try)

USE PottersSupplies
GO
IF object_id('dbo.spSalesTotals') is not null 
     drop proc dbo.spSalesTotals
GO
CREATE PROC dbo.spSalesTotals
   @EmployeeID int, @TotalOrders int OUTPUT
AS
SELECT 
   Orders.EmployeeID [Employee ID]
  ,EmployeeFirstName [First Name]
  ,EmployeeLastName [Last Name]
  ,TotalOrders = COUNT(OrderNumber)
  ,sum(OrderTotal) [Total Sales]
FROM
Orders
LEFT JOIN Employees on Orders.EmployeeID =Employees.EmployeeID
GROUP BY
   Orders.EmployeeID
  ,EmployeeFirstName
  ,EmployeeLastName
HAVING
Orders.EmployeeID = @EmployeeID
 
DECLARE @TotalOrders int 
EXEC dbo.spSalesTotals 11, @TotalOrders OUTPUT
PRINT 'Total Number of Sales';
PRINT @TotalOrders;


#6

USE PottersSupplies
GO
IF object_id('spOrderCount') is not null 
     drop proc spOrderCount
GO
CREATE PROC spOrderCount
@EmployeeID varchar(40) = '%'
AS
DECLARE @InvCount int;
SELECT @InvCount = COUNT(OrderNumber)
FROM Orders
JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
WHERE (Employees.EmployeeID LIKE @EmployeeID);
RETURN @InvCount;
GO

DECLARE @invCount int;
EXEC @invCount=spOrderCount '11'
SELECT @invCount AS 'Total Orders Sold'
PRINT 'This employee has sold ' + CONVERT (varchar, @InvCount) + ' orders'


Final Project User Defined Functions

--#8

USE PottersSupplies;
GO
CREATE FUNCTION fnListSupplierID
    (@SupplierName varchar(50))
    RETURNS int
BEGIN
    RETURN (SELECT SupplierID FROM Suppliers WHERE SupplierName = @SupplierName);
END;

USE PottersSupplies;
SELECT SupplierID FROM Suppliers
WHERE SupplierID = dbo.fnListSupplierID('Mud Tools')


--#9

USE PottersSupplies;
GO
IF object_id('fnProducts') is not null 
     drop FUNCTION fnProducts
	 GO
CREATE FUNCTION fnProducts
(@ProductNumber int)
RETURNS table
RETURN
(SELECT * FROM Products WHERE @ProductNumber= Products.ProductNumber);

SELECT * FROM dbo.fnProducts(120012)
SELECT * FROM dbo.fnProducts(120024)
SELECT * FROM dbo.fnProducts(120119)


--Final Project Triggers
--#11,12,13
USE PottersSupplies;
--Create a log table to see new products that have been added
CREATE TABLE ProductLogs
([New Product Number] int, status varchar(30))
GO
--Create Table for Deleted Products
CREATE TABLE DeletedProducts
(ProductNumber int, ProductName varchar(60), ProductCategory varchar(20), 
CostPerUnit money, SupplierID int, SalesPrice money)
GO
--Create trigger for inseting new products
CREATE TRIGGER NewProducts_INSERT ON Products
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ProductNumber int
    SELECT @ProductNumber =INSERTED.ProductNumber 
    FROM INSERTED
    INSERT INTO ProductLogs
    VALUES(@ProductNumber, 'Inserted')
END

--Inserting new products
INSERT INTO Products(ProductNumber,ProductName,ProductCategory,
CostPerUnit,SupplierID,SalesPrice) VALUES (120181,'Drippy Sky','Glaze',6.80, 3, 12.10);

INSERT INTO Products(ProductNumber,ProductName,ProductCategory,
CostPerUnit,SupplierID,SalesPrice) VALUES (220015,'Large Sponge','Tools',2.80, 4, 4.55);


--Checking log
SELECT * FROM ProductLogs;


--Checking NewProducts table
USE PottersSupplies;
SELECT * FROM Products
ORDER BY ProductNumber ASC;


--Create trigger to archive deleted products
USE PottersSupplies;
GO
CREATE TRIGGER NewProducts_DELETE ON Products
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ProductNumber int
	DECLARE @ProductName varchar(60)
	DECLARE @ProductCategory varchar(20)
	DECLARE @CostPerUnit money
	DECLARE @SupplierID int
	DECLARE @SalesPrice money
    SELECT @ProductNumber =DELETED.ProductNumber,
	@ProductName=DELETED.ProductName,
	@ProductCategory = DELETED.ProductCategory,
	@CostPerUnit = DELETED.CostPerUnit,
	@SupplierID = DELETED.SupplierID,
	@SalesPrice=DELETED.SalesPrice
    FROM DELETED
	INSERT INTO DeletedProducts 
	VALUES (@ProductNumber, @ProductName, @ProductCategory, @CostPerUnit, @SupplierID, @SalesPrice)
END

--Delete products from table
DELETE FROM Products WHERE productNumber='120181';
DELETE FROM Products WHERE productNumber='220015';

--Check archive for deleted products
SELECT * FROM DeletedProducts;


--Create trigger to log updates to product table
USE PottersSupplies;
GO
CREATE TRIGGER NewProducts_UPDATE ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ProductNumber int
	DECLARE @Action varchar(50)
    SELECT @ProductNumber = INSERTED.ProductNumber
    FROM INSERTED 

    IF UPDATE(ProductNumber)
        SET @Action = 'Updated ProductNumber'   

    IF UPDATE(ProductName)
        SET @Action = 'Updated Product Name'

    IF UPDATE(ProductCategory)
        SET @Action = 'Updated Category'   

    IF UPDATE(CostPerUnit)
        SET @Action = 'Updated Cost'   

	IF UPDATE(SupplierID)
        SET @Action = 'Updated SupplierID'
	
	IF UPDATE(SalesPrice)
        SET @Action = 'Updated Sales Price'   

    INSERT INTO ProductLogs
    VALUES(@ProductNumber, @Action)
END

UPDATE Products SET CostPerUnit=10.67 WHERE CostPerUnit = 10.23 AND ProductName='Blush';
UPDATE Products SET CostPerUnit=10.67 WHERE CostPerUnit = 10.23 AND ProductName='Royal Blue';

--View product log
USE PottersSupplies;
SELECT * FROM ProductLogs;
*/