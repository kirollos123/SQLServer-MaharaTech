/* =====================================================================
   TechNovaDB — Student Exercises
   Database : TechNovaDB  (run 01_TechNovaDB_Setup.sql first)
   Scope    : SELECT → DISTINCT → WHERE → BETWEEN/IN/LIKE → NULL →
              ORDER BY/TOP → Aggregates → GROUP BY → HAVING →
              Scalar / Multi-row / Correlated subqueries → EXISTS →
              Derived tables
   ---------------------------------------------------------------------
   Write your query under each question, run it, and check the result
   makes sense. Levels: [Basic] → [Intermediate] → [Advanced].
   Run the inner query of a subquery on its own before nesting it.
   How to run one query: highlight it, then press F5 (Execute).
   ===================================================================== */

USE TechNovaDB;
GO



/* =====================================================================
   SECTION 01 | SELECT & FROM — Retrieving Columns
   Deck topic 1 (slides 6–9)
   Goal: Choose which columns to return, rename them with aliases, and create calculated columns.
   ===================================================================== */


-- Exercise 1.1  [Basic]
-- List the name, job title and department of every employee.
-- Your answer:
SELECT FirstName + '' +LastName as full_name ,JobTitle,department
FROM Employees ;


-- Exercise 1.2  [Basic]
-- Show each customer's full name in one column called FullName, plus their city.
-- Hint: Use + to join text in SQL Server, with a space in the middle.
-- Your answer:
SELECT FirstName + '' +LastName as full_name, city 
FROM Customers
-- Exercise 1.3  [Basic]
-- Show each employee's name, monthly salary, and annual salary (AnnualSalary = Salary ×
-- 12).
-- Your answer:
   select     firstname  +lastname  as fullname

 from Employees
 SELECT  firstname  +lastname  as fullname,salary *12 as AnnualSalary

 from Employees;
-- Exercise 1.4  [Intermediate]
-- For every product, show the name, stock quantity, price, and the total stock value
-- (StockValue = StockQty × UnitPrice).
-- Your answer: 
   SELECT ProductName  ,StockQty,UnitPrice  ,StockQty *StockQty as StockValue
   from Products




-- Exercise 1.5  [Intermediate]
-- For every order line, show OrderID, ProductID, the gross value (Quantity × UnitPrice)
-- and the net value after discount (gross × (1 − Discount)).
-- Hint: Discount is stored as a rate: 0.10 means 10%.
-- Your answer:
SELECT
    OrderItemID,
    ProductID,
    Quantity * UnitPrice AS gross_value,
    Quantity * UnitPrice * (1 -0.10 ) AS net_value
FROM OrderItems;



/* =====================================================================
   SECTION 02 | DISTINCT — Removing Duplicate Rows
   Deck topic 2 (slides 10–12)
   Goal: Return each unique value (or combination of values) once.
   ===================================================================== */


-- Exercise 2.1  [Basic]
-- List the different departments in the company, each once.
-- Your answer:

SELECT DISTINCT Department
FROM Employees;

-- Exercise 2.2  [Basic]
-- List the different order statuses that exist in the Orders table.
-- Your answer:
SELECT DISTINCT Status
from Orders ;



-- Exercise 2.3  [Intermediate]
-- List every unique combination of Segment and City in Customers.
-- Hint: DISTINCT works on all selected columns together.
-- Your answer:

SELECT DISTINCT Segment, City
FROM Customers;
-- Exercise 2.4  [Intermediate]
-- Which ProductIDs have actually been sold at least once? Show each ProductID once.
-- Your answer:
SELECT DISTINCT ProductID
FROM OrderItems;



/* =====================================================================
   SECTION 03 | WHERE — Filtering Rows with ConditionsSELECT
    OrderItemID,
    ProductID,
    Quantity * UnitPrice AS gross_value,
    Quantity * UnitPrice * (1 -0.10 ) AS net_value
FROM OrderItems;

   Deck topic 3 (slides 14–17)
   Goal: Keep only the rows that meet a condition, using comparison and logical operators.
   ===================================================================== */


-- Exercise 3.1  [Basic]
-- Show employees whose monthly salary is at least 20,000.
-- Your answer:




-- Exercise 3.2  [Basic]
-- Show all Business-segment customers.
-- Your answer:




-- Exercise 3.3  [Basic]
-- Show all orders that are not Delivered.
-- Hint: The 'not equal' operator is <> (!= also works in SQL Server).
-- Your answer:




-- Exercise 3.4  [Intermediate]
-- Show Online orders that were Cancelled.
-- Your answer:




-- Exercise 3.5  [Intermediate]
-- Show products in category 4 (Accessories) that cost less than 1,000 EGP and are still
-- in stock.
-- Your answer:




-- Exercise 3.6  [Advanced]
-- Show Sales employees who earn more than 17,000 OR anyone in Support. Write it so the
-- Department condition and the salary condition stay together.
-- Hint: Group the two Sales conditions in parentheses.
-- Your answer:





/* =====================================================================
   SECTION 04 | BETWEEN, IN & LIKE — Special Filter Operators
   Deck topic 4 (slides 18–20)
   Goal: Filter by ranges, lists of values, and text patterns.
   ===================================================================== */


-- Exercise 4.1  [Basic]
-- Show employees hired between 2021-01-01 and 2023-12-31.
-- Your answer:




-- Exercise 4.2  [Basic]
-- Show orders whose status is Pending or Shipped (use IN).
-- Your answer:




-- Exercise 4.3  [Basic]
-- Show products whose name ends with 'Mini'.
-- Your answer:




-- Exercise 4.4  [Intermediate]
-- Show products in categories 1, 2 or 3 (laptops, phones, tablets) priced between
-- 10,000 and 30,000.
-- Your answer:




-- Exercise 4.5  [Intermediate]
-- Show customers who do NOT live in Cairo or Alexandria.
-- Your answer:




-- Exercise 4.6  [Advanced]
-- Show customers whose email address is on the domain 'mail.com' and whose last name
-- starts with S.
-- Your answer:





/* =====================================================================
   SECTION 05 | NULL — Working with Missing Values
   Deck topic 5 (slides 21–25)
   Goal: Find, exclude and replace missing values correctly.
   ===================================================================== */


-- Exercise 5.1  [Basic]
-- Show customers who have no phone number.
-- Your answer:




-- Exercise 5.2  [Basic]
-- Show products that have a brand (Brand is not missing).
-- Your answer:




-- Exercise 5.3  [Basic]
-- Show employees who have no manager.
-- Your answer:




-- Exercise 5.4  [Intermediate]
-- Show every customer's name and city; replace a missing city with 'Unknown'.
-- Your answer:




-- Exercise 5.5  [Intermediate]
-- Show Online orders (no employee) that have not shipped yet.
-- Your answer:




-- Exercise 5.6  [Advanced]
-- For every employee, show name, salary, and the monthly commission amount = Salary ×
-- Commission. Employees with no commission must show 0, not NULL.
-- Hint: Any arithmetic with NULL gives NULL. Replace it before you multiply.
-- Your answer:





/* =====================================================================
   SECTION 06 | ORDER BY & TOP — Sorting and Limiting Results
   Deck topic 6 (slides 26–28)
   Goal: Sort results by one or more columns and return only the first N rows.
   ===================================================================== */


-- Exercise 6.1  [Basic]
-- List employees from highest to lowest salary.
-- Your answer:




-- Exercise 6.2  [Basic]
-- List products alphabetically by name.
-- Your answer:




-- Exercise 6.3  [Intermediate]
-- Show the 5 cheapest products that are still in stock.
-- Your answer:




-- Exercise 6.4  [Intermediate]
-- List orders by Status (A→Z) and, within each status, newest first.
-- Your answer:




-- Exercise 6.5  [Advanced]
-- Show the 3 order lines with the highest net value (Quantity × UnitPrice × (1 −
-- Discount)).
-- Your answer:





/* =====================================================================
   SECTION 07 | Aggregate Functions — Summarizing Many Rows
   Deck topic 7 (slides 30–33)
   Goal: Reduce many rows to one value with COUNT, SUM, AVG, MIN and MAX.
   ===================================================================== */


-- Exercise 7.1  [Basic]
-- How many products do we sell (rows in Products)?
-- Your answer:




-- Exercise 7.2  [Basic]
-- What is the total monthly salary cost of all employees?
-- Your answer:




-- Exercise 7.3  [Basic]
-- What are the earliest and latest order dates?
-- Your answer:




-- Exercise 7.4  [Intermediate]
-- How many products have a brand, and how many different brands are there? (one query)
-- Your answer:




-- Exercise 7.5  [Intermediate]
-- How many orders were handled by an employee (store orders)? Answer without using
-- WHERE.
-- Hint: COUNT(column) ignores NULLs.
-- Your answer:




-- Exercise 7.6  [Advanced]
-- What is the total net sales value (after discount) of all order lines, and the
-- average net value per line?
-- Your answer:





/* =====================================================================
   SECTION 08 | GROUP BY — Summarizing per Group
   Deck topic 8 (slides 34–38)
   Goal: Split rows into groups and calculate one summary row per group.
   ===================================================================== */


-- Exercise 8.1  [Basic]
-- How many customers are in each city?
-- Your answer:




-- Exercise 8.2  [Basic]
-- How many employees work in each department, and what is the average salary there?
-- Your answer:




-- Exercise 8.3  [Intermediate]
-- How many orders did each customer place? Show the biggest buyers first.
-- Your answer:




-- Exercise 8.4  [Intermediate]
-- How many orders did each employee handle? (What does the NULL row represent?)
-- Your answer:




-- Exercise 8.5  [Intermediate]
-- For each order, show the number of lines and the order's gross value.
-- Hint: Grain change: OrderItems is one row per line; the result is one row per order.
-- Your answer:




-- Exercise 8.6  [Advanced]
-- How many orders were placed in each year and month? Sort chronologically.
-- Hint: Group by the same expressions you SELECT.
-- Your answer:





/* =====================================================================
   SECTION 09 | HAVING — Filtering Groups (WHERE vs HAVING)
   Deck topic 9 (slides 39–42)
   Goal: Filter groups after aggregation, and understand the logical processing order.
   ===================================================================== */


-- Exercise 9.1  [Basic]
-- Which cities have more than 3 customers?
-- Your answer:




-- Exercise 9.2  [Basic]
-- Which brands have an average product price above 10,000? (ignore unbranded products)
-- Hint: Removing NULL brands is a row filter → WHERE. The average condition is a group
-- filter → HAVING.
-- Your answer:




-- Exercise 9.3  [Intermediate]
-- Which orders contain more than one line?
-- Your answer:




-- Exercise 9.4  [Intermediate]
-- Which employees handled at least 4 store orders? (exclude Online orders)
-- Your answer:




-- Exercise 9.5  [Advanced]
-- Which products generated more than 50,000 EGP in gross sales (Quantity × UnitPrice)?
-- Highest first.
-- Your answer:




-- Exercise 9.6  [Advanced]
-- Among Delivered orders only, which customers placed 2 or more orders?
-- Your answer:





/* =====================================================================
   SECTION 10 | Scalar Subqueries — One Value Inside Another Query
   Deck topic 10 (slides 44–47)
   Goal: Use a query that returns exactly one value as part of a condition or a column.
   ===================================================================== */


-- Exercise 10.1  [Basic]
-- Which employees earn more than the average salary?
-- Your answer:




-- Exercise 10.2  [Basic]
-- Who is the most recently hired employee?
-- Your answer:




-- Exercise 10.3  [Intermediate]
-- Show all products in the 'Audio' category, without typing its CategoryID number.
-- Your answer:




-- Exercise 10.4  [Intermediate]
-- Which order lines have a quantity above the average quantity per line?
-- Hint: AVG of an INT column returns an INT in SQL Server. Multiply by 1.0 for a
-- decimal average.
-- Your answer:




-- Exercise 10.5  [Advanced]
-- Show each employee's salary and what percentage of the total salary cost it
-- represents.
-- Your answer:





/* =====================================================================
   SECTION 11 | Multi-row Subqueries — IN and NOT IN
   Deck topic 11 (slides 48–50)
   Goal: Use a subquery that returns a list of values, and avoid the NOT IN + NULL trap.
   ===================================================================== */


-- Exercise 11.1  [Basic]
-- Show products that have been sold at least once (use IN).
-- Your answer:




-- Exercise 11.2  [Basic]
-- Show customers who never placed an order.
-- Your answer:




-- Exercise 11.3  [Intermediate]
-- Show customers who have at least one Cancelled order.
-- Your answer:




-- Exercise 11.4  [Intermediate]
-- Show products that appear in any order line with a discount of 10% or more.
-- Your answer:




-- Exercise 11.5  [Advanced]
-- Show the Sales employees who have never handled an order. Make sure your query is
-- safe from the NULL trap.
-- Hint: Orders.EmployeeID contains NULLs.
-- Your answer:




-- Exercise 11.6  [Advanced]
-- Show customers who ordered any product from the Laptops category (two levels of
-- nesting).
-- Hint: Work from the inside out: category → products → order lines → orders →
-- customers.
-- Your answer:





/* =====================================================================
   SECTION 12 | Correlated Subqueries — The Inner Query Depends on the Outer Row
   Deck topic 12 (slides 51–53)
   Goal: Compare each row with a value calculated for its own group.
   ===================================================================== */


-- Exercise 12.1  [Intermediate]
-- Show employees who earn more than the average salary of their own department.
-- Your answer:




-- Exercise 12.2  [Intermediate]
-- For every product, show its name and how many times it appears in OrderItems (0 if
-- never).
-- Your answer:




-- Exercise 12.3  [Intermediate]
-- Show the most expensive product in each category.
-- Your answer:




-- Exercise 12.4  [Advanced]
-- For every customer, show their name and the total quantity of items they have bought
-- (0 if none).
-- Hint: SUM of no rows is NULL, not 0. Wrap it in ISNULL.
-- Your answer:




-- Exercise 12.5  [Advanced]
-- Show order lines where the quantity is above that product's average quantity per
-- line.
-- Your answer:





/* =====================================================================
   SECTION 13 | EXISTS & NOT EXISTS — Checking Whether Related Rows Exist
   Deck topic 13 (slides 54–56)
   Goal: Test for the presence or absence of matching rows; compare EXISTS with IN.
   ===================================================================== */


-- Exercise 13.1  [Basic]
-- Show products that have been ordered at least once (use EXISTS).
-- Your answer:




-- Exercise 13.2  [Basic]
-- Show customers who have never placed an order (use NOT EXISTS).
-- Your answer:




-- Exercise 13.3  [Intermediate]
-- Show employees who manage at least one other employee.
-- Hint: Two copies of the same table: m = manager, e = employee.
-- Your answer:




-- Exercise 13.4  [Intermediate]
-- Show customers who have placed at least one Online order.
-- Your answer:




-- Exercise 13.5  [Advanced]
-- Show customers who have ordered but never had an order Delivered.
-- Your answer:




-- Exercise 13.6  [Advanced]
-- Show in-stock products that have never been sold (stock that is not moving).
-- Your answer:





/* =====================================================================
   SECTION 14 | Subqueries in FROM — Derived Tables
   Deck topic 14 (slides 57–58)
   Goal: Treat the result of a query as a temporary table, to aggregate in two steps.
   ===================================================================== */


-- Exercise 14.1  [Intermediate]
-- What is the average number of lines per order?
-- Your answer:




-- Exercise 14.2  [Intermediate]
-- Show only products whose net sales value (after discount) is above 30,000, using a
-- derived table instead of HAVING.
-- Your answer:




-- Exercise 14.3  [Advanced]
-- What is the highest number of orders placed by a single customer, and the average
-- number per ordering customer?
-- Your answer:




-- Exercise 14.4  [Advanced]
-- Which orders have a gross value above the average order value?
-- Hint: Compute average order value in a derived table, then compare each order's total
-- with it in HAVING.
-- Your answer:





/* =====================================================================
   SECTION 15 | Mixed Business Challenges (optional / homework)
   Combines topics 1–14. Plan on paper first: what is the grain, which
   tables, which filter happens before and which after grouping?
   ===================================================================== */


-- Exercise 15.1  [Advanced]
-- Business question: Which Business-segment customers have spent more (gross) than the
-- average customer? Show CustomerID, name and total spend.
-- Hint: Break it down: (1) spend per customer, (2) average of that, (3) compare.
-- Your answer:




-- Exercise 15.2  [Advanced]
-- Business question: Which product categories have no product with stock left (all
-- products in the category are out of stock)? Ignore empty categories.
-- Your answer:




-- Exercise 15.3  [Advanced]
-- Business question: For each month of 2025, how many orders were placed and how many
-- of them were cancelled?
-- Hint: Preview of CASE: count a row as 1 if it matches, 0 otherwise, then SUM.
-- Your answer:




-- Exercise 15.4  [Advanced]
-- Business question: Which customers bought a product that is now discontinued?
-- Your answer:




-- Exercise 15.5  [Advanced]
-- Data-quality question: Are there orders whose ShippedDate is earlier than the
-- OrderDate, or Delivered/Shipped orders with no ShippedDate? (Expected: none.)
-- Your answer:




-- End of exercises.
