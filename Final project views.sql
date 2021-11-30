/* Final Project Views

--Create view to see customers' names and tied to invoices
CREATE VIEW CustomerInvoice
AS
SELECT CustomerFirstName, CustomerLastName, OrderNumber, OrderDate, OrderTotal
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WITH CHECK OPTION;

--Create view to see suppliers' names tied to products in the inventory 
CREATE VIEW ProductSuppliers ([Product Number], [Product Name], [Product Category], [Cost per Unit], [Supplier Name]) 
AS
SELECT ProductNumber, ProductName, ProductCategory, CostPerUnit, SupplierName
FROM Products
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WITH CHECK OPTION;

--Create updateable view for adding suppliers
CREATE VIEW AddSuppliers
AS
SELECT SupplierID, SupplierName, SupplierPhoneNumber, SupplierEmail
FROM Suppliers
WITH CHECK OPTION;

--Adding a Supplier to the view
USE PottersSupplies;
GO
INSERT INTO AddSuppliers (SupplierID, SupplierName, SupplierPhoneNumber, SupplierEmail)
VALUES(14, 'Missouri Mudders','(314)877-2478','info@momudders.com');

--Create a view that shows glazes in inventory
CREATE VIEW GlazeStock ([Product Number], [Product Name], [Product Category], [Cost per Unit], [Supplier Name], [Sale Price]) 
AS
SELECT ProductNumber, ProductName, ProductCategory, CostPerUnit, SupplierName, SalesPrice
FROM Products
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE ProductCategory = 'Glaze';

--Updating Glaze Sales Prices
UPDATE GlazeStock
SET [Sale Price]=16.30
WHERE [Sale Price]=15.78;
*/




