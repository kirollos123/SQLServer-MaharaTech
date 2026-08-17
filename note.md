# T-SQL Complete Notes — Built on One Database: SalesDB

## 0. Introduction — Why One Database?

Every topic in this note — from `TOP` to `MERGE` to `PIVOT` — is taught using **one single realistic SQL Server database**: `SalesDB`. Instead of jumping between disconnected toy examples, you will build a real Sales/E-Commerce data model once, fill it with realistic data once, and then reuse it for every single concept. By the end, you won't just know T-SQL syntax — you'll have shipped one coherent database project.

`SalesDB` represents a mid-sized company that sells products (like electronics) to customers through orders, staffed by employees organized into departments, with products sourced from suppliers and organized into categories.

---

## 1. Creating the Database

```sql
CREATE DATABASE SalesDB;
GO

USE SalesDB;
GO
```

**What this models:** A company that needs to track who works there (`Employees`, `Departments`), who buys from them (`Customers`), what they sell (`Products`, `Categories`, `Suppliers`), and the transactions that tie it together (`Orders`, `OrderDetails`, `Sales`).

**Business problems SalesDB answers:**
- Who are our top-performing employees?
- Which products sell best, and in which categories?
- What does a customer's order history look like?
- How do we report sales over time, by department, by category?

We will keep using this exact database — with the exact same table names — from here to the end of the notes.

---

## 2. Schema Overview

```text
SalesDB
│
├── dbo.Departments
├── dbo.Employees
├── dbo.Customers
├── dbo.Suppliers
├── dbo.Categories
├── dbo.Products
├── dbo.Orders
├── dbo.OrderDetails
└── dbo.Sales
```

### Relationships

```text
Departments
     │
     └──< Employees


Customers
     │
     └──< Orders
              │
              └──< OrderDetails >── Products
                                      │
                            ┌─────────┴─────────┐
                       Categories            Suppliers

Employees
     │
     └──< Sales  (an employee "owns" a sale linked to an Order)
```

- **Departments → Employees**: one department has many employees (1‑to‑many). `Employees.DepartmentID` is a foreign key to `Departments.DepartmentID`.
- **Customers → Orders**: one customer places many orders. `Orders.CustomerID` is a foreign key.
- **Orders → OrderDetails**: one order has many line items. `OrderDetails.OrderID` is a foreign key.
- **Products → OrderDetails**: one product appears in many order line items. `OrderDetails.ProductID` is a foreign key.
- **Categories → Products**: one category has many products. `Products.CategoryID` is a foreign key.
- **Suppliers → Products**: one supplier supplies many products. `Products.SupplierID` is a foreign key.
- **Employees → Sales**: one employee is credited with many sales. `Sales.EmployeeID` is a foreign key, and `Sales.OrderID` links back to the order that generated it.

**Why these relationships exist:** They enforce **referential integrity** — you cannot have an `OrderDetails` row pointing to a `ProductID` that doesn't exist, and you cannot delete a `Customer` who still has `Orders` (unless you explicitly cascade). This mirrors how a real business database prevents orphaned, inconsistent data.

---

## 3. Creating the Tables

```sql
USE SalesDB;
GO

-- Departments: small lookup table, IT/Sales/HR/etc.
CREATE TABLE dbo.Departments
(
    DepartmentID   INT IDENTITY(1,1) CONSTRAINT PK_Departments PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);
GO

-- Employees: staff who process sales
CREATE TABLE dbo.Employees
(
    EmployeeID   INT IDENTITY(1,1) CONSTRAINT PK_Employees PRIMARY KEY,
    FirstName    VARCHAR(50)  NOT NULL,
    LastName     VARCHAR(50)  NOT NULL,
    DepartmentID INT          NOT NULL
        CONSTRAINT FK_Employees_Departments REFERENCES dbo.Departments(DepartmentID),
    HireDate     DATE         NOT NULL DEFAULT (GETDATE()),
    Salary       DECIMAL(10,2) NOT NULL,
    ManagerID    INT NULL
        CONSTRAINT FK_Employees_Manager REFERENCES dbo.Employees(EmployeeID)
);
GO

-- Customers: people who place orders
CREATE TABLE dbo.Customers
(
    CustomerID INT IDENTITY(1,1) CONSTRAINT PK_Customers PRIMARY KEY,
    FirstName  VARCHAR(50) NOT NULL,
    LastName   VARCHAR(50) NOT NULL,
    Email      VARCHAR(150) NOT NULL UNIQUE,
    City       VARCHAR(50) NULL,
    Country    VARCHAR(50) NOT NULL DEFAULT ('Unknown'),
    JoinDate   DATE NOT NULL DEFAULT (GETDATE())
);
GO

-- Suppliers: who provides the products
CREATE TABLE dbo.Suppliers
(
    SupplierID   INT IDENTITY(1,1) CONSTRAINT PK_Suppliers PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    Country      VARCHAR(50) NULL
);
GO

-- Categories: product groupings
CREATE TABLE dbo.Categories
(
    CategoryID   INT IDENTITY(1,1) CONSTRAINT PK_Categories PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);
GO

-- Products: what we sell
CREATE TABLE dbo.Products
(
    ProductID   INT IDENTITY(1,1) CONSTRAINT PK_Products PRIMARY KEY,
    ProductName VARCHAR(100)  NOT NULL,
    CategoryID  INT           NOT NULL
        CONSTRAINT FK_Products_Categories REFERENCES dbo.Categories(CategoryID),
    SupplierID  INT           NOT NULL
        CONSTRAINT FK_Products_Suppliers REFERENCES dbo.Suppliers(SupplierID),
    Price       DECIMAL(10,2) NOT NULL,
    Stock       INT           NOT NULL DEFAULT (0)
);
GO

-- Orders: header of a purchase
CREATE TABLE dbo.Orders
(
    OrderID    INT IDENTITY(1,1) CONSTRAINT PK_Orders PRIMARY KEY,
    CustomerID INT      NOT NULL
        CONSTRAINT FK_Orders_Customers REFERENCES dbo.Customers(CustomerID),
    OrderDate  DATE     NOT NULL DEFAULT (GETDATE()),
    Status     VARCHAR(20) NOT NULL DEFAULT ('Pending')
        CONSTRAINT CK_Orders_Status CHECK (Status IN ('Pending','Shipped','Delivered','Cancelled'))
);
GO

-- OrderDetails: line items of an order
CREATE TABLE dbo.OrderDetails
(
    OrderDetailID INT IDENTITY(1,1) CONSTRAINT PK_OrderDetails PRIMARY KEY,
    OrderID       INT NOT NULL
        CONSTRAINT FK_OrderDetails_Orders REFERENCES dbo.Orders(OrderID),
    ProductID     INT NOT NULL
        CONSTRAINT FK_OrderDetails_Products REFERENCES dbo.Products(ProductID),
    Quantity      INT NOT NULL CHECK (Quantity > 0),
    UnitPrice     DECIMAL(10,2) NOT NULL
);
GO

-- Sales: fact table crediting an employee for an order (used heavily for aggregation)
CREATE TABLE dbo.Sales
(
    SaleID      INT IDENTITY(1,1) CONSTRAINT PK_Sales PRIMARY KEY,
    OrderID     INT NOT NULL
        CONSTRAINT FK_Sales_Orders REFERENCES dbo.Orders(OrderID),
    EmployeeID  INT NOT NULL
        CONSTRAINT FK_Sales_Employees REFERENCES dbo.Employees(EmployeeID),
    SaleDate    DATE NOT NULL DEFAULT (GETDATE()),
    SaleAmount  DECIMAL(10,2) NOT NULL
);
GO
```

**Why these data types:**
- `INT IDENTITY(1,1)` for every primary key — auto-incrementing surrogate keys are cheap to join and index.
- `DECIMAL(10,2)` for money (`Salary`, `Price`, `SaleAmount`) — never use `FLOAT` for currency, since floating point rounding errors corrupt financial totals.
- `VARCHAR` (not `NVARCHAR`) since this sample data is English-only; in a real international system you'd use `NVARCHAR` for Unicode names.
- `DATE` (not `DATETIME`) for `OrderDate`/`HireDate`/`SaleDate` because we only care about the calendar day, not the time.
- `ManagerID` on `Employees` is a **self-referencing foreign key** — it points back to `Employees.EmployeeID`, modeling "an employee's manager is also an employee."
- `CHECK` constraint on `Orders.Status` restricts values to a known, valid set instead of allowing arbitrary free text.

---

## 4. Inserting Realistic Sample Data

```sql
USE SalesDB;
GO

-- Departments
INSERT INTO dbo.Departments (DepartmentName) VALUES
('IT'), ('Sales'), ('HR'), ('Finance'), ('Marketing');
GO

-- Employees (note: repeated salaries on purpose, to demonstrate ties in ranking)
INSERT INTO dbo.Employees (FirstName, LastName, DepartmentID, HireDate, Salary, ManagerID) VALUES
('John',   'Smith',  2, '2019-03-01', 9000.00, NULL),
('Sarah',  'Ahmed',  2, '2020-06-15', 8500.00, 1),
('Michael','Brown',  2, '2021-01-10', 8500.00, 1),
('Omar',   'Hassan', 1, '2018-11-20', 10500.00, NULL),
('Daniel', 'Wilson', 1, '2022-02-05', 7200.00, 4),
('Mona',   'Fathy',  1, '2021-07-19', 7200.00, 4),
('Laila',  'Kamal',  3, '2019-09-09', 6800.00, NULL),
('Kevin',  'Lee',    4, '2020-01-15', 9800.00, NULL),
('Nourhan','Adel',   4, '2021-03-22', 7600.00, 8),
('Peter',  'Nagy',   5, '2022-08-01', 6500.00, NULL);
GO

-- Customers
INSERT INTO dbo.Customers (FirstName, LastName, Email, City, Country, JoinDate) VALUES
('Ahmed', 'Ali',    'ahmed.ali@mail.com',    'Alexandria', 'Egypt', '2021-01-05'),
('John',  'Carter', 'john.carter@mail.com',  'London',     'UK',    '2021-03-14'),
('Maria', 'Smith',  'maria.smith@mail.com',  'Madrid',     'Spain', '2020-11-30'),
('Youssef','Nabil',  'youssef.nabil@mail.com','Cairo',      'Egypt', '2022-05-01'),
('Emma',  'Davis',  'emma.davis@mail.com',   'Manchester', 'UK',    '2022-07-19'),
('Karim', 'Fouad',  'karim.fouad@mail.com',  'Giza',       'Egypt', '2023-02-10'),
('Lucia', 'Rossi',  'lucia.rossi@mail.com',  'Rome',       'Italy', '2023-04-22');
GO

-- Suppliers
INSERT INTO dbo.Suppliers (SupplierName, Country) VALUES
('TechSource Ltd', 'China'),
('GlobalParts Inc', 'USA'),
('EuroSupply Co', 'Germany');
GO

-- Categories
INSERT INTO dbo.Categories (CategoryName) VALUES
('Laptops'), ('Accessories'), ('Monitors'), ('Audio');
GO

-- Products
INSERT INTO dbo.Products (ProductName, CategoryID, SupplierID, Price, Stock) VALUES
('Laptop Pro 15',    1, 1, 1200.00, 40),
('Laptop Air 13',    1, 1,  950.00, 55),
('Wireless Keyboard',2, 2,   45.00, 200),
('Wireless Mouse',   2, 2,   25.00, 300),
('27-inch Monitor',  3, 3,  320.00, 60),
('24-inch Monitor',  3, 3,  240.00, 80),
('Over-Ear Headphones',4, 2, 90.00, 150),
('Bluetooth Speaker',4, 2,   60.00, 120);
GO

-- Orders (spread across a few months for time-based queries)
INSERT INTO dbo.Orders (CustomerID, OrderDate, Status) VALUES
(1, '2026-01-10', 'Delivered'),
(2, '2026-01-18', 'Delivered'),
(1, '2026-02-02', 'Delivered'),
(3, '2026-02-14', 'Shipped'),
(4, '2026-02-20', 'Delivered'),
(5, '2026-03-01', 'Pending'),
(2, '2026-03-05', 'Delivered'),
(6, '2026-03-15', 'Cancelled'),
(7, '2026-03-22', 'Delivered'),
(4, '2026-03-28', 'Shipped');
GO

-- OrderDetails
INSERT INTO dbo.OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 1200.00),
(1, 3, 2,   45.00),
(2, 2, 1,  950.00),
(2, 4, 1,   25.00),
(3, 5, 2,  320.00),
(4, 7, 1,   90.00),
(4, 8, 1,   60.00),
(5, 1, 1, 1200.00),
(6, 6, 1,  240.00),
(7, 3, 3,   45.00),
(8, 2, 1,  950.00),
(9, 5, 1,  320.00),
(9, 7, 2,   90.00),
(10,1, 1, 1200.00);
GO

-- Sales (each employee credited for a subset of orders)
INSERT INTO dbo.Sales (OrderID, EmployeeID, SaleDate, SaleAmount) VALUES
(1, 2, '2026-01-10', 1290.00),
(2, 2, '2026-01-18',  975.00),
(3, 3, '2026-02-02',  640.00),
(4, 3, '2026-02-14',  150.00),
(5, 1, '2026-02-20', 1200.00),
(7, 2, '2026-03-05',  135.00),
(9, 1, '2026-03-22',  500.00),
(10,3, '2026-03-28', 1200.00);
GO
```

This gives us **duplicate salary values** (Sarah/Michael both 8500, Daniel/Mona both 7200) for ranking-tie demos, orders **spread across three months** for time-series/window-function demos, and a **cancelled order** to show how `Status` filters matter.

---

## 5. Building the Note Chapter by Chapter — The Flow

```text
Create Database → Create Tables → Insert Data → Query Data → TOP → NEWID
   → Data Manipulation → Ranking → PARTITION BY → Window Functions
   → MERGE → Aggregation → ROLLUP / CUBE / GROUPING SETS → PIVOT / UNPIVOT
```

Every section below reuses `SalesDB` exactly as built above. No new databases, no renamed tables.

---

## 6. TOP

**Business question:** *Who are the 5 highest-paid employees?*

```sql
USE SalesDB;
GO

SELECT TOP (5)
    EmployeeID,
    FirstName,
    LastName,
    Salary
FROM dbo.Employees
ORDER BY Salary DESC;
```

- `TOP (5)` limits the result set to 5 rows.
- `ORDER BY Salary DESC` is what makes those 5 rows *meaningful* — without it, SQL Server returns whichever 5 rows it accesses first (no guaranteed order), so "top 5 highest-paid" would be wrong.
- You can also do `TOP (10) PERCENT` to return a percentage of rows instead of a fixed count.

---

## 7. NEWID() — Random Selection

**Business question:** *Select 5 random customers for a marketing campaign.*

```sql
SELECT TOP (5)
    CustomerID,
    FirstName,
    LastName
FROM dbo.Customers
ORDER BY NEWID();
```

`NEWID()` generates a random GUID per row; sorting by it shuffles the result set, and `TOP (5)` then samples 5 rows. This is the standard T-SQL pattern for random sampling (note: on very large tables it's slow, since it must generate a GUID for every row — `TABLESAMPLE` is the scalable alternative).

---

## 8. Data Manipulation Basics (INSERT / UPDATE / DELETE)

```sql
-- INSERT a new customer
INSERT INTO dbo.Customers (FirstName, LastName, Email, City, Country)
VALUES ('Hana', 'Zaki', 'hana.zaki@mail.com', 'Alexandria', 'Egypt');

-- UPDATE: give the IT department a raise
UPDATE dbo.Employees
SET Salary = Salary * 1.05
WHERE DepartmentID = (SELECT DepartmentID FROM dbo.Departments WHERE DepartmentName = 'IT');

-- DELETE: remove a cancelled order's line items, then the order itself
DELETE FROM dbo.OrderDetails WHERE OrderID = (SELECT OrderID FROM dbo.Orders WHERE Status = 'Cancelled');
DELETE FROM dbo.Orders WHERE Status = 'Cancelled';
```

This shows why the foreign keys matter: you must delete child rows in `OrderDetails` before the parent row in `Orders`, or SQL Server blocks the delete to protect referential integrity.

---

## 9. Ranking Functions

**Business question:** *Rank employees by salary within each department.*

```sql
SELECT
    EmployeeID,
    FirstName,
    LastName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS RowNum,
    RANK()       OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank,
    DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS DenseSalaryRank
FROM dbo.Employees;
```

Using our actual data, in the **Sales** department (DepartmentID 2): John (9000) is rank 1. Sarah and Michael are tied at 8500:
- `ROW_NUMBER()` breaks the tie arbitrarily and gives them 2 and 3 (no ties allowed).
- `RANK()` gives them **both rank 2**, then skips to rank 4 for the next employee (leaves a gap).
- `DENSE_RANK()` also gives them **both rank 2**, but the next distinct salary gets rank 3 (no gap).

Same pattern repeats in the **IT** department, where Daniel and Mona are tied at 7200.

**PARTITION BY** is the key concept: it resets the ranking separately for each department, instead of ranking every employee company-wide.

---

## 10. Window (Aggregate) Functions

**Business question:** *What is each employee's sale amount compared to their department's total, and what's the running total of sales over time?*

```sql
-- Department total kept alongside every employee row (no GROUP BY collapsing needed)
SELECT
    e.EmployeeID,
    e.FirstName,
    e.DepartmentID,
    s.SaleAmount,
    SUM(s.SaleAmount) OVER (PARTITION BY e.DepartmentID) AS DepartmentTotalSales
FROM dbo.Employees e
JOIN dbo.Sales s ON s.EmployeeID = e.EmployeeID;

-- Running total of sales over time
SELECT
    SaleID,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM dbo.Sales
ORDER BY SaleDate;
```

Unlike a plain `GROUP BY`, `SUM(...) OVER(...)` does **not** collapse rows — every individual sale row is kept, with the aggregate value attached alongside it. That's the whole point of a window function: aggregate *and* detail in the same result set.

---

## 11. MERGE — Synchronizing Product Data

**Business scenario:** A supplier sends a nightly file with updated prices and new products. We load it into a staging table, then sync it into `dbo.Products`.

```text
dbo.ProductUpdates
      ↓
   MERGE
      ↓
dbo.Products
```

```sql
CREATE TABLE dbo.ProductUpdates
(
    ProductID   INT,
    ProductName VARCHAR(100),
    Price       DECIMAL(10,2),
    CategoryID  INT
);
GO

INSERT INTO dbo.ProductUpdates (ProductID, ProductName, Price, CategoryID) VALUES
(1, 'Laptop Pro 15', 1150.00, 1),   -- existing product, price drop
(5, '27-inch Monitor', 340.00, 3),  -- existing product, price increase
(NULL, 'Mechanical Keyboard', 75.00, 2); -- brand new product (no matching ID)
GO

MERGE dbo.Products AS Target
USING dbo.ProductUpdates AS Source
ON Target.ProductID = Source.ProductID
WHEN MATCHED THEN
    UPDATE SET Target.Price = Source.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductName, CategoryID, SupplierID, Price, Stock)
    VALUES (Source.ProductName, Source.CategoryID, 1, Source.Price, 0);
```

- `WHEN MATCHED` updates the price of products that already exist.
- `WHEN NOT MATCHED BY TARGET` inserts the brand-new "Mechanical Keyboard" row, since its `ProductID` is `NULL` and matches nothing.
- This is the exact real-world use case for `MERGE`: upserting a nightly feed without writing separate `UPDATE` and `INSERT` statements with manual existence checks.

---

## 12. ROLLUP / CUBE / GROUPING SETS

**Business question:** *Show total sales by department and by month, with department subtotals and a grand total.*

We'll use `Sales` joined to `Employees` for department, and `SaleDate` for the month.

```sql
SELECT
    d.DepartmentName,
    MONTH(s.SaleDate) AS SaleMonth,
    SUM(s.SaleAmount) AS TotalSales
FROM dbo.Sales s
JOIN dbo.Employees e ON e.EmployeeID = s.EmployeeID
JOIN dbo.Departments d ON d.DepartmentID = e.DepartmentID
GROUP BY ROLLUP (d.DepartmentName, MONTH(s.SaleDate));
```

`ROLLUP` produces, in order: (1) every department+month combination, (2) a subtotal row per department (month = `NULL`), (3) one grand-total row (both columns `NULL`).

```sql
SELECT
    d.DepartmentName,
    MONTH(s.SaleDate) AS SaleMonth,
    SUM(s.SaleAmount) AS TotalSales
FROM dbo.Sales s
JOIN dbo.Employees e ON e.EmployeeID = s.EmployeeID
JOIN dbo.Departments d ON d.DepartmentID = e.DepartmentID
GROUP BY CUBE (d.DepartmentName, MONTH(s.SaleDate));
```

`CUBE` goes further than `ROLLUP`: it also adds subtotals **per month across all departments**, in addition to everything `ROLLUP` gives you — every possible combination of subtotals.

```sql
SELECT
    d.DepartmentName,
    MONTH(s.SaleDate) AS SaleMonth,
    SUM(s.SaleAmount) AS TotalSales
FROM dbo.Sales s
JOIN dbo.Employees e ON e.EmployeeID = s.EmployeeID
JOIN dbo.Departments d ON d.DepartmentID = e.DepartmentID
GROUP BY GROUPING SETS (
    (d.DepartmentName, MONTH(s.SaleDate)),
    (d.DepartmentName),
    (MONTH(s.SaleDate)),
    ()
);
```

`GROUPING SETS` lets you hand-pick exactly which subtotal combinations you want — here we've manually specified the same four groupings that `CUBE` would generate automatically, which is useful when you want *some* but not *all* combinations `CUBE` would give.

---

## 13. PIVOT / UNPIVOT

**Business question:** *Turn monthly sales rows into a report with one column per month.*

Starting shape (rows):

```text
DepartmentName | SaleMonth | TotalSales
Sales          | 1         | 2265.00
Sales          | 2         | 790.00
Sales          | 3         | 1335.00
IT             | 2         | 1200.00
IT             | 3         | 500.00
```

```sql
SELECT DepartmentName, [1] AS Jan, [2] AS Feb, [3] AS Mar
FROM
(
    SELECT
        d.DepartmentName,
        MONTH(s.SaleDate) AS SaleMonth,
        s.SaleAmount
    FROM dbo.Sales s
    JOIN dbo.Employees e ON e.EmployeeID = s.EmployeeID
    JOIN dbo.Departments d ON d.DepartmentID = e.DepartmentID
) AS SourceData
PIVOT
(
    SUM(SaleAmount)
    FOR SaleMonth IN ([1], [2], [3])
) AS PivotTable;
```

Result (columns):

```text
DepartmentName | Jan     | Feb    | Mar
Sales          | 2265.00 | NULL   | 135.00
IT             | NULL    | 1200.00| 500.00
```

Now reverse it with `UNPIVOT`, turning those month columns back into rows:

```sql
SELECT DepartmentName, SaleMonth, SaleAmount
FROM
(
    SELECT DepartmentName, [1] AS Jan, [2] AS Feb, [3] AS Mar
    FROM ( /* same pivoted result as above, materialized or via CTE */
        SELECT d.DepartmentName, MONTH(s.SaleDate) AS SaleMonth, s.SaleAmount
        FROM dbo.Sales s
        JOIN dbo.Employees e ON e.EmployeeID = s.EmployeeID
        JOIN dbo.Departments d ON d.DepartmentID = e.DepartmentID
    ) AS SourceData
    PIVOT (SUM(SaleAmount) FOR SaleMonth IN ([1],[2],[3])) AS PivotTable
) AS PivotedData
UNPIVOT
(
    SaleAmount FOR SaleMonth IN (Jan, Feb, Mar)
) AS UnpivotTable;
```

```text
Rows → PIVOT → Columns
Columns → UNPIVOT → Rows
```

`PIVOT` aggregates and rotates row values into column headers; `UNPIVOT` does the inverse, flattening columns back into rows — same underlying `Sales` data, two different shapes for two different reporting needs.

---

## 14. Four-Part Naming (Server.Database.Schema.Object)

```sql
SELECT *
FROM SalesDB.dbo.Employees;
```

```text
SalesDB   → the database
   ↓
dbo       → the schema (default schema, "database owner")
   ↓
Employees → the table/object
```

Full form: `Server.Database.Schema.Object` — you rarely need the server part when you're already connected to it, but `Database.Schema.Object` is common when querying across databases on the same server (e.g. joining `SalesDB.dbo.Employees` to a table in an `HRDB` database).

---

## 15. Copying Data: `SELECT INTO` vs `INSERT INTO ... SELECT`

```sql
-- SELECT INTO: creates a brand-new table AND copies the data, in one step
SELECT *
INTO dbo.EmployeeBackup
FROM dbo.Employees;

-- INSERT INTO ... SELECT: table must already exist; only copies rows
INSERT INTO dbo.EmployeeBackup
SELECT *
FROM dbo.Employees;
```

- `SELECT INTO` is a shortcut for "snapshot this table right now" — it infers the schema from the source, but does **not** copy constraints, indexes, or foreign keys. Great for quick backups, bad for production schemas.
- `INSERT INTO ... SELECT` requires `dbo.EmployeeBackup` to already exist (which is why the two statements above, run in order, work — the first creates it, the second appends the same rows again).

---

## 16. Import / Export Context

```text
CSV File (e.g. new Customers export from a marketing tool)
   ↓
Import
   ↓
SalesDB (dbo.Customers)
   ↓
SQL Server processes orders, sales
   ↓
Export
   ↓
CSV / Power BI / External Reporting System
```

A real company needs this because data doesn't live only in SQL Server — customer lists arrive from marketing platforms, and sales summaries need to leave SQL Server to reach dashboards, finance teams, or external partners. SQL Server Import/Export Wizard, `BULK INSERT`, or `bcp` are the common tools for this movement in and out of `SalesDB`.

---

## 17. Naming Consistency Recap

Throughout every section above, the same eight names were used without variation:

```sql
dbo.Departments
dbo.Employees
dbo.Customers
dbo.Suppliers
dbo.Categories
dbo.Products
dbo.Orders
dbo.OrderDetails
dbo.Sales
```

No `tblEmployee`, no `Staff`, no `Workers` — one name per entity, everywhere.

---

## 18. End-to-End Project — Put It All Together

Using nothing but the `SalesDB` you built above, complete this project in order:

1. **Query employees** — list every employee with their department name (`JOIN Employees` to `Departments`).
2. **Find top employees** — `TOP (5)` employees by `Salary`, highest first.
3. **Select random customers** — `TOP (5) ... ORDER BY NEWID()` for a marketing campaign.
4. **Rank employees** — `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()` by `Salary` company-wide.
5. **Rank employees within departments** — same three functions, `PARTITION BY DepartmentID`.
6. **Calculate running sales totals** — `SUM(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`.
7. **Synchronize product data** — build a `dbo.ProductUpdates` staging table and `MERGE` it into `dbo.Products`.
8. **Generate sales summaries** — `GROUP BY ROLLUP (DepartmentName, SaleMonth)`.
9. **Generate multidimensional summaries** — `GROUP BY CUBE (DepartmentName, SaleMonth)`.
10. **Generate custom summaries** — `GROUP BY GROUPING SETS (...)` picking only the combinations that matter for the report.
11. **Create a report using PIVOT** — months as columns, department totals as rows.
12. **Convert the report back using UNPIVOT** — flatten it back to rows for storage or further processing.

Every step above reuses the exact schema and data from Sections 3–4 — nothing new to create, nothing to rename. This is the same discipline a real SQL Server reporting/ETL task requires: one stable schema, many angles of analysis.