/*
#1 Find out how many products are in the store inventory using COUNT function
USE PottersSupplies;
SELECT COUNT (ProductNumber) AS [Number of Products]
FROM Products;


#2 Find the average cost per unit for products in the inventory that cost more than $50 and less than $1,000
USE PottersSupplies;
SELECT AVG(CostPerUnit) AS [Average Cost per Unit]
FROM Products
WHERE CostPerUnit>50 AND CostPerUnit<1000;


#3: Figure out the total number of orders and sales for February 1st.
USE PottersSupplies;
SELECT COUNT(OrderNumber) AS [Number of Orders], SUM(OrderTotal) AS [Daily Sales] from Orders
WHERE OrderDate = '2020-02-01';


#4 Display the how much of each product in the inventory has been sold and the total sales revenue for each product
USE PottersSupplies;
SELECT Products.ProductName, COUNT(*) AS [Products Sold], SUM(ItemsOrdered.SalesPrice) AS [Total Sales Price of Product] FROM ItemsOrdered
JOIN Products ON ItemsOrdered.ProductNumber = Products.ProductNumber
GROUP BY Products.ProductName;


#5 Select Minimum Invoice Total and Maximum Invoice Total
USE PottersSupplies;
Select MIN (OrderTotal) AS 'Smallest Sale', MAX (OrderTotal) AS 'Largest Sale' from Orders;
*/