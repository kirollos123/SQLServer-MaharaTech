/* =====================================================================
   TechNovaDB: SQL Business Case Study, Instructor Script (NO ANSWERS)
   Database : TechNovaDB  (run 01_TechNovaDB_Setup.sql first)
   Topics   : 1 Subqueries | 2 JOINs | 3 CTEs | 4 Views | 5 Window Functions
              5 business questions per topic, 25 in total
   ---------------------------------------------------------------------
   Net Sales = Quantity x UnitPrice x (1 - Discount)
   (Discount is stored as a decimal fraction: 0.10 = 10%)
   Net sales include every order status (Cancelled too), as the brief
   gives no exclusion rule.
   ---------------------------------------------------------------------
   Under each question:
     Use     : Table(columns) the query needs
     Values  : stored values, ONLY when the query filters on a fixed value
     Concept : the technique, what it does, and its syntax
   Type each answer live with the class. Answers: 14_CaseStudy_Instructor_WithAnswers.sql
   Topic 4 creates 5 views (CREATE OR ALTER, safe to re-run).
   ===================================================================== */

USE TechNovaDB;
GO



/* =====================================================================
   TOPIC 1 | SUBQUERIES
   ---------------------------------------------------------------------
   A subquery is a query nested inside another SQL statement. It helps
   answer questions by comparing data against a calculated value or a
   set of results.

   Syntax
     SELECT columns
     FROM TableName
     WHERE column_name IN (
         SELECT column_name
         FROM AnotherTable
         WHERE condition
     );
   ===================================================================== */

-- Q1.1  Above-average product prices
-- Which products have a unit price higher than the average unit price of all products?
-- Display the product ID, product name, and unit price.
-- Use     : Products(ProductID, ProductName, UnitPrice)
-- Concept : Scalar subquery  inner SELECT returns ONE value used like a constant
--                            Syntax: WHERE col > (SELECT AVG(col) FROM t)




-- Q1.2  Customers with at least two orders
-- Which customers have placed two or more orders? Display their customer IDs, first
-- names, and last names. Use a subquery that groups orders by customer and filters
-- using HAVING COUNT(OrderID) >= 2.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(OrderID, CustomerID)
-- Concept : IN (subquery)      keep rows whose value is in the list the inner query returns
--                              Syntax: WHERE col IN (SELECT col FROM t2 ...)
--           GROUP BY + HAVING  group rows, then keep groups that meet an aggregate condition
--                              Syntax: GROUP BY col HAVING COUNT(col2) >= n




-- Q1.3  Customers who never ordered
-- Which registered customers have never placed an order? Display their IDs, names, and
-- cities. Use NOT EXISTS to identify customers without matching records in Orders.
-- Use     : Customers(CustomerID, FirstName, LastName, City);  Orders(CustomerID)
-- Concept : NOT EXISTS  TRUE when the correlated inner query finds no matching row; NULL-safe
--                       Syntax: WHERE NOT EXISTS (SELECT 1 FROM t2 AS b WHERE b.key = a.key)




-- Q1.4  Products priced above their category average
-- Which products have a unit price higher than the average price of products in the
-- same category? Display the product name, category ID, and unit price.
-- Use     : Products(ProductName, CategoryID, UnitPrice)
-- Concept : Correlated subquery  inner query uses the outer row, so it is evaluated per outer row
--                                Syntax: WHERE a.col > (SELECT AVG(b.col) FROM t AS b WHERE b.grp = a.grp)




-- Q1.5  Employees earning above the company average
-- Which employees have salaries higher than the average salary of all employees?
-- Display their names, departments, and salaries.
-- Use     : Employees(FirstName, LastName, Department, Salary)
-- Concept : Scalar subquery  inner SELECT returns ONE value used like a constant
--                            Syntax: WHERE col > (SELECT AVG(col) FROM t)





/* =====================================================================
   TOPIC 2 | JOINS
   ---------------------------------------------------------------------
   A JOIN combines records from related tables using matching columns.
   The four basic JOIN types differ in how they handle unmatched rows.

   Syntax
     SELECT a.Column1, b.Column2
     FROM TableA AS a
     INNER JOIN TableB AS b
         ON a.KeyColumn = b.KeyColumn;
   ===================================================================== */

-- Q2.1  INNER JOIN: Customers with orders
-- Display customers who have placed orders, including their customer IDs, full names,
-- and order IDs. Exclude customers without orders.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(OrderID, CustomerID)
-- Concept : INNER JOIN  keeps only rows that match in BOTH tables
--                       Syntax: FROM a INNER JOIN b ON b.key = a.key




-- Q2.2  LEFT JOIN: All customers
-- Display every customer and their order IDs, including customers who have never placed
-- an order. Show NULL for the order ID when no matching order exists.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(OrderID, CustomerID)
-- Concept : LEFT JOIN  keeps ALL rows of the left table; NULLs where the right side has no match
--                      Syntax: FROM a LEFT JOIN b ON b.key = a.key




-- Q2.3  RIGHT JOIN: All orders
-- Display every order with its associated customer details, including any orders
-- without a matching customer record. Use RIGHT JOIN to preserve every row from the
-- Orders table.
-- Use     : Customers(CustomerID, FirstName, LastName, City);  Orders(OrderID,
--           CustomerID, OrderDate)
-- Concept : RIGHT JOIN  keeps ALL rows of the right table; NULLs where the left side has no match
--                       Syntax: FROM a RIGHT JOIN b ON b.key = a.key




-- Q2.4  FULL OUTER JOIN: Compare customers and orders
-- Display all customers and all orders, including customers without orders and orders
-- without matching customer records. Identify unmatched records using the NULL values
-- in the corresponding table's columns.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(OrderID, CustomerID,
--           OrderDate)
-- Concept : FULL OUTER JOIN  keeps ALL rows of both tables; NULLs on whichever side has no match
--                            Syntax: FROM a FULL OUTER JOIN b ON b.key = a.key




-- Q2.5  Multi-table JOIN: Sales by product category
-- Calculate total net sales and total units sold for each product category by joining
-- Categories, Products, and OrderItems. Sort the results from highest to lowest net
-- sales.
-- Use     : Categories(CategoryID, CategoryName);  Products(ProductID, CategoryID);
--           OrderItems(ProductID, Quantity, UnitPrice, Discount)
-- Concept : Multi-table JOIN  chain joins table by table, each with its own ON condition
--                             Syntax: FROM a JOIN b ON ... JOIN c ON ...





/* =====================================================================
   TOPIC 3 | COMMON TABLE EXPRESSIONS (CTES)
   ---------------------------------------------------------------------
   A CTE is a named result set defined with WITH. It helps break a
   complex query into smaller, easier-to-understand steps.

   Syntax
     WITH CTE_Name AS (
         SELECT
             column1,
             aggregate_function(column2) AS Result
         FROM TableName
         GROUP BY column1
     )
     SELECT *
     FROM CTE_Name;
   ===================================================================== */

-- Q3.1  High-value customers
-- Calculate total net sales for each customer, then display customers whose total net
-- sales exceed 10,000. Show the customer ID, full name, and total sales.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(OrderID, CustomerID);
--           OrderItems(OrderID, Quantity, UnitPrice, Discount)
-- Concept : CTE (WITH)  names a result set so the next step can query it like a table
--                       Syntax: WITH name AS (SELECT ...) SELECT ... FROM name
--           INNER JOIN  keeps only rows that match in BOTH tables
--                       Syntax: FROM a INNER JOIN b ON b.key = a.key




-- Q3.2  Monthly sales analysis
-- Calculate total net sales for every month and year. Display the year, month, and
-- total sales, sorted chronologically.
-- Use     : Orders(OrderID, OrderDate);  OrderItems(OrderID, Quantity, UnitPrice,
--           Discount)
-- Concept : CTE (WITH)    names a result set so the next step can query it like a table
--                         Syntax: WITH name AS (SELECT ...) SELECT ... FROM name
--           YEAR / MONTH  extract the year or month number from a date for grouping
--                         Syntax: GROUP BY YEAR(d), MONTH(d)




-- Q3.3  Unsold products
-- Identify products that have never appeared in any order item. Display the product ID,
-- product name, and stock quantity. Use a CTE to identify sold products before finding
-- the unsold ones.
-- Use     : Products(ProductID, ProductName, StockQty);  OrderItems(ProductID)
-- Concept : CTE (WITH)  names a result set so the next step can query it like a table
--                       Syntax: WITH name AS (SELECT ...) SELECT ... FROM name
--           LEFT JOIN   keeps ALL rows of the left table; NULLs where the right side has no match
--                       Syntax: FROM a LEFT JOIN b ON b.key = a.key




-- Q3.4  Customer sales contribution
-- Calculate each customer's total net sales and determine what percentage of the
-- company's overall net sales they contribute. Display the customer ID, total sales,
-- and contribution percentage.
-- Use     : Orders(OrderID, CustomerID);  OrderItems(OrderID, Quantity, UnitPrice,
--           Discount)
-- Concept : CTE (WITH)       names a result set so the next step can query it like a table
--                            Syntax: WITH name AS (SELECT ...) SELECT ... FROM name
--           Scalar subquery  inner SELECT returns ONE value used like a constant
--                            Syntax: WHERE col > (SELECT AVG(col) FROM t)




-- Q3.5  Employees earning above their department average
-- Calculate the average salary for each department, then identify employees whose
-- salaries exceed their own department's average. Display employee names, departments,
-- individual salaries, and department averages.
-- Use     : Employees(FirstName, LastName, Department, Salary)
-- Concept : CTE (WITH)  names a result set so the next step can query it like a table
--                       Syntax: WITH name AS (SELECT ...) SELECT ... FROM name
--           INNER JOIN  keeps only rows that match in BOTH tables
--                       Syntax: FROM a INNER JOIN b ON b.key = a.key





/* =====================================================================
   TOPIC 4 | VIEWS
   ---------------------------------------------------------------------
   A View is a saved SQL query definition that can be queried like a
   table. It is useful for standardizing calculations and simplifying
   recurring reports.

   Syntax
     CREATE VIEW dbo.ViewName AS
     SELECT
         column1,
         column2
     FROM TableName;

     -- To use a View:
     SELECT *
     FROM dbo.ViewName;
   ===================================================================== */

-- Q4.1  Sales details View
-- Create a View named vw_SalesDetails that combines orders, customers, order items,
-- products, and categories. Include order ID, order date, customer name, product name,
-- category name, quantity, unit price, discount, and net sales. Then retrieve all
-- records from the View.
-- Use     : Categories(CategoryID, CategoryName);  Products(ProductID, ProductName,
--           CategoryID);  Customers(CustomerID, FirstName, LastName);  Orders(OrderID,
--           CustomerID, OrderDate);  OrderItems(OrderID, ProductID, Quantity,
--           UnitPrice, Discount)
-- Concept : CREATE VIEW       saves a SELECT as a named virtual table; must be the only statement in its batch
--                             Syntax: CREATE OR ALTER VIEW dbo.vw_Name AS SELECT ...;   -- then GO
--           Multi-table JOIN  chain joins table by table, each with its own ON condition
--                             Syntax: FROM a JOIN b ON ... JOIN c ON ...
--           Query a View      select from the view like a table; filter and sort OUTSIDE the view
--                             Syntax: SELECT * FROM dbo.vw_Name WHERE ... ORDER BY ...




-- Q4.2  Customer sales summary View
-- Create a View named vw_CustomerSales that shows every customer, their number of
-- orders, and their total net sales, including customers with no orders. Then retrieve
-- customers who have placed at least two orders, sorted by total sales in descending
-- order.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(OrderID, CustomerID);
--           OrderItems(OrderID, Quantity, UnitPrice, Discount)
-- Concept : CREATE VIEW      saves a SELECT as a named virtual table; must be the only statement in its batch
--                            Syntax: CREATE OR ALTER VIEW dbo.vw_Name AS SELECT ...;   -- then GO
--           LEFT JOIN        keeps ALL rows of the left table; NULLs where the right side has no match
--                            Syntax: FROM a LEFT JOIN b ON b.key = a.key
--           COUNT(DISTINCT)  counts unique values; needed when joins repeat a row per line
--                            Syntax: COUNT(DISTINCT o.OrderID)
--           Query a View     select from the view like a table; filter and sort OUTSIDE the view
--                            Syntax: SELECT * FROM dbo.vw_Name WHERE ... ORDER BY ...




-- Q4.3  Category performance View
-- Create a View named vw_CategorySales that displays each category's total net sales
-- and units sold. Then retrieve the categories ranked from highest to lowest sales.
-- Use     : Categories(CategoryID, CategoryName);  Products(ProductID, CategoryID);
--           OrderItems(ProductID, Quantity, UnitPrice, Discount)
-- Concept : CREATE VIEW   saves a SELECT as a named virtual table; must be the only statement in its batch
--                         Syntax: CREATE OR ALTER VIEW dbo.vw_Name AS SELECT ...;   -- then GO
--           LEFT JOIN     keeps ALL rows of the left table; NULLs where the right side has no match
--                         Syntax: FROM a LEFT JOIN b ON b.key = a.key
--           Query a View  select from the view like a table; filter and sort OUTSIDE the view
--                         Syntax: SELECT * FROM dbo.vw_Name WHERE ... ORDER BY ...




-- Q4.4  Employee performance View
-- Create a View named vw_EmployeePerformance that shows each employee's ID, full name,
-- department, number of orders handled, and total net sales. Include employees with
-- zero orders. Then retrieve employees who have handled at least two orders.
-- Use     : Employees(EmployeeID, FirstName, LastName, Department);  Orders(OrderID,
--           EmployeeID);  OrderItems(OrderID, Quantity, UnitPrice, Discount)
-- Concept : CREATE VIEW      saves a SELECT as a named virtual table; must be the only statement in its batch
--                            Syntax: CREATE OR ALTER VIEW dbo.vw_Name AS SELECT ...;   -- then GO
--           LEFT JOIN        keeps ALL rows of the left table; NULLs where the right side has no match
--                            Syntax: FROM a LEFT JOIN b ON b.key = a.key
--           COUNT(DISTINCT)  counts unique values; needed when joins repeat a row per line
--                            Syntax: COUNT(DISTINCT o.OrderID)
--           Query a View     select from the view like a table; filter and sort OUTSIDE the view
--                            Syntax: SELECT * FROM dbo.vw_Name WHERE ... ORDER BY ...




-- Q4.5  Monthly sales View
-- Create a View named vw_MonthlySales that contains the year, month, and total net
-- sales for each month with recorded sales. Then query the View to display monthly
-- sales in chronological order.
-- Use     : Orders(OrderID, OrderDate);  OrderItems(OrderID, Quantity, UnitPrice,
--           Discount)
-- Concept : CREATE VIEW   saves a SELECT as a named virtual table; must be the only statement in its batch
--                         Syntax: CREATE OR ALTER VIEW dbo.vw_Name AS SELECT ...;   -- then GO
--           YEAR / MONTH  extract the year or month number from a date for grouping
--                         Syntax: GROUP BY YEAR(d), MONTH(d)
--           Query a View  select from the view like a table; filter and sort OUTSIDE the view
--                         Syntax: SELECT * FROM dbo.vw_Name WHERE ... ORDER BY ...





/* =====================================================================
   TOPIC 5 | WINDOW FUNCTIONS
   ---------------------------------------------------------------------
   Window functions perform calculations across related rows without
   collapsing the individual rows into a single row per group.

   Syntax
     SELECT
         column1,
         window_function() OVER (
             PARTITION BY group_column
             ORDER BY sort_column
         ) AS Result
     FROM TableName;
   ===================================================================== */

-- Q5.1  Customer sales ranking
-- Calculate each customer's total net sales and rank customers from highest to lowest
-- sales. Display the customer ID, total sales, and sales rank. Use RANK().
-- Use     : Orders(OrderID, CustomerID);  OrderItems(OrderID, Quantity, UnitPrice,
--           Discount)
-- Concept : CTE (WITH)  names a result set so the next step can query it like a table
--                       Syntax: WITH name AS (SELECT ...) SELECT ... FROM name
--           RANK()      rank with gaps after ties (1, 2, 2, 4)
--                       Syntax: RANK() OVER (ORDER BY col DESC)




-- Q5.2  Top-priced products per category
-- Rank products by unit price within each category and return the top three price ranks
-- per category. Display the product name, category ID, unit price, and rank. Use
-- DENSE_RANK().
-- Use     : Products(ProductName, CategoryID, UnitPrice)
-- Concept : DENSE_RANK()  rank without gaps after ties (1, 2, 2, 3)
--                         Syntax: DENSE_RANK() OVER (PARTITION BY grp ORDER BY col DESC)
--           CTE (WITH)    names a result set so the next step can query it like a table
--                         Syntax: WITH name AS (SELECT ...) SELECT ... FROM name




-- Q5.3  Cumulative monthly sales
-- Calculate total net sales per month and year, then calculate cumulative sales from
-- the beginning of each year through each month. Display monthly sales and cumulative
-- sales.
-- Use     : Orders(OrderID, OrderDate);  OrderItems(OrderID, Quantity, UnitPrice,
--           Discount)
-- Concept : CTE (WITH)                  names a result set so the next step can query it like a table
--                                       Syntax: WITH name AS (SELECT ...) SELECT ... FROM name
--           SUM() OVER (running total)  cumulative total in order, restarting per partition
--                                       Syntax: SUM(x) OVER (PARTITION BY grp ORDER BY o ROWS UNBOUNDED PRECEDING)




-- Q5.4  Month-over-month sales comparison
-- Calculate monthly net sales and compare each month with the previous month. Display
-- the current month's sales, previous month's sales, and the difference between them.
-- Use LAG().
-- Use     : Orders(OrderID, OrderDate);  OrderItems(OrderID, Quantity, UnitPrice,
--           Discount)
-- Concept : CTE (WITH)  names a result set so the next step can query it like a table
--                       Syntax: WITH name AS (SELECT ...) SELECT ... FROM name
--           LAG()       value from the previous row in the window order
--                       Syntax: LAG(x) OVER (ORDER BY o)




-- Q5.5  Employee salary comparison
-- Display every employee's name, department, and salary alongside the average salary of
-- their department and the difference between the employee's salary and that average.
-- Use AVG() OVER (PARTITION BY Department).
-- Use     : Employees(FirstName, LastName, Department, Salary)
-- Concept : AVG() OVER (PARTITION BY)  group average shown on every row without collapsing rows
--                                      Syntax: AVG(x) OVER (PARTITION BY grp)




-- End of instructor script.
