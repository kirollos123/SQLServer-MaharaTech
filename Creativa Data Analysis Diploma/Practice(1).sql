/* =====================================================================
   TechNovaDB: Concept Practice (NO ANSWERS)
   Database : TechNovaDB  (run 01_TechNovaDB_Setup.sql first)
   ---------------------------------------------------------------------
   20 business questions that together cover all 40 concepts of the
   session. Each concept is practised in exactly ONE question; a question
   may combine 2-3 concepts. "Covers" names the concepts it practises.

   Under each question:
     Use     : Table(columns) the query needs
     Values  : stored values, ONLY when the query filters on a fixed
               value or tests for NULL
   Write your query under "Your answer". Answers: 10_Concept_Practice_WithAnswers.sql
   ---------------------------------------------------------------------
   COVERAGE MAP (concept -> question)
     SELECT / FROM        Q1       TOP                  Q11
     SELECT *             Q2       WITH TIES            Q11
     AS                   Q3       COUNT(*)             Q12
     Calculated column    Q3       COUNT(column)        Q12
     + (text)             Q3       COUNT(DISTINCT)      Q12
     DISTINCT             Q4       SUM                  Q13
     ORDER BY             Q4       AVG                  Q13
     WHERE                Q5       MIN / MAX            Q13
     AND / OR             Q5       GROUP BY             Q14
     OR                   Q6       YEAR / MONTH         Q14
     <>                   Q6       HAVING               Q15
     AND                  Q7       CASE                 Q15
     BETWEEN              Q7       Scalar subquery      Q16
     IN (list)            Q7       IN (subquery)        Q17
     LIKE                 Q8       NOT IN (subquery)    Q17
     NOT IN (list)        Q8       Correlated subquery  Q18
     IS NULL              Q9       Table alias          Q18
     COALESCE             Q9       EXISTS               Q19
     IS NOT NULL          Q10      NOT EXISTS           Q19
     ISNULL               Q10      Derived table        Q20
   ===================================================================== */

USE TechNovaDB;
GO



/* =====================================================================
   PART 1 | RETRIEVE: choosing columns
   ===================================================================== */

-- Q1  [Basic]   Covers: SELECT / FROM
-- The catalogue team needs a list of all product category names.
-- Use     : Categories(CategoryName)
-- Your answer:




-- Q2  [Basic]   Covers: SELECT *
-- HR wants a full export of all employee details.
-- Use     : Employees
-- Your answer:




-- Q3  [Basic]   Covers: AS, Calculated column, + (text)
-- HR needs a staff list with each employee's full name in one column titled 'Employee
-- Name', their job title, and their annual salary (12 months).
-- Use     : Employees(FirstName, LastName, JobTitle, Salary)
-- Your answer:




-- Q4  [Basic]   Covers: DISTINCT, ORDER BY
-- Which job titles do we have in the company? List each one once, alphabetically.
-- Use     : Employees(JobTitle)
-- Your answer:





/* =====================================================================
   PART 2 | FILTER: choosing rows
   ===================================================================== */

-- Q5  [Basic]   Covers: WHERE, AND / OR
-- Which Business customers live in Giza or Mansoura?
-- Use     : Customers(FirstName, LastName, City, Segment)
-- Values  : Customers.City = Alexandria | Cairo | Giza | Mansoura | Tanta | NULL
-- Values  : Customers.Segment = Business | Consumer
-- Your answer:




-- Q6  [Basic]   Covers: OR, <>
-- Which employees either work outside the Sales department or earn more than 40,000 EGP
-- a month?
-- Use     : Employees(FirstName, LastName, Department, Salary)
-- Values  : Employees.Department = Management | Sales | Support
-- Your answer:




-- Q7  [Intermediate]   Covers: AND, BETWEEN, IN (list)
-- Which Nova or Zenix products did we launch during 2024?
-- Use     : Products(ProductName, Brand, LaunchDate)
-- Values  : Products.Brand = Nova | Orbit | Zenix | NULL
-- Your answer:




-- Q8  [Intermediate]   Covers: LIKE, NOT IN (list)
-- Find customers whose last name starts with 'S' and who live outside Cairo and
-- Alexandria.
-- Use     : Customers(FirstName, LastName, City)
-- Values  : Customers.City = Alexandria | Cairo | Giza | Mansoura | Tanta | NULL
-- Your answer:




-- Q9  [Intermediate]   Covers: IS NULL, COALESCE
-- Some customers have no email address. For each of them, show how we can reach them:
-- their phone number, or 'No contact' if they have no phone either.
-- Use     : Customers(FirstName, LastName, Email, Phone)
-- Values  : Customers.Email: NULL in 3 of 20 rows
-- Values  : Customers.Phone: NULL in 3 of 20 rows
-- Your answer:




-- Q10  [Intermediate]   Covers: IS NOT NULL, ISNULL
-- For every employee who has a manager, show their name and commission rate, with 0 for
-- staff not on commission.
-- Use     : Employees(FirstName, LastName, Commission, ManagerID)
-- Values  : Employees.Commission: a rate: 0.05 = 5%; NULL = not on commission
-- Values  : Employees.ManagerID: NULL = the General Manager (no manager)
-- Your answer:




-- Q11  [Intermediate]   Covers: TOP, WITH TIES
-- Which order lines are in the top 3 by quantity? Include any lines tied with third
-- place.
-- Use     : OrderItems(OrderItemID, OrderID, ProductID, Quantity)
-- Your answer:





/* =====================================================================
   PART 3 | SUMMARIZE: from rows to answers
   ===================================================================== */

-- Q12  [Intermediate]   Covers: COUNT(*), COUNT(column), COUNT(DISTINCT)
-- Order overview: how many orders do we have, how many of them have shipped, and how
-- many different customers placed them?
-- Use     : Orders(CustomerID, ShippedDate)
-- Your answer:




-- Q13  [Intermediate]   Covers: SUM, AVG, MIN / MAX
-- Payroll summary: what is the total monthly payroll, the average salary, and the
-- lowest and highest salary?
-- Use     : Employees(Salary)
-- Your answer:




-- Q14  [Intermediate]   Covers: GROUP BY, YEAR / MONTH
-- How many orders did we receive in each month? Show the year and month in date order.
-- Use     : Orders(OrderDate)
-- Your answer:




-- Q15  [Advanced]   Covers: HAVING, CASE
-- Which customers placed at least 2 orders? Label customers with 4 or more orders 'Key
-- account' and the rest 'Regular'.
-- Use     : Orders(CustomerID)
-- Your answer:





/* =====================================================================
   PART 4 | NEST: queries inside queries
   ===================================================================== */

-- Q16  [Intermediate]   Covers: Scalar subquery
-- Which products are priced above the average product price?
-- Use     : Products(ProductName, UnitPrice)
-- Your answer:




-- Q17  [Advanced]   Covers: IN (subquery), NOT IN (subquery)
-- Which customers have ordered from us but never had an order cancelled?
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(CustomerID, Status)
-- Values  : Orders.Status = Cancelled | Delivered | Pending | Shipped
-- Your answer:




-- Q18  [Advanced]   Covers: Correlated subquery, Table alias
-- What is the cheapest product in each category?
-- Use     : Products(ProductName, CategoryID, UnitPrice)
-- Your answer:




-- Q19  [Advanced]   Covers: EXISTS, NOT EXISTS
-- Which customers have ordered online but never in a store?
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(CustomerID, Channel)
-- Values  : Orders.Channel = Online | Store
-- Your answer:




-- Q20  [Advanced]   Covers: Derived table
-- What is the average value of an order? (An order is worth the sum of Quantity x
-- UnitPrice over its lines.)
-- Use     : OrderItems(OrderID, Quantity, UnitPrice)
-- Your answer:




-- End of concept practice.
