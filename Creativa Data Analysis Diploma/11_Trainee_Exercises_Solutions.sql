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

SELECT ProductName , brand ,Unitprice 
from Products 


-- Exercise 2
-- Show each product's name and its stock value in thousands of EGP (StockQty x
-- UnitPrice / 1000). Return the columns: ProductName, Stock Value (K EGP).
SELECT  ProductName as[name] ,StockQty ,
StockQty * UnitPrice  / 1000 as [Stock Value]
from Products
  
 


-- Exercise 3
-- HR wants each employee's name and daily rate, assuming 22 working days a month
-- (Salary / 22). Return the columns: FirstName, LastName, DailyRate.

SELECT FirstName  ,   LastName , Salary /22 as [daily rate]

   
from Employees


-- Exercise 4
-- Which brands do we sell in each category? Show each category and brand pair once.
-- Return the columns: CategoryID, Brand.
SELECT DISTINCT 
     Categories.CategoryID,Products.Brand
FROM Categories
JOIN Products 
    on Categories.CategoryID=Products.CategoryID;
-- Exercise 5
-- Create a customer directory with one column in the format 'FirstName LastName -
-- Segment'. Return the columns: CustomerDirectory.
SELECT FirstName + ' ' + LastName + ' ' + Segment as CustomerDirectory
from Customers
 

-- Exercise 6
-- Which audio products (CategoryID 5) are still being sold? Return the columns:
-- ProductName, UnitPrice.
select ProductName ,UnitPrice 
FROM Products
WHERE CategoryID = 5 and Discontinued =1




-- Exercise 7
-- Which orders were placed in December 2025? Return the columns: OrderID, OrderDate,
-- Status.

select OrderID ,OrderDate ,Status
from orders
where OrderDate between '2025-12-01' and '2025-12-31'



-- Exercise 8
-- Which customers joined during 2025? Return the columns: FirstName, LastName,
-- JoinDate.
SELECT CategoryID, CategoryName
FROM Categories;
SELECT   FirstName , LastName  ,JoinDate
from customers 

where JoinDate BETWEEN'2025-1-01' and '2025-12-31'




-- Exercise 9
-- Which smartphones or tablets cost more than 15,000 EGP? Return the columns:
-- ProductName, CategoryID, UnitPrice.
SELECT  ProductName ,ProductName ,UnitPrice
 
from Products 
where UnitPrice >15000 and(CategoryID = 2 OR CategoryID = 3) 



  

-- Exercise 10
-- Find all products whose name contains the word 'Phone'. Return the columns:
-- ProductName.

SELECT ProductName
from  Products
where ProductName like '%Phone%'


-- Exercise 11
-- Which customers have a first name starting with 'M' or 'S'? Return the columns:
-- FirstName, LastName.




-- Exercise 12
-- Which customers have no city recorded? Return the columns: CustomerID, FirstName,
-- LastName.




-- Exercise 13
-- Which Store orders are still open (neither Delivered nor Cancelled)? Return the
-- columns: OrderID, Status, EmployeeID.




-- Exercise 14
-- Which products launched before 2023 are still being sold? Return the columns:
-- ProductName, LaunchDate.




-- Exercise 15
-- Who are our 5 highest-paid employees? Highest first. Return the columns: FirstName,
-- LastName, Salary.




-- Exercise 16
-- How many orders came through each channel? Return the columns: Channel, Orders.




-- Exercise 17
-- What is the total stock value (StockQty x UnitPrice) of each category? Highest first.
-- Return the columns: CategoryID, StockValue.




-- Exercise 18
-- For each brand, how many products do we have and what is the most expensive price?
-- Return the columns: Brand, Products, TopPrice.




-- Exercise 19
-- How many Business and how many Consumer customers do we have in each city? Return the
-- columns: City, Segment, Customers.




-- Exercise 20
-- Which products appear in 4 or more order lines? Return the columns: ProductID,
-- OrderLines.




-- Exercise 21
-- Which order statuses have more than 5 orders? Return the columns: Status, Orders.




-- Exercise 22
-- In which months of 2025 did we receive 3 or more orders? Return the columns:
-- OrderMonth, Orders.




-- Exercise 23
-- Which customers have ordered through both channels (Online and Store)? Return the
-- columns: CustomerID, Channels.




-- Exercise 24
-- Which employees were hired before the Sales Manager? Return the columns: FirstName,
-- LastName, HireDate.




-- Exercise 25
-- Which products are more expensive than our most expensive audio product (CategoryID
-- 5)? Return the columns: ProductName, UnitPrice.




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
