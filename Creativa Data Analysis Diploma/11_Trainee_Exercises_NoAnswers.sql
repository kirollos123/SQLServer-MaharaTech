/* =====================================================================
   TechNovaDB: Trainee Exercises
   Database : TechNovaDB  (run 01_TechNovaDB_Setup.sql first)
   Write your query under each exercise.
   ===================================================================== */
USE TechNovaDB;


GO
-- Exercise 1
-- The finance team needs a price list showing each product name, brand and unit price.
-- Return the columns: ProductName, Brand, UnitPrice.
SELECT ProductName,
       brand,
       Unitprice
FROM   Products;

-- Exercise 2
-- Show each product's name and its stock value in thousands of EGP (StockQty x
-- UnitPrice / 1000). Return the columns: ProductName, Stock Value (K EGP).
SELECT ProductName AS [name],
       StockQty,
       StockQty * UnitPrice / 1000 AS [Stock Value]
FROM   Products;

-- Exercise 3
-- HR wants each employee's name and daily rate, assuming 22 working days a month
-- (Salary / 22). Return the columns: FirstName, LastName, DailyRate.
SELECT FirstName,
       LastName,
       Salary / 22 AS [daily rate]
FROM   Employees;

-- Exercise 4
-- Which brands do we sell in each category? Show each category and brand pair once.
-- Return the columns: CategoryID, Brand.
SELECT DISTINCT Categories.CategoryID,
                Products.Brand
FROM   Categories
       INNER JOIN
       Products
       ON Categories.CategoryID = Products.CategoryID;

-- Exercise 5
-- Create a customer directory with one column in the format 'FirstName LastName -
-- Segment'. Return the columns: CustomerDirectory.
SELECT FirstName + ' ' + LastName + ' ' + Segment AS CustomerDirectory
FROM   Customers;

-- Exercise 6
-- Which audio products (CategoryID 5) are still being sold? Return the columns:
-- ProductName, UnitPrice.
SELECT ProductName,
       UnitPrice
FROM   Products
WHERE  CategoryID = 5
       AND Discontinued = 1;

-- Exercise 7
-- Which orders were placed in December 2025? Return the columns: OrderID, OrderDate,
-- Status.
SELECT OrderID,
       OrderDate,
       Status
FROM   orders
WHERE  OrderDate BETWEEN '2025-12-01' AND '2025-12-31';

-- Exercise 8
-- Which customers joined during 2025? Return the columns: FirstName, LastName,
-- JoinDate.
SELECT CategoryID,
       CategoryName
FROM   Categories;

SELECT FirstName,
       LastName,
       JoinDate
FROM   customers
WHERE  JoinDate BETWEEN '2025-1-01' AND '2025-12-31';

-- Exercise 9
-- Which smartphones or tablets cost more than 15,000 EGP? Return the columns:
-- ProductName, CategoryID, UnitPrice.
SELECT ProductName,
       ProductName,
       UnitPrice
FROM   Products
WHERE  UnitPrice > 15000
       AND (CategoryID = 2
            OR CategoryID = 3);

-- Exercise 10
-- Find all products whose name contains the word 'Phone'. Return the columns:
-- ProductName.
SELECT ProductName
FROM   Products
WHERE  ProductName LIKE '%Phone%';

-- Exercise 11
-- Which customers have a first name starting with 'M' or 'S'? Return the columns:
-- FirstName, LastName.
SELECT FirstName,
       LastName
FROM   customers
WHERE  FirstName LIKE 'M%'
       OR FirstName LIKE 'S%';

-- Exercise 12
-- Which customers have no city recorded? Return the columns: CustomerID, FirstName,
-- LastName.
SELECT CustomerID,
       FirstName,
       LastName
FROM   customers
WHERE  City IS NULL;

-- Exercise 13
-- Which Store orders are still open (neither Delivered nor Cancelled)? Return the
-- columns: OrderID, Status, EmployeeID.
SELECT OrderID,
       Status,
       EmployeeID
FROM   orders
WHERE  Status <> 'Delivered'
       AND Status <> 'Cancelled';

-- or 
SELECT OrderID,
       Status,
       EmployeeID
FROM   orders
WHERE  Status NOT IN ('Delivered', 'Cancelled');

-- Exercise 14
-- Which products launched before 2023 are still being sold? Return the columns:
-- ProductName, LaunchDate.
SELECT ProductName,
       LaunchDate
FROM   products
WHERE  launchDate < '2023'
       AND (Discontinued = '0');

-- Exercise 15
-- Who are our 5 highest-paid employees? Highest first. Return the columns: FirstName,
-- LastName, Salary.
SELECT   TOP (5) FirstName,
                 LastName,
                 Salary
FROM     Employees
ORDER BY Salary DESC;

-- Exercise 16
-- How many orders came through each channel? Return the columns: Channel, Orders.
SELECT   Channel,
         COUNT(OrderID) AS Orders
FROM     Orders
GROUP BY Channel;

-- Exercise 17
-- What is the total stock value (StockQty x UnitPrice) of each category? Highest first.
-- Return the columns: CategoryID, StockValue.
SELECT
    CategoryID,
    SUM(StockQty * UnitPrice) AS StockValue
FROM Products
GROUP BY CategoryID
ORDER BY StockValue DESC;
-- Exercise 18
-- For each brand, how many products do we have and what is the most expensive price?
-- Return the columns: Brand, Products, TopPrice.

SELECT Brand,count(ProductID) , 
 MAX(UnitPrice) AS TopPrice

from Products
GROUP BY brand
ORDER BY TopPrice DESC;

-- Exercise 19
-- How many Business and how many Consumer customers do we have in each city? Return the
-- columns: City, Segment, Customers.

SELECT City, Segment, COUNT(Segment) AS Customers
FROM Customers
GROUP BY City, Segment
ORDER BY City;

-- Exercise 20
-- Which products appear in 4 or more order lines? Return the columns: ProductID,
-- OrderLines.
SELECT ProductID, COUNT(ProductID), ProductName
FROM Products
GROUP BY ProductID, ProductName
HAVING COUNT(ProductID) >= 2;
-- Exercise 21
-- Which order statuses have more than 5 orders? Return the columns: Status, Orders.
SELECT  count (OrderID)as Orders ,Status  
from Orders
GROUP BY  Status
HAVING count (OrderID) > 5;
-- How many orders do we have for each status?
-- Return the columns: Status, TotalOrders.
SELECT status ,COUNT(OrderID) as TotalOrders
from Orders
GROUP BY status
-- Which customers have placed more than 3 orders?
-- Return the columns: CustomerID, TotalOrders.
SELECT CustomerID, count (OrderID) as TotalOrders
 from Orders
 GROUP BY CustomerID
 having COUNT(OrderID) > 3;
 -- What is the average order amount for each customer?
-- Return the columns: CustomerID, AverageOrderAmount.
select CustomerID ,  AVG( OrderID) as AverageOrderAmount
FROM Orders
GROUP BY CustomerID
-- Exercise 22
-- In which months of 2025 did we receive 3 or more orders? Return the columns:
-- OrderMonth, Orders.
SELECT
    MONTH(OrderDate) AS OrderMonth,
    COUNT(OrderID) AS Orders
FROM Orders
WHERE YEAR(OrderDate) = 2025
GROUP BY MONTH(OrderDate)
HAVING COUNT(OrderID) >= 3
ORDER BY OrderMonth;

-- Exercise 23
-- Which customers have ordered through both channels (Online and Store)? Return the
-- columns: CustomerID, Channels.
-- Exercise 23
SELECT
    CustomerID,
    STRING_AGG(Channel, ', ') AS Channels
FROM Orders
WHERE Channel IN ('Online', 'Store')
GROUP BY CustomerID
HAVING COUNT(DISTINCT Channel) = 2;
-- Exercise 24
-- Which employees were hired before the Sales Manager? Return the columns: FirstName,
-- LastName, HireDate.
SELECT FirstName ,LastName ,HireDate
from Employees
WHERE HireDate <(
       select HireDate
       from Employees 
       where JobTitle='Sales Manager'
)

-- Exercise 25
-- Which products are more expensive than our most expensive audio product (CategoryID
-- 5)? Return the columns: ProductName, UnitPrice.
SELECT ProductName ,UnitPrice 
from Products 
where  UnitPrice < (
        SELECT MAX(UnitPrice)
FROM Products
WHERE CategoryID = 5

)
      

-- Exercise 26
-- Which customers placed at least one order in 2026? Return the columns: CustomerID,
-- FirstName, LastName.

-- Exercise 27
-- Which products have never been sold with a discount? Return the columns: ProductID,
-- ProductName.
-- Exercise 28
-- For each product, how many units have been sold in total? Show 0 for products never
-- sold. Return the columns: ProductName, UnitsSold.
-- Exercise 29
-- Which customers have at least one order containing a line with a 15% discount? Return
-- the columns: CustomerID, FirstName, LastName.
-- Exercise 30
-- Which Business customers have never placed an order? Return the columns: CustomerID,
-- FirstName, LastName.
-- Exercise 31
-- What percentage of all orders were cancelled? Return the columns: CancelledPct.
-- Exercise 32
-- How many orders have 1 line, how many have 2 lines, and so on? Return the columns:
-- Lines, Orders.
-- End of exercises.
SELECT ProductName,
       CategoryID,
       UnitPrice
FROM   Products
WHERE  UnitPrice > 10000
       AND Discontinued = 0;

SELECT ProductName,
       CategoryID,
       UnitPrice
FROM   Products
WHERE  CategoryID = 2
       OR CategoryID = 3;

SELECT ProductName,
       CategoryID
FROM   Products
WHERE  CategoryID IN (2, 3, 5);

SELECT FirstName,
       LastName
FROM   Employees
WHERE  EmployeeID IN (3, 4, 5);

SELECT ProductName,
       UnitPrice
FROM   Products
WHERE  UnitPrice BETWEEN 5000 AND 15000;

-- or not wreite with BETWEEN 
SELECT FirstName,
       LastName,
       Salary
FROM   Employees
WHERE  Salary BETWEEN 5000 AND 15000;

SELECT COUNT(*) AS TotalEmployees
FROM   Employees;

SELECT COUNT(*) AS Totalcustomer
FROM   Customers;

SELECT SUM(Salary) AS TotalSalaries
FROM   Employees;

SELECT   CustomerID,
         COUNT(OrderID) AS Orders
FROM     Orders
GROUP BY CustomerID;

SELECT avg(salary) AS AverageSalary
FROM   Employees;

SELECT MIN(UnitPrice) AS LowestUnitPrice,
       MAX(UnitPrice) AS HigheUnitPrice
FROM   Products;

SELECT   Department,
         COUNT(*) AS Employees
FROM     Employees
GROUP BY Department;

SELECT   city,
         count(*) AS Customers
FROM     Customers
GROUP BY City;
SELECT Department, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY Department;
select  ProductName , avg (UnitPrice) as avfUnitPrice
from Products
GROUP BY ProductName
SELECT ProductName, MAX(UnitPrice) AS HighestProduct
FROM Products
GROUP BY ProductName;
SELECT Status, COUNT(*) AS Orders
FROM Orders
GROUP BY Status;
SELECT City, Segment, COUNT(*) AS Customers
FROM Customers
GROUP BY City, Segment;
SELECT ManagerID,firstname, COUNT(*) AS Employees
FROM Employees
GROUP BY ManagerID;

SELECT Department, COUNT(*) AS Employees
FROM Employees
GROUP BY Department
HAVING COUNT(*) >= 2;
SELECT CustomerID, COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 3;
SELECT Department, AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 10000;

select  