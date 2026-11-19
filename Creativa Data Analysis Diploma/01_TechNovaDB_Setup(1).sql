/* =====================================================================
   TechNovaDB — Database Setup Script
   SQL Server (T-SQL) | Session: SQL Querying Fundamentals (SELECT → Subqueries)
   ---------------------------------------------------------------------
   TechNova is a small electronics retailer selling laptops, phones,
   tablets, accessories, audio and smart-home products through two
   channels: physical stores (served by a sales rep) and online.

   Tables (6):
     Categories  (7 rows)  -> product categories
     Products    (24 rows) -> what TechNova sells
     Customers   (20 rows) -> who buys
     Employees   (8 rows)  -> staff (store orders are handled by Sales reps)
     Orders      (40 rows) -> one row per order (header)
     OrderItems  (73 rows) -> one row per product line inside an order

   Data deliberately includes teaching edge cases:
     - NULLs: Customers.Email / Phone / City, Products.Brand,
       Employees.Commission / ManagerID, Orders.EmployeeID (online orders),
       Orders.ShippedDate (pending / cancelled orders)
     - Repeated values (City, Brand, Status) for DISTINCT and GROUP BY
     - Products never ordered, customers who never ordered,
       a sales rep with no orders, a category with no products
       -> for NOT IN / NOT EXISTS practice
   Run the whole script (F5). It is safe to re-run: it rebuilds everything.
   ===================================================================== */

USE master;
GO

IF DB_ID(N'TechNovaDB') IS NOT NULL
BEGIN
    ALTER DATABASE TechNovaDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE TechNovaDB;
END
GO

CREATE DATABASE TechNovaDB;
GO

USE TechNovaDB;
GO

/* ---------- 1. Categories ---------- */
CREATE TABLE Categories (
    CategoryID    INT           PRIMARY KEY,
    CategoryName  NVARCHAR(50)  NOT NULL UNIQUE
);

/* ---------- 2. Products ---------- */
CREATE TABLE Products (
    ProductID     INT            PRIMARY KEY,
    ProductName   NVARCHAR(100)  NOT NULL,
    CategoryID    INT            NOT NULL REFERENCES Categories(CategoryID),
    Brand         NVARCHAR(50)   NULL,                 -- NULL = unbranded / generic
    UnitPrice     DECIMAL(10,2)  NOT NULL CHECK (UnitPrice > 0),   -- EGP
    StockQty      INT            NOT NULL DEFAULT 0 CHECK (StockQty >= 0),
    Discontinued  BIT            NOT NULL DEFAULT 0,   -- 1 = no longer sold
    LaunchDate    DATE           NOT NULL
);

/* ---------- 3. Customers ---------- */
CREATE TABLE Customers (
    CustomerID    INT            PRIMARY KEY,
    FirstName     NVARCHAR(50)   NOT NULL,
    LastName      NVARCHAR(50)   NOT NULL,
    Email         NVARCHAR(100)  NULL,
    Phone         VARCHAR(20)    NULL,
    City          NVARCHAR(50)   NULL,
    Segment       NVARCHAR(20)   NOT NULL CHECK (Segment IN (N'Consumer', N'Business')),
    JoinDate      DATE           NOT NULL
);

/* ---------- 4. Employees ---------- */
CREATE TABLE Employees (
    EmployeeID    INT            PRIMARY KEY,
    FirstName     NVARCHAR(50)   NOT NULL,
    LastName      NVARCHAR(50)   NOT NULL,
    JobTitle      NVARCHAR(50)   NOT NULL,
    Department    NVARCHAR(30)   NOT NULL,
    HireDate      DATE           NOT NULL,
    Salary        DECIMAL(10,2)  NOT NULL CHECK (Salary > 0),      -- monthly, EGP
    Commission    DECIMAL(4,2)   NULL,                 -- rate, e.g. 0.05 = 5%, NULL = not on commission
    ManagerID     INT            NULL REFERENCES Employees(EmployeeID)
);

/* ---------- 5. Orders ---------- */
CREATE TABLE Orders (
    OrderID       INT            PRIMARY KEY,
    CustomerID    INT            NOT NULL REFERENCES Customers(CustomerID),
    EmployeeID    INT            NULL REFERENCES Employees(EmployeeID),  -- NULL for Online orders
    OrderDate     DATE           NOT NULL,
    ShippedDate   DATE           NULL,                 -- NULL = not shipped yet / cancelled
    Status        NVARCHAR(20)   NOT NULL CHECK (Status IN (N'Pending', N'Shipped', N'Delivered', N'Cancelled')),
    Channel       NVARCHAR(10)   NOT NULL CHECK (Channel IN (N'Online', N'Store'))
);

/* ---------- 6. OrderItems ---------- */
CREATE TABLE OrderItems (
    OrderItemID   INT            PRIMARY KEY,
    OrderID       INT            NOT NULL REFERENCES Orders(OrderID),
    ProductID     INT            NOT NULL REFERENCES Products(ProductID),
    Quantity      INT            NOT NULL CHECK (Quantity > 0),
    UnitPrice     DECIMAL(10,2)  NOT NULL,             -- price at time of sale
    Discount      DECIMAL(4,2)   NOT NULL DEFAULT 0 CHECK (Discount BETWEEN 0 AND 0.5)  -- 0.10 = 10%
);
GO

/* =============================== DATA =============================== */


INSERT INTO Categories (CategoryID, CategoryName) VALUES
    (1, N'Laptops'),
    (2, N'Smartphones'),
    (3, N'Tablets'),
    (4, N'Accessories'),
    (5, N'Audio'),
    (6, N'Smart Home'),
    (7, N'Wearables');

INSERT INTO Products (ProductID, ProductName, CategoryID, Brand, UnitPrice, StockQty, Discontinued, LaunchDate) VALUES
    (1, N'Nova Book 14', 1, N'Nova', 28500, 12, 0, '2024-03-10'),
    (2, N'Nova Book Pro 16', 1, N'Nova', 52000, 5, 0, '2025-02-01'),
    (3, N'Zenix Air 13', 1, N'Zenix', 34900, 8, 0, '2024-09-15'),
    (4, N'Zenix Gamer X', 1, N'Zenix', 61000, 3, 0, '2025-05-20'),
    (5, N'Orbit Lite 15', 1, N'Orbit', 19900, 0, 1, '2022-06-01'),
    (6, N'Nova Phone 12', 2, N'Nova', 21000, 25, 0, '2024-10-01'),
    (7, N'Nova Phone 12 Max', 2, N'Nova', 27500, 14, 0, '2024-10-01'),
    (8, N'Zenix Z5', 2, N'Zenix', 15800, 30, 0, '2025-01-12'),
    (9, N'Orbit A1', 2, N'Orbit', 7900, 40, 0, '2023-08-20'),
    (10, N'Orbit A0', 2, N'Orbit', 5200, 0, 1, '2021-04-11');
INSERT INTO Products (ProductID, ProductName, CategoryID, Brand, UnitPrice, StockQty, Discontinued, LaunchDate) VALUES
    (11, N'Nova Tab 11', 3, N'Nova', 18500, 10, 0, '2024-11-05'),
    (12, N'Zenix Pad Mini', 3, N'Zenix', 11200, 0, 0, '2025-03-03'),
    (13, N'USB-C Charger 65W', 4, N'Nova', 950, 120, 0, '2023-02-14'),
    (14, N'Wireless Mouse', 4, N'Zenix', 650, 85, 0, '2023-05-01'),
    (15, N'Laptop Sleeve 14"', 4, NULL, 450, 60, 0, '2022-09-09'),
    (16, N'USB-C Hub 7-in-1', 4, NULL, 1800, 35, 0, '2024-01-20'),
    (17, N'Mechanical Keyboard', 4, N'Zenix', 2400, 22, 0, '2024-06-30'),
    (18, N'Phone Case Clear', 4, NULL, 250, 200, 0, '2022-01-01'),
    (19, N'Nova Buds 2', 5, N'Nova', 3900, 45, 0, '2024-04-18'),
    (20, N'Zenix Studio Headphones', 5, N'Zenix', 7600, 15, 0, '2025-04-02');
INSERT INTO Products (ProductID, ProductName, CategoryID, Brand, UnitPrice, StockQty, Discontinued, LaunchDate) VALUES
    (21, N'Orbit Mini Speaker', 5, N'Orbit', 1450, 0, 1, '2021-11-25'),
    (22, N'Smart Plug Duo', 6, N'Orbit', 780, 70, 0, '2025-06-15'),
    (23, N'Nova Home Camera', 6, N'Nova', 3200, 18, 0, '2025-07-01'),
    (24, N'Smart Bulb RGB', 6, NULL, 420, 0, 0, '2025-08-10');

INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, City, Segment, JoinDate) VALUES
    (1, N'Ahmed', N'Hassan', N'ahmed.hassan@mail.com', N'01013356886', N'Cairo', N'Consumer', '2024-10-08'),
    (2, N'Mona', N'Adel', N'mona.adel@mail.com', N'01139958838', N'Alexandria', N'Consumer', '2024-05-22'),
    (3, N'Omar', N'Fathy', N'omar.fathy@mail.com', N'01083197857', N'Giza', N'Business', '2024-03-30'),
    (4, N'Sara', N'Mostafa', NULL, N'01514265799', N'Cairo', N'Consumer', '2024-01-31'),
    (5, N'Youssef', N'Samir', N'youssef.samir@mail.com', N'01039345092', N'Alexandria', N'Consumer', '2024-08-26'),
    (6, N'Nour', N'Ibrahim', N'nour.ibrahim@mail.com', N'01085329037', N'Mansoura', N'Business', '2024-07-22'),
    (7, N'Karim', N'Nabil', N'karim.nabil@mail.com', NULL, N'Cairo', N'Consumer', '2025-04-04'),
    (8, N'Hana', N'Saeed', N'hana.saeed@mail.com', N'01210872248', N'Tanta', N'Consumer', '2024-06-12'),
    (9, N'Mahmoud', N'Farouk', N'mahmoud.farouk@mail.com', N'01555667651', N'Giza', N'Business', '2024-10-11'),
    (10, N'Laila', N'Ashraf', N'laila.ashraf@mail.com', N'01138898923', N'Alexandria', N'Consumer', '2024-12-10');
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, City, Segment, JoinDate) VALUES
    (11, N'Tarek', N'Mansour', NULL, NULL, N'Cairo', N'Consumer', '2025-01-24'),
    (12, N'Dina', N'Kamal', N'dina.kamal@mail.com', N'01058181396', N'Alexandria', N'Consumer', '2024-12-18'),
    (13, N'Hassan', N'Ragab', N'hassan.ragab@mail.com', N'01215831819', N'Giza', N'Business', '2025-04-15'),
    (14, N'Salma', N'Sherif', N'salma.sherif@mail.com', N'01060806024', N'Cairo', N'Consumer', '2024-03-21'),
    (15, N'Ali', N'Zaki', N'ali.zaki@mail.com', N'01294374605', NULL, N'Consumer', '2025-01-05'),
    (16, N'Rana', N'Lotfy', N'rana.lotfy@mail.com', N'01119335534', N'Mansoura', N'Business', '2024-02-16'),
    (17, N'Khaled', N'Hamdy', NULL, N'01148840994', N'Cairo', N'Consumer', '2024-03-22'),
    (18, N'Mariam', N'Osman', N'mariam.osman@mail.com', N'01123556182', N'Tanta', N'Consumer', '2025-01-24'),
    (19, N'Amr', N'Gamal', N'amr.gamal@mail.com', NULL, N'Giza', N'Consumer', '2025-01-08'),
    (20, N'Yasmin', N'Fouad', N'yasmin.fouad@mail.com', N'01159684848', N'Alexandria', N'Business', '2024-12-29');

INSERT INTO Employees (EmployeeID, FirstName, LastName, JobTitle, Department, HireDate, Salary, Commission, ManagerID) VALUES
    (1, N'Sherif', N'Abdallah', N'General Manager', N'Management', '2018-01-15', 65000, NULL, NULL),
    (2, N'Nadia', N'Fawzy', N'Sales Manager', N'Sales', '2019-03-01', 42000, 0.03, 1),
    (3, N'Wael', N'Hosny', N'Sales Representative', N'Sales', '2021-06-10', 18000, 0.05, 2),
    (4, N'Reem', N'Shawky', N'Sales Representative', N'Sales', '2022-02-20', 17500, 0.05, 2),
    (5, N'Hesham', N'Badr', N'Sales Representative', N'Sales', '2023-09-01', 16000, 0.04, 2),
    (6, N'Aya', N'Morsy', N'Sales Representative', N'Sales', '2025-08-01', 15000, 0.04, 2),
    (7, N'Bassem', N'Lotfy', N'Support Lead', N'Support', '2020-05-05', 24000, NULL, 1),
    (8, N'Nermeen', N'Salah', N'Support Specialist', N'Support', '2023-01-12', 14000, NULL, 7);

INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate, ShippedDate, Status, Channel) VALUES
    (1001, 9, NULL, '2025-01-10', NULL, N'Cancelled', N'Online'),
    (1002, 4, NULL, '2025-01-20', NULL, N'Cancelled', N'Online'),
    (1003, 15, NULL, '2025-02-06', NULL, N'Pending', N'Online'),
    (1004, 3, 4, '2025-02-19', '2025-02-21', N'Delivered', N'Store'),
    (1005, 2, 2, '2025-02-25', '2025-03-02', N'Delivered', N'Store'),
    (1006, 7, 5, '2025-03-11', '2025-03-16', N'Delivered', N'Store'),
    (1007, 3, NULL, '2025-03-13', '2025-03-18', N'Delivered', N'Online'),
    (1008, 19, NULL, '2025-04-26', '2025-04-28', N'Delivered', N'Online'),
    (1009, 16, 3, '2025-05-20', '2025-05-25', N'Shipped', N'Store'),
    (1010, 1, NULL, '2025-06-06', '2025-06-09', N'Delivered', N'Online');
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate, ShippedDate, Status, Channel) VALUES
    (1011, 2, 3, '2025-07-28', NULL, N'Pending', N'Store'),
    (1012, 4, NULL, '2025-08-11', '2025-08-13', N'Delivered', N'Online'),
    (1013, 13, 5, '2025-08-11', '2025-08-13', N'Delivered', N'Store'),
    (1014, 14, NULL, '2025-08-28', '2025-08-29', N'Delivered', N'Online'),
    (1015, 13, NULL, '2025-09-02', '2025-09-04', N'Shipped', N'Online'),
    (1016, 4, NULL, '2025-09-14', '2025-09-19', N'Shipped', N'Online'),
    (1017, 9, NULL, '2025-09-14', '2025-09-15', N'Delivered', N'Online'),
    (1018, 1, NULL, '2025-09-29', '2025-10-02', N'Delivered', N'Online'),
    (1019, 1, NULL, '2025-10-05', '2025-10-06', N'Shipped', N'Online'),
    (1020, 8, NULL, '2025-10-05', NULL, N'Pending', N'Online');
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate, ShippedDate, Status, Channel) VALUES
    (1021, 4, 3, '2025-10-10', '2025-10-12', N'Delivered', N'Store'),
    (1022, 8, NULL, '2025-10-17', NULL, N'Pending', N'Online'),
    (1023, 10, 5, '2025-10-24', '2025-10-29', N'Delivered', N'Store'),
    (1024, 11, 2, '2025-11-07', NULL, N'Cancelled', N'Store'),
    (1025, 13, 2, '2025-11-08', '2025-11-12', N'Delivered', N'Store'),
    (1026, 15, 3, '2025-11-09', '2025-11-10', N'Delivered', N'Store'),
    (1027, 13, 3, '2025-11-20', '2025-11-23', N'Delivered', N'Store'),
    (1028, 10, 2, '2025-12-02', '2025-12-03', N'Delivered', N'Store'),
    (1029, 2, 3, '2025-12-03', NULL, N'Pending', N'Store'),
    (1030, 1, NULL, '2025-12-11', NULL, N'Pending', N'Online');
INSERT INTO Orders (OrderID, CustomerID, EmployeeID, OrderDate, ShippedDate, Status, Channel) VALUES
    (1031, 8, 2, '2026-01-02', NULL, N'Pending', N'Store'),
    (1032, 13, NULL, '2026-02-14', '2026-02-17', N'Delivered', N'Online'),
    (1033, 19, NULL, '2026-02-19', NULL, N'Cancelled', N'Online'),
    (1034, 17, NULL, '2026-03-01', '2026-03-02', N'Delivered', N'Online'),
    (1035, 14, 4, '2026-03-27', '2026-04-01', N'Shipped', N'Store'),
    (1036, 10, NULL, '2026-03-27', '2026-04-01', N'Delivered', N'Online'),
    (1037, 9, 2, '2026-04-16', '2026-04-21', N'Delivered', N'Store'),
    (1038, 11, NULL, '2026-05-17', NULL, N'Pending', N'Online'),
    (1039, 9, 4, '2026-06-01', NULL, N'Pending', N'Store'),
    (1040, 6, 3, '2026-06-10', NULL, N'Pending', N'Store');

INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
    (1, 1001, 15, 2, 450, 0),
    (2, 1002, 6, 2, 21000, 0.05),
    (3, 1003, 18, 2, 250, 0),
    (4, 1004, 6, 2, 21000, 0.15),
    (5, 1004, 16, 4, 1800, 0.1),
    (6, 1005, 6, 1, 21000, 0),
    (7, 1005, 2, 1, 52000, 0.1),
    (8, 1005, 18, 1, 250, 0.15),
    (9, 1006, 18, 5, 250, 0),
    (10, 1006, 9, 3, 7900, 0.15);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
    (11, 1007, 7, 2, 27500, 0.15),
    (12, 1007, 17, 4, 2400, 0),
    (13, 1008, 16, 2, 1800, 0),
    (14, 1008, 5, 2, 19900, 0),
    (15, 1008, 15, 1, 450, 0.05),
    (16, 1009, 17, 4, 2400, 0),
    (17, 1009, 8, 1, 15800, 0),
    (18, 1009, 23, 3, 3200, 0.05),
    (19, 1010, 19, 1, 3900, 0),
    (20, 1010, 5, 1, 19900, 0);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
    (21, 1010, 15, 1, 450, 0),
    (22, 1011, 13, 2, 950, 0),
    (23, 1011, 11, 1, 18500, 0.15),
    (24, 1012, 3, 1, 34900, 0),
    (25, 1012, 8, 1, 15800, 0.05),
    (26, 1013, 11, 2, 18500, 0.15),
    (27, 1014, 23, 1, 3200, 0),
    (28, 1015, 5, 1, 19900, 0),
    (29, 1016, 20, 2, 7600, 0.05),
    (30, 1016, 15, 3, 450, 0);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
    (31, 1017, 3, 2, 34900, 0.1),
    (32, 1017, 15, 3, 450, 0),
    (33, 1017, 20, 1, 7600, 0.15),
    (34, 1018, 4, 2, 61000, 0.05),
    (35, 1019, 23, 3, 3200, 0),
    (36, 1019, 6, 1, 21000, 0.05),
    (37, 1019, 19, 2, 3900, 0),
    (38, 1020, 4, 2, 61000, 0),
    (39, 1020, 11, 2, 18500, 0),
    (40, 1021, 7, 2, 27500, 0.05);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
    (41, 1021, 9, 1, 7900, 0),
    (42, 1022, 13, 4, 950, 0.15),
    (43, 1022, 18, 5, 250, 0),
    (44, 1023, 5, 1, 19900, 0),
    (45, 1023, 7, 1, 27500, 0.1),
    (46, 1024, 5, 1, 19900, 0),
    (47, 1025, 14, 5, 650, 0),
    (48, 1025, 11, 1, 18500, 0.05),
    (49, 1026, 11, 2, 18500, 0.1),
    (50, 1026, 7, 2, 27500, 0.15);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
    (51, 1027, 18, 1, 250, 0),
    (52, 1027, 16, 2, 1800, 0),
    (53, 1028, 11, 1, 18500, 0),
    (54, 1028, 8, 2, 15800, 0),
    (55, 1029, 8, 1, 15800, 0),
    (56, 1030, 8, 1, 15800, 0.15),
    (57, 1030, 9, 1, 7900, 0.05),
    (58, 1031, 22, 2, 780, 0),
    (59, 1031, 5, 1, 19900, 0.05),
    (60, 1032, 12, 1, 11200, 0.05);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
    (61, 1032, 3, 2, 34900, 0.1),
    (62, 1033, 14, 1, 650, 0.05),
    (63, 1034, 2, 2, 52000, 0.15),
    (64, 1035, 14, 5, 650, 0),
    (65, 1036, 13, 4, 950, 0),
    (66, 1037, 14, 4, 650, 0.05),
    (67, 1038, 5, 2, 19900, 0),
    (68, 1038, 23, 1, 3200, 0.1),
    (69, 1038, 17, 5, 2400, 0.05),
    (70, 1039, 4, 2, 61000, 0);
INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity, UnitPrice, Discount) VALUES
    (71, 1039, 11, 1, 18500, 0),
    (72, 1039, 18, 2, 250, 0.1),
    (73, 1040, 5, 3, 19900, 0);

GO


/* ============================ QUICK CHECK ============================
   Expected row counts:
     Categories 7 | Products 24 | Customers 20 | Employees 8 | Orders 40 | OrderItems 73
   ===================================================================== */
SELECT 'Categories' AS TableName, COUNT(*) AS RowsLoaded FROM Categories UNION ALL
SELECT 'Products',   COUNT(*) FROM Products   UNION ALL
SELECT 'Customers',  COUNT(*) FROM Customers  UNION ALL
SELECT 'Employees',  COUNT(*) FROM Employees  UNION ALL
SELECT 'Orders',     COUNT(*) FROM Orders     UNION ALL
SELECT 'OrderItems', COUNT(*) FROM OrderItems;
GO
