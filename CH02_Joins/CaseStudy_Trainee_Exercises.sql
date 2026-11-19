/* =====================================================================
   TechNovaDB: SQL Business Case Study, Trainee Exercises
   Database : TechNovaDB  (run 01_TechNovaDB_Setup.sql first)
   Net Sales = Quantity x UnitPrice x (1 - Discount)
   (Discount is stored as a decimal fraction: 0.10 = 10%)
   Write your query under each exercise.
   ===================================================================== */

USE TechNovaDB;
GO


-- Exercise 1
-- Which customers joined after our very first order was placed? Return the columns:
-- CustomerID, FirstName, LastName, JoinDate.
SELECT CustomerID, FirstName, LastName, JoinDate from Customers




-- Exercise 2
-- Which products have been bought by Business customers? Return the columns: ProductID,
-- ProductName.
SELECT CustomerID
FROM Customers AS C
WHERE C.Segment = 'Business';
SELECT O.OrderID
FROM Orders AS O
WHERE O.CustomerID IN (
    SELECT ProductID,ProductName
    FROM Orders
    WHERE O.OrderID=O.CustomerID
);

-- Exercise 3
-- Which employees earn more than every employee in the Support department? Return the
-- columns: FirstName, LastName, Department, Salary.




-- Exercise 4
-- Show every order line with its product name and category name. Return the columns:
-- OrderID, ProductName, CategoryName, Quantity.




-- Exercise 5
-- List every category with the number of products it contains, including categories
-- that have no products yet (show 0). Return the columns: CategoryName, ProductCount.




-- Exercise 6
-- Show each employee's name next to their manager's name; employees without a manager
-- should still appear. Return the columns: EmployeeName, ManagerName.




-- Exercise 7
-- For each sales channel, what is the total net sales and the average net value per
-- order? Return the columns: Channel, TotalNetSales, AvgOrderValue.




-- Exercise 8
-- Which products generated more net sales than the average product that has sold?
-- Return the columns: ProductName, NetSales.




-- Exercise 9
-- Which customer city brings in the most net sales? Show net sales per city, highest
-- first. Return the columns: City, NetSales.




-- Exercise 10
-- Create a view named vw_ProductStock with each product's name, category name, stock
-- quantity and stock value (StockQty x UnitPrice). Then list the products whose stock
-- value is above 300,000. Return the columns: ProductName, CategoryName, StockQty,
-- StockValue.




-- Exercise 11
-- Create a view named vw_OrderTotals with one row per order: order ID, order date,
-- channel, status and the order's net value. Then show the Online orders worth more
-- than 30,000. Return the columns: OrderID, OrderDate, Channel, Status, NetValue.




-- Exercise 12
-- Create a view named vw_BrandSales showing each brand's units sold and net sales. Then
-- show the brands from highest to lowest net sales. Return the columns: Brand,
-- UnitsSold, NetSales.




-- Exercise 13
-- Rank employees by salary within each department, with the highest salary ranked 1.
-- Return the columns: FirstName, LastName, Department, Salary, SalaryRank.




-- Exercise 14
-- Number each customer's orders from their first order to their latest. Return the
-- columns: CustomerID, OrderID, OrderDate, OrderNumber.




-- Exercise 15
-- For each product, show its price, the highest price in its category, and how far
-- below that top price it is. Return the columns: ProductName, CategoryID, UnitPrice,
-- CategoryMaxPrice, GapToMax.




-- End of exercises.
