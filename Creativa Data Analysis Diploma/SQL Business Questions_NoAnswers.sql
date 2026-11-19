/* =====================================================================
   TechNovaDB — Instructor Demonstration Script (live-coding version, no answers)
   Database : TechNovaDB  (run 01_TechNovaDB_Setup.sql first)
   Scope    : SELECT → DISTINCT → WHERE → BETWEEN/IN/LIKE → NULL →
              ORDER BY/TOP → Aggregates → GROUP BY → HAVING →
              Scalar / Multi-row / Correlated subqueries → EXISTS →
              Derived tables
   ---------------------------------------------------------------------
   Project this file and type each query live with the class.
   Each task follows the matching deck topic. Ask trainees to predict
   the result before you press F5.
   Under each task, memory-aid lines:
     Use     : Table(columns) the query needs
     Values  : stored values, shown ONLY when the query filters on a
               fixed value or tests for NULL
     Concept : SQL keywords the answer uses + what each one does,
               with a Syntax: pattern under each
     Full syntax reference by topic: 08_SQL_Syntax_Reference.sql
   How to run one query: highlight it, then press F5 (Execute).
   ===================================================================== */

USE TechNovaDB;
GO



/* =====================================================================
   SECTION 01 | SELECT & FROM — Retrieving Columns
   Deck topic 1 (slides 6–9)
   Goal: Choose which columns to return, rename them with aliases, and create calculated columns.
   ===================================================================== */


-- D1.1
-- Look at the whole Products table so we know what we are working with.
-- Use     : Products
-- Concept : SELECT *  returns every column of the table
--                     Syntax: SELECT * FROM <table>;




-- D1.2
-- Show only the product name and its price.
-- Use     : Products(ProductName, UnitPrice)
-- Concept : SELECT / FROM  SELECT lists the columns to return; FROM names the table
--                          Syntax: SELECT <col1>, <col2> FROM <table>;




-- D1.3
-- Show each customer's first name and last name with friendlier headers: 'First Name'
-- and 'Last Name'.
-- Use     : Customers(FirstName, LastName)
-- Concept : AS  gives a column or calculation a name in the result
--               Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]




-- D1.4
-- For every product, show its name, price, and the price including 14% VAT (call it
-- PriceWithVAT).
-- Use     : Products(ProductName, UnitPrice)
-- Concept : AS                 gives a column or calculation a name in the result
--                              Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           Calculated column  an expression worked out for each row; it is not stored in the table
--                              Syntax: SELECT <col1> * <col2> AS <alias> FROM <table>;




-- D1.5
-- Show each order line's total value before discount: Quantity × UnitPrice.
-- Use     : OrderItems(OrderItemID, OrderID, Quantity, UnitPrice)
-- Concept : AS                 gives a column or calculation a name in the result
--                              Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           Calculated column  an expression worked out for each row; it is not stored in the table
--                              Syntax: SELECT <col1> * <col2> AS <alias> FROM <table>;





/* =====================================================================
   SECTION 02 | DISTINCT — Removing Duplicate Rows
   Deck topic 2 (slides 10–12)
   Goal: Return each unique value (or combination of values) once.
   ===================================================================== */


-- D2.1
-- Which cities do our customers come from? First try without DISTINCT, then with it.
-- Use     : Customers(City)
-- Concept : DISTINCT  removes duplicate rows; compares ALL selected columns together
--                     Syntax: SELECT DISTINCT <col1> [, <col2>] FROM <table>;




-- D2.2
-- Which brands do we sell?
-- Use     : Products(Brand)
-- Concept : DISTINCT  removes duplicate rows; compares ALL selected columns together
--                     Syntax: SELECT DISTINCT <col1> [, <col2>] FROM <table>;




-- D2.3
-- Which combinations of Channel and Status exist in Orders?
-- Use     : Orders(Status, Channel)
-- Concept : DISTINCT  removes duplicate rows; compares ALL selected columns together
--                     Syntax: SELECT DISTINCT <col1> [, <col2>] FROM <table>;





/* =====================================================================
   SECTION 03 | WHERE — Filtering Rows with Conditions
   Deck topic 3 (slides 14–17)
   Goal: Keep only the rows that meet a condition, using comparison and logical operators.
   ===================================================================== */


-- D3.1
-- Show products that cost more than 20,000 EGP.
-- Use     : Products(ProductName, UnitPrice)
-- Concept : WHERE  keeps only rows where the condition is TRUE (row filter)
--                  Syntax: SELECT <cols> FROM <table> WHERE <condition>;




-- D3.2
-- Show all customers who live in Alexandria.
-- Use     : Customers(CustomerID, FirstName, LastName, City)
-- Values  : Customers.City = Alexandria | Cairo | Giza | Mansoura | Tanta | NULL
-- Concept : WHERE  keeps only rows where the condition is TRUE (row filter)
--                  Syntax: SELECT <cols> FROM <table> WHERE <condition>;




-- D3.3
-- Show orders placed on or after 1 January 2026.
-- Use     : Orders(OrderID, OrderDate, Status)
-- Values  : Orders.OrderDate: DATE, write as 'YYYY-MM-DD'; data runs 2025-01-10 to
--           2026-06-10
-- Concept : WHERE  keeps only rows where the condition is TRUE (row filter)
--                  Syntax: SELECT <cols> FROM <table> WHERE <condition>;




-- D3.4
-- Show Store orders that are Delivered.
-- Use     : Orders(OrderID, Status, Channel)
-- Values  : Orders.Status = Cancelled | Delivered | Pending | Shipped
-- Values  : Orders.Channel = Online | Store
-- Concept : WHERE  keeps only rows where the condition is TRUE (row filter)
--                  Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           AND    every condition must be TRUE
--                  Syntax: WHERE <condition1> AND <condition2>




-- D3.5
-- Show products that are out of stock OR discontinued.
-- Use     : Products(ProductName, StockQty, Discontinued)
-- Values  : Products.Discontinued: 1 = discontinued, 0 = still sold
-- Concept : WHERE  keeps only rows where the condition is TRUE (row filter)
--                  Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           OR     at least one condition must be TRUE
--                  Syntax: WHERE <condition1> OR <condition2>




-- D3.6
-- Precedence trap: Nova or Zenix products that cost more than 30,000. Run the wrong
-- version first, then fix it with parentheses.
-- Use     : Products(ProductName, Brand, UnitPrice)
-- Values  : Products.Brand = Nova | Orbit | Zenix | NULL
-- Concept : WHERE     keeps only rows where the condition is TRUE (row filter)
--                     Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           AND / OR  mixing them: AND runs before OR, so group with ( )
--                     Syntax: WHERE (<condition1> OR <condition2>) AND <condition3>





/* =====================================================================
   SECTION 04 | BETWEEN, IN & LIKE — Special Filter Operators
   Deck topic 4 (slides 18–20)
   Goal: Filter by ranges, lists of values, and text patterns.
   ===================================================================== */


-- D4.1
-- Products priced between 5,000 and 20,000 EGP (inclusive).
-- Use     : Products(ProductName, UnitPrice)
-- Concept : WHERE    keeps only rows where the condition is TRUE (row filter)
--                    Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           BETWEEN  inclusive range: low AND high are both included; low value first
--                    Syntax: WHERE <column> BETWEEN <low> AND <high>




-- D4.2
-- Orders placed in the first quarter of 2026.
-- Use     : Orders(OrderID, OrderDate)
-- Values  : Orders.OrderDate: DATE, write as 'YYYY-MM-DD'; data runs 2025-01-10 to
--           2026-06-10
-- Concept : WHERE    keeps only rows where the condition is TRUE (row filter)
--                    Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           BETWEEN  inclusive range: low AND high are both included; low value first
--                    Syntax: WHERE <column> BETWEEN <low> AND <high>




-- D4.3
-- Customers from Cairo, Giza or Alexandria.
-- Use     : Customers(FirstName, LastName, City)
-- Values  : Customers.City = Alexandria | Cairo | Giza | Mansoura | Tanta | NULL
-- Concept : WHERE      keeps only rows where the condition is TRUE (row filter)
--                      Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           IN (list)  matches any value in the list; short for several = joined by OR
--                      Syntax: WHERE <column> IN (<value1>, <value2>, ...)




-- D4.4
-- Products whose name starts with 'Nova'.
-- Use     : Products(ProductName)
-- Concept : WHERE  keeps only rows where the condition is TRUE (row filter)
--                  Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           LIKE   text pattern: % = any characters, _ = exactly one character
--                  Syntax: WHERE <column> LIKE '<pattern>'     -- % = any chars, _ = one char




-- D4.5
-- Products whose name contains 'USB' anywhere.
-- Use     : Products(ProductName)
-- Concept : WHERE  keeps only rows where the condition is TRUE (row filter)
--                  Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           LIKE   text pattern: % = any characters, _ = exactly one character
--                  Syntax: WHERE <column> LIKE '<pattern>'     -- % = any chars, _ = one char




-- D4.6
-- Customers whose first name has exactly 4 letters.
-- Use     : Customers(FirstName)
-- Concept : WHERE  keeps only rows where the condition is TRUE (row filter)
--                  Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           LIKE   text pattern: % = any characters, _ = exactly one character
--                  Syntax: WHERE <column> LIKE '<pattern>'     -- % = any chars, _ = one char





/* =====================================================================
   SECTION 05 | NULL — Working with Missing Values
   Deck topic 5 (slides 21–25)
   Goal: Find, exclude and replace missing values correctly.
   ===================================================================== */


-- D5.1
-- Find customers with no email. First try = NULL (returns nothing), then IS NULL.
-- Use     : Customers(FirstName, LastName, Email)
-- Values  : Customers.Email: NULL in 3 of 20 rows
-- Concept : WHERE    keeps only rows where the condition is TRUE (row filter)
--                    Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           IS NULL  the only correct test for a missing value (= NULL never matches)
--                    Syntax: WHERE <column> IS NULL




-- D5.2
-- Find orders that have shipped (ShippedDate is filled).
-- Use     : Orders(OrderID, ShippedDate, Status)
-- Values  : Orders.ShippedDate: NULL = Pending or Cancelled
-- Concept : WHERE        keeps only rows where the condition is TRUE (row filter)
--                        Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           IS NOT NULL  keeps rows where the value is present
--                        Syntax: WHERE <column> IS NOT NULL




-- D5.3
-- Show every product with its brand; display 'Generic' instead of NULL.
-- Use     : Products(ProductName, Brand)
-- Values  : Products.Brand = Nova | Orbit | Zenix | NULL
-- Concept : AS      gives a column or calculation a name in the result
--                   Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           ISNULL  ISNULL(x, y) returns y when x is NULL (SQL Server, 2 arguments)
--                   Syntax: ISNULL(<column>, <replacement>)




-- D5.4
-- Show each employee's commission rate, treating NULL as 0.
-- Use     : Employees(FirstName, LastName, Commission)
-- Values  : Employees.Commission: a rate: 0.05 = 5%; NULL = not on commission
-- Concept : COALESCE  returns the first non-NULL value from a list (standard SQL)
--                     Syntax: COALESCE(<value1>, <value2>, ..., <fallback>)




-- D5.5
-- Show a contact for each customer: Email if available, else Phone, else 'No contact'.
-- Use     : Customers(FirstName, LastName, Email, Phone)
-- Values  : Customers.Email: NULL in 3 of 20 rows
-- Values  : Customers.Phone: NULL in 3 of 20 rows
-- Concept : COALESCE  returns the first non-NULL value from a list (standard SQL)
--                     Syntax: COALESCE(<value1>, <value2>, ..., <fallback>)




-- D5.6
-- The <> trap: customers not in Cairo. Count the rows, then add the NULL city back
-- explicitly.
-- Use     : Customers(FirstName, City)
-- Values  : Customers.City = Alexandria | Cairo | Giza | Mansoura | Tanta | NULL
-- Concept : WHERE    keeps only rows where the condition is TRUE (row filter)
--                    Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           OR       at least one condition must be TRUE
--                    Syntax: WHERE <condition1> OR <condition2>
--           <>       not equal; rows where the column is NULL are dropped too
--                    Syntax: WHERE <column> <> <value>
--           IS NULL  the only correct test for a missing value (= NULL never matches)
--                    Syntax: WHERE <column> IS NULL





/* =====================================================================
   SECTION 06 | ORDER BY & TOP — Sorting and Limiting Results
   Deck topic 6 (slides 26–28)
   Goal: Sort results by one or more columns and return only the first N rows.
   ===================================================================== */


-- D6.1
-- Products from most to least expensive.
-- Use     : Products(ProductName, UnitPrice)
-- Concept : ORDER BY  sorts the final result; ASC is default, DESC = largest first
--                     Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D6.2
-- Customers sorted by city, then by last name within each city.
-- Use     : Customers(FirstName, LastName, City)
-- Concept : ORDER BY  sorts the final result; ASC is default, DESC = largest first
--                     Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D6.3
-- Sort by a calculated column using its alias.
-- Use     : Products(ProductName, UnitPrice, StockQty)
-- Concept : AS                 gives a column or calculation a name in the result
--                              Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           Calculated column  an expression worked out for each row; it is not stored in the table
--                              Syntax: SELECT <col1> * <col2> AS <alias> FROM <table>;
--           ORDER BY           sorts the final result; ASC is default, DESC = largest first
--                              Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D6.4
-- The 3 most expensive products.
-- Use     : Products(ProductName, UnitPrice)
-- Concept : TOP       returns the first N rows of the sorted result (needs ORDER BY)
--                     Syntax: SELECT TOP (<n>) <cols> FROM <table> ORDER BY <col> DESC;
--           ORDER BY  sorts the final result; ASC is default, DESC = largest first
--                     Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D6.5
-- The 5 most recent orders, including ties on the last date.
-- Use     : Orders(OrderID, OrderDate)
-- Concept : TOP        returns the first N rows of the sorted result (needs ORDER BY)
--                      Syntax: SELECT TOP (<n>) <cols> FROM <table> ORDER BY <col> DESC;
--           WITH TIES  TOP also returns rows tied with the last row
--                      Syntax: SELECT TOP (<n>) WITH TIES <cols> FROM <table> ORDER BY <col>;
--           ORDER BY   sorts the final result; ASC is default, DESC = largest first
--                      Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]





/* =====================================================================
   SECTION 07 | Aggregate Functions — Summarizing Many Rows
   Deck topic 7 (slides 30–33)
   Goal: Reduce many rows to one value with COUNT, SUM, AVG, MIN and MAX.
   ===================================================================== */


-- D7.1
-- How many customers do we have?
-- Use     : Customers
-- Concept : COUNT(*)  counts rows, including rows with NULLs
--                     Syntax: SELECT COUNT(*) FROM <table>;




-- D7.2
-- COUNT(*) vs COUNT(column) vs COUNT(DISTINCT column) on Customers.
-- Use     : Customers(Email, City)
-- Concept : COUNT(*)         counts rows, including rows with NULLs
--                            Syntax: SELECT COUNT(*) FROM <table>;
--           COUNT(column)    counts non-NULL values in the column
--                            Syntax: SELECT COUNT(<column>) FROM <table>;
--           COUNT(DISTINCT)  counts unique non-NULL values
--                            Syntax: SELECT COUNT(DISTINCT <column>) FROM <table>;




-- D7.3
-- Total units sold and total gross sales value.
-- Use     : OrderItems(Quantity, UnitPrice)
-- Concept : SUM  adds up values; ignores NULLs
--                Syntax: SELECT SUM(<column or expression>) FROM <table>;




-- D7.4
-- Lowest, highest and average product price.
-- Use     : Products(UnitPrice)
-- Concept : AVG        average of non-NULL values; on INT columns the result is INT
--                      Syntax: SELECT AVG(<column>) FROM <table>;     -- AVG(<int_col> * 1.0) for decimals
--           MIN / MAX  smallest / largest value (numbers, dates or text)
--                      Syntax: SELECT MIN(<column>), MAX(<column>) FROM <table>;




-- D7.5
-- The AVG + NULL trap: average commission rate. Compare AVG(Commission) with
-- AVG(ISNULL(Commission, 0)).
-- Use     : Employees(Commission)
-- Values  : Employees.Commission: a rate: 0.05 = 5%; NULL = not on commission
-- Concept : AVG     average of non-NULL values; on INT columns the result is INT
--                   Syntax: SELECT AVG(<column>) FROM <table>;     -- AVG(<int_col> * 1.0) for decimals
--           ISNULL  ISNULL(x, y) returns y when x is NULL (SQL Server, 2 arguments)
--                   Syntax: ISNULL(<column>, <replacement>)




-- D7.6
-- Aggregates respect WHERE: how many Delivered orders, and what is the first and last
-- order date among them?
-- Use     : Orders(OrderDate, Status)
-- Values  : Orders.Status = Cancelled | Delivered | Pending | Shipped
-- Concept : COUNT(*)   counts rows, including rows with NULLs
--                      Syntax: SELECT COUNT(*) FROM <table>;
--           MIN / MAX  smallest / largest value (numbers, dates or text)
--                      Syntax: SELECT MIN(<column>), MAX(<column>) FROM <table>;
--           WHERE      keeps only rows where the condition is TRUE (row filter)
--                      Syntax: SELECT <cols> FROM <table> WHERE <condition>;





/* =====================================================================
   SECTION 08 | GROUP BY — Summarizing per Group
   Deck topic 8 (slides 34–38)
   Goal: Split rows into groups and calculate one summary row per group.
   ===================================================================== */


-- D8.1
-- How many products are in each category?
-- Use     : Products(CategoryID)
-- Concept : COUNT(*)  counts rows, including rows with NULLs
--                     Syntax: SELECT COUNT(*) FROM <table>;
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;




-- D8.2
-- How many orders per status?
-- Use     : Orders(Status)
-- Concept : COUNT(*)  counts rows, including rows with NULLs
--                     Syntax: SELECT COUNT(*) FROM <table>;
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;




-- D8.3
-- Common mistake: add ProductName to the SELECT. Run it and read the error.
-- Use     : Products(ProductName, CategoryID)
-- Concept : COUNT(*)  counts rows, including rows with NULLs
--                     Syntax: SELECT COUNT(*) FROM <table>;
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;




-- D8.4
-- Average, min and max price per brand.
-- Use     : Products(Brand, UnitPrice)
-- Concept : COUNT(*)   counts rows, including rows with NULLs
--                      Syntax: SELECT COUNT(*) FROM <table>;
--           AVG        average of non-NULL values; on INT columns the result is INT
--                      Syntax: SELECT AVG(<column>) FROM <table>;     -- AVG(<int_col> * 1.0) for decimals
--           MIN / MAX  smallest / largest value (numbers, dates or text)
--                      Syntax: SELECT MIN(<column>), MAX(<column>) FROM <table>;
--           GROUP BY   one result row per group; SELECT only grouped or aggregated columns
--                      Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;




-- D8.5
-- Orders per Channel and Status (grouping by two columns).
-- Use     : Orders(Status, Channel)
-- Concept : COUNT(*)  counts rows, including rows with NULLs
--                     Syntax: SELECT COUNT(*) FROM <table>;
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;
--           ORDER BY  sorts the final result; ASC is default, DESC = largest first
--                     Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D8.6
-- Units sold and gross sales per product, best sellers first.
-- Use     : OrderItems(ProductID, Quantity, UnitPrice)
-- Concept : AS        gives a column or calculation a name in the result
--                     Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           SUM       adds up values; ignores NULLs
--                     Syntax: SELECT SUM(<column or expression>) FROM <table>;
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;
--           ORDER BY  sorts the final result; ASC is default, DESC = largest first
--                     Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]





/* =====================================================================
   SECTION 09 | HAVING — Filtering Groups (WHERE vs HAVING)
   Deck topic 9 (slides 39–42)
   Goal: Filter groups after aggregation, and understand the logical processing order.
   ===================================================================== */


-- D9.1
-- Categories that have more than 3 products.
-- Use     : Products(CategoryID)
-- Concept : COUNT(*)  counts rows, including rows with NULLs
--                     Syntax: SELECT COUNT(*) FROM <table>;
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;
--           HAVING    filters groups after GROUP BY; can use aggregates
--                     Syntax: GROUP BY <col> HAVING <AGG>(<col2>) <operator> <value>




-- D9.2
-- Common mistake: put the aggregate in WHERE. Run it and read the error.
-- Use     : Products(CategoryID)
-- Concept : COUNT(*)  counts rows, including rows with NULLs
--                     Syntax: SELECT COUNT(*) FROM <table>;
--           WHERE     keeps only rows where the condition is TRUE (row filter)
--                     Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;




-- D9.3
-- WHERE and HAVING together: among non-cancelled orders, customers with 3 or more
-- orders.
-- Use     : Orders(CustomerID, Status)
-- Values  : Orders.Status = Cancelled | Delivered | Pending | Shipped
-- Concept : COUNT(*)  counts rows, including rows with NULLs
--                     Syntax: SELECT COUNT(*) FROM <table>;
--           WHERE     keeps only rows where the condition is TRUE (row filter)
--                     Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           <>        not equal; rows where the column is NULL are dropped too
--                     Syntax: WHERE <column> <> <value>
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;
--           HAVING    filters groups after GROUP BY; can use aggregates
--                     Syntax: GROUP BY <col> HAVING <AGG>(<col2>) <operator> <value>
--           ORDER BY  sorts the final result; ASC is default, DESC = largest first
--                     Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D9.4
-- Products whose total units sold exceed 5.
-- Use     : OrderItems(ProductID, Quantity)
-- Concept : AS        gives a column or calculation a name in the result
--                     Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           SUM       adds up values; ignores NULLs
--                     Syntax: SELECT SUM(<column or expression>) FROM <table>;
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;
--           HAVING    filters groups after GROUP BY; can use aggregates
--                     Syntax: GROUP BY <col> HAVING <AGG>(<col2>) <operator> <value>
--           ORDER BY  sorts the final result; ASC is default, DESC = largest first
--                     Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D9.5
-- Processing-order demo: the alias works in ORDER BY but not in HAVING or WHERE.
-- Use     : OrderItems(ProductID, Quantity)
-- Concept : AS        gives a column or calculation a name in the result
--                     Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           SUM       adds up values; ignores NULLs
--                     Syntax: SELECT SUM(<column or expression>) FROM <table>;
--           GROUP BY  one result row per group; SELECT only grouped or aggregated columns
--                     Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;
--           HAVING    filters groups after GROUP BY; can use aggregates
--                     Syntax: GROUP BY <col> HAVING <AGG>(<col2>) <operator> <value>





/* =====================================================================
   SECTION 10 | Scalar Subqueries — One Value Inside Another Query
   Deck topic 10 (slides 44–47)
   Goal: Use a query that returns exactly one value as part of a condition or a column.
   ===================================================================== */


-- D10.1
-- Step 1: what is the average product price? Step 2: which products cost more than
-- that? Then combine into one query.
-- Use     : Products(ProductName, UnitPrice)
-- Concept : AVG              average of non-NULL values; on INT columns the result is INT
--                            Syntax: SELECT AVG(<column>) FROM <table>;     -- AVG(<int_col> * 1.0) for decimals
--           WHERE            keeps only rows where the condition is TRUE (row filter)
--                            Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Scalar subquery  inner SELECT returning ONE value, used like a constant
--                            Syntax: WHERE <column> > (SELECT <one value> FROM <table>)
--           ORDER BY         sorts the final result; ASC is default, DESC = largest first
--                            Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D10.2
-- The most expensive product (no TOP).
-- Use     : Products(ProductName, UnitPrice)
-- Concept : MIN / MAX        smallest / largest value (numbers, dates or text)
--                            Syntax: SELECT MIN(<column>), MAX(<column>) FROM <table>;
--           WHERE            keeps only rows where the condition is TRUE (row filter)
--                            Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Scalar subquery  inner SELECT returning ONE value, used like a constant
--                            Syntax: WHERE <column> > (SELECT <one value> FROM <table>)




-- D10.3
-- The most recent order(s).
-- Use     : Orders(OrderID, CustomerID, OrderDate)
-- Concept : MIN / MAX        smallest / largest value (numbers, dates or text)
--                            Syntax: SELECT MIN(<column>), MAX(<column>) FROM <table>;
--           WHERE            keeps only rows where the condition is TRUE (row filter)
--                            Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Scalar subquery  inner SELECT returning ONE value, used like a constant
--                            Syntax: WHERE <column> > (SELECT <one value> FROM <table>)




-- D10.4
-- Scalar subquery in SELECT: show each product's price next to the overall average and
-- the difference.
-- Use     : Products(ProductName, UnitPrice)
-- Concept : AS               gives a column or calculation a name in the result
--                            Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           AVG              average of non-NULL values; on INT columns the result is INT
--                            Syntax: SELECT AVG(<column>) FROM <table>;     -- AVG(<int_col> * 1.0) for decimals
--           Scalar subquery  inner SELECT returning ONE value, used like a constant
--                            Syntax: WHERE <column> > (SELECT <one value> FROM <table>)




-- D10.5
-- Error demo: the inner query returns more than one value.
-- Use     : Categories(CategoryID, CategoryName);  Products(ProductName, CategoryID)
-- Values  : Categories.CategoryName = Accessories | Audio | Laptops | Smart Home |
--           Smartphones | Tablets | Wearables
-- Concept : WHERE            keeps only rows where the condition is TRUE (row filter)
--                            Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           LIKE             text pattern: % = any characters, _ = exactly one character
--                            Syntax: WHERE <column> LIKE '<pattern>'     -- % = any chars, _ = one char
--           Scalar subquery  inner SELECT returning ONE value, used like a constant
--                            Syntax: WHERE <column> > (SELECT <one value> FROM <table>)





/* =====================================================================
   SECTION 11 | Multi-row Subqueries — IN and NOT IN
   Deck topic 11 (slides 48–50)
   Goal: Use a subquery that returns a list of values, and avoid the NOT IN + NULL trap.
   ===================================================================== */


-- D11.1
-- Products in any category whose name starts with 'S' (fixing the previous error with
-- IN).
-- Use     : Categories(CategoryID, CategoryName);  Products(ProductName, CategoryID)
-- Values  : Categories.CategoryName = Accessories | Audio | Laptops | Smart Home |
--           Smartphones | Tablets | Wearables
-- Concept : WHERE          keeps only rows where the condition is TRUE (row filter)
--                          Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           LIKE           text pattern: % = any characters, _ = exactly one character
--                          Syntax: WHERE <column> LIKE '<pattern>'     -- % = any chars, _ = one char
--           IN (subquery)  inner SELECT returns a one-column list; keeps rows whose value is in it
--                          Syntax: WHERE <column> IN (SELECT <one column> FROM <table2>)




-- D11.2
-- Customers who have placed at least one order.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(CustomerID)
-- Concept : WHERE          keeps only rows where the condition is TRUE (row filter)
--                          Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           IN (subquery)  inner SELECT returns a one-column list; keeps rows whose value is in it
--                          Syntax: WHERE <column> IN (SELECT <one column> FROM <table2>)




-- D11.3
-- Products that have never been sold.
-- Use     : Products(ProductID, ProductName);  OrderItems(ProductID)
-- Concept : WHERE              keeps only rows where the condition is TRUE (row filter)
--                              Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           NOT IN (subquery)  rows whose value is not in the list; returns NOTHING if the list
--                              holds a NULL
--                              Syntax: WHERE <col> NOT IN (SELECT <col> FROM <table2> WHERE <col> IS NOT NULL)




-- D11.4
-- THE NULL TRAP: employees who never handled an order. Expect at least the non-sales
-- staff... but the result is empty!
-- Use     : Employees(EmployeeID, FirstName, LastName);  Orders(EmployeeID)
-- Values  : Orders.EmployeeID: NULL = Online order (no employee)
-- Concept : WHERE              keeps only rows where the condition is TRUE (row filter)
--                              Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           NOT IN (subquery)  rows whose value is not in the list; returns NOTHING if the list
--                              holds a NULL
--                              Syntax: WHERE <col> NOT IN (SELECT <col> FROM <table2> WHERE <col> IS NOT NULL)




-- D11.5
-- Fix the trap: exclude NULLs inside the subquery (or use NOT EXISTS, topic 13).
-- Use     : Employees(EmployeeID, FirstName, LastName);  Orders(EmployeeID)
-- Values  : Orders.EmployeeID: NULL = Online order (no employee)
-- Concept : WHERE              keeps only rows where the condition is TRUE (row filter)
--                              Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           IS NOT NULL        keeps rows where the value is present
--                              Syntax: WHERE <column> IS NOT NULL
--           NOT IN (subquery)  rows whose value is not in the list; returns NOTHING if the list
--                              holds a NULL
--                              Syntax: WHERE <col> NOT IN (SELECT <col> FROM <table2> WHERE <col> IS NOT NULL)





/* =====================================================================
   SECTION 12 | Correlated Subqueries — The Inner Query Depends on the Outer Row
   Deck topic 12 (slides 51–53)
   Goal: Compare each row with a value calculated for its own group.
   ===================================================================== */


-- D12.1
-- Compare: products above the OVERALL average (topic 10) vs products above THEIR
-- CATEGORY's average.
-- Use     : Products(ProductName, CategoryID, UnitPrice)
-- Concept : AVG                  average of non-NULL values; on INT columns the result is INT
--                                Syntax: SELECT AVG(<column>) FROM <table>;     -- AVG(<int_col> * 1.0) for decimals
--           Table alias          short name for a table (p, o); required when a table appears twice
--                                Syntax: FROM <table> AS <alias>   -- then use <alias>.<column>
--           WHERE                keeps only rows where the condition is TRUE (row filter)
--                                Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Correlated subquery  inner query uses a column of the outer row, so it runs per outer
--                                row
--                                Syntax: WHERE a.<col> > (SELECT AVG(b.<col>) FROM <table> AS b WHERE b.<key> = a.<key>)
--           ORDER BY             sorts the final result; ASC is default, DESC = largest first
--                                Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D12.2
-- Show each product with the average price of its own category as a column.
-- Use     : Products(ProductName, CategoryID, UnitPrice)
-- Concept : AVG                  average of non-NULL values; on INT columns the result is INT
--                                Syntax: SELECT AVG(<column>) FROM <table>;     -- AVG(<int_col> * 1.0) for decimals
--           Table alias          short name for a table (p, o); required when a table appears twice
--                                Syntax: FROM <table> AS <alias>   -- then use <alias>.<column>
--           WHERE                keeps only rows where the condition is TRUE (row filter)
--                                Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Correlated subquery  inner query uses a column of the outer row, so it runs per outer
--                                row
--                                Syntax: WHERE a.<col> > (SELECT AVG(b.<col>) FROM <table> AS b WHERE b.<key> = a.<key>)




-- D12.3
-- For each customer, count their orders using a correlated subquery in SELECT.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(CustomerID)
-- Concept : AS                   gives a column or calculation a name in the result
--                                Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           COUNT(*)             counts rows, including rows with NULLs
--                                Syntax: SELECT COUNT(*) FROM <table>;
--           Table alias          short name for a table (p, o); required when a table appears twice
--                                Syntax: FROM <table> AS <alias>   -- then use <alias>.<column>
--           WHERE                keeps only rows where the condition is TRUE (row filter)
--                                Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Correlated subquery  inner query uses a column of the outer row, so it runs per outer
--                                row
--                                Syntax: WHERE a.<col> > (SELECT AVG(b.<col>) FROM <table> AS b WHERE b.<key> = a.<key>)
--           ORDER BY             sorts the final result; ASC is default, DESC = largest first
--                                Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D12.4
-- Each customer's most recent order.
-- Use     : Orders(OrderID, CustomerID, OrderDate)
-- Concept : MIN / MAX            smallest / largest value (numbers, dates or text)
--                                Syntax: SELECT MIN(<column>), MAX(<column>) FROM <table>;
--           Table alias          short name for a table (p, o); required when a table appears twice
--                                Syntax: FROM <table> AS <alias>   -- then use <alias>.<column>
--           WHERE                keeps only rows where the condition is TRUE (row filter)
--                                Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Correlated subquery  inner query uses a column of the outer row, so it runs per outer
--                                row
--                                Syntax: WHERE a.<col> > (SELECT AVG(b.<col>) FROM <table> AS b WHERE b.<key> = a.<key>)
--           ORDER BY             sorts the final result; ASC is default, DESC = largest first
--                                Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]





/* =====================================================================
   SECTION 13 | EXISTS & NOT EXISTS — Checking Whether Related Rows Exist
   Deck topic 13 (slides 54–56)
   Goal: Test for the presence or absence of matching rows; compare EXISTS with IN.
   ===================================================================== */


-- D13.1
-- Customers who have at least one order (EXISTS version). Compare with the IN version
-- from topic 11.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(CustomerID)
-- Concept : Table alias          short name for a table (p, o); required when a table appears twice
--                                Syntax: FROM <table> AS <alias>   -- then use <alias>.<column>
--           WHERE                keeps only rows where the condition is TRUE (row filter)
--                                Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Correlated subquery  inner query uses a column of the outer row, so it runs per outer
--                                row
--                                Syntax: WHERE a.<col> > (SELECT AVG(b.<col>) FROM <table> AS b WHERE b.<key> = a.<key>)
--           EXISTS               TRUE if the inner query returns at least one row
--                                Syntax: WHERE EXISTS (SELECT 1 FROM <table2> AS b WHERE b.<key> = a.<key>)




-- D13.2
-- Categories with no products.
-- Use     : Categories(CategoryID, CategoryName);  Products(CategoryID)
-- Concept : Table alias          short name for a table (p, o); required when a table appears twice
--                                Syntax: FROM <table> AS <alias>   -- then use <alias>.<column>
--           WHERE                keeps only rows where the condition is TRUE (row filter)
--                                Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Correlated subquery  inner query uses a column of the outer row, so it runs per outer
--                                row
--                                Syntax: WHERE a.<col> > (SELECT AVG(b.<col>) FROM <table> AS b WHERE b.<key> = a.<key>)
--           NOT EXISTS           TRUE if the inner query returns no rows; safe with NULLs
--                                Syntax: WHERE NOT EXISTS (SELECT 1 FROM <table2> AS b WHERE b.<key> = a.<key>)




-- D13.3
-- The NULL-trap query from topic 11, rewritten with NOT EXISTS. It works without any
-- NULL handling.
-- Use     : Employees(EmployeeID, FirstName, LastName);  Orders(EmployeeID)
-- Concept : Table alias          short name for a table (p, o); required when a table appears twice
--                                Syntax: FROM <table> AS <alias>   -- then use <alias>.<column>
--           WHERE                keeps only rows where the condition is TRUE (row filter)
--                                Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           Correlated subquery  inner query uses a column of the outer row, so it runs per outer
--                                row
--                                Syntax: WHERE a.<col> > (SELECT AVG(b.<col>) FROM <table> AS b WHERE b.<key> = a.<key>)
--           NOT EXISTS           TRUE if the inner query returns no rows; safe with NULLs
--                                Syntax: WHERE NOT EXISTS (SELECT 1 FROM <table2> AS b WHERE b.<key> = a.<key>)




-- D13.4
-- Customers who have an order that is still Pending.
-- Use     : Customers(CustomerID, FirstName, LastName);  Orders(CustomerID, Status)
-- Values  : Orders.Status = Cancelled | Delivered | Pending | Shipped
-- Concept : Table alias          short name for a table (p, o); required when a table appears twice
--                                Syntax: FROM <table> AS <alias>   -- then use <alias>.<column>
--           WHERE                keeps only rows where the condition is TRUE (row filter)
--                                Syntax: SELECT <cols> FROM <table> WHERE <condition>;
--           AND                  every condition must be TRUE
--                                Syntax: WHERE <condition1> AND <condition2>
--           Correlated subquery  inner query uses a column of the outer row, so it runs per outer
--                                row
--                                Syntax: WHERE a.<col> > (SELECT AVG(b.<col>) FROM <table> AS b WHERE b.<key> = a.<key>)
--           EXISTS               TRUE if the inner query returns at least one row
--                                Syntax: WHERE EXISTS (SELECT 1 FROM <table2> AS b WHERE b.<key> = a.<key>)





/* =====================================================================
   SECTION 14 | Subqueries in FROM — Derived Tables
   Deck topic 14 (slides 57–58)
   Goal: Treat the result of a query as a temporary table, to aggregate in two steps.
   ===================================================================== */


-- D14.1
-- Step 1: gross value per order. Step 2: average order value across orders.
-- Use     : OrderItems(OrderID, Quantity, UnitPrice)
-- Concept : AS             gives a column or calculation a name in the result
--                          Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           SUM            adds up values; ignores NULLs
--                          Syntax: SELECT SUM(<column or expression>) FROM <table>;
--           AVG            average of non-NULL values; on INT columns the result is INT
--                          Syntax: SELECT AVG(<column>) FROM <table>;     -- AVG(<int_col> * 1.0) for decimals
--           Derived table  a subquery in FROM used as a temporary table; needs an alias
--                          Syntax: SELECT ... FROM (SELECT ... FROM <table> ...) AS <alias>;
--           GROUP BY       one result row per group; SELECT only grouped or aggregated columns
--                          Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;




-- D14.2
-- How many customers fall into each order-count band (1, 2, 3+)?
-- Use     : Orders(CustomerID)
-- Concept : AS             gives a column or calculation a name in the result
--                          Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           COUNT(*)       counts rows, including rows with NULLs
--                          Syntax: SELECT COUNT(*) FROM <table>;
--           Derived table  a subquery in FROM used as a temporary table; needs an alias
--                          Syntax: SELECT ... FROM (SELECT ... FROM <table> ...) AS <alias>;
--           GROUP BY       one result row per group; SELECT only grouped or aggregated columns
--                          Syntax: SELECT <col>, <AGG>(<col2>) FROM <table> GROUP BY <col>;
--           ORDER BY       sorts the final result; ASC is default, DESC = largest first
--                          Syntax: ORDER BY <col1> [ASC | DESC], <col2> [ASC | DESC]




-- D14.3
-- Filter on a calculated alias by moving the calculation into a derived table.
-- Use     : Products(ProductName, UnitPrice, StockQty)
-- Concept : SELECT *       returns every column of the table
--                          Syntax: SELECT * FROM <table>;
--           AS             gives a column or calculation a name in the result
--                          Syntax: <column or expression> AS <alias>      -- [Alias With Spaces]
--           Derived table  a subquery in FROM used as a temporary table; needs an alias
--                          Syntax: SELECT ... FROM (SELECT ... FROM <table> ...) AS <alias>;
--           WHERE          keeps only rows where the condition is TRUE (row filter)
--                          Syntax: SELECT <cols> FROM <table> WHERE <condition>;




-- End of demonstration script.
