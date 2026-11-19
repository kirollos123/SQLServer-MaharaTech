USE TechNovaDB;
GO

DECLARE @ProductID INT = 14;
DECLARE @Quantity INT = 3;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Step 1: Decrease stock only if enough stock exists
    UPDATE Products
    SET StockQty = StockQty - @Quantity
    WHERE ProductID = @ProductID
      AND StockQty >= @Quantity;

    IF @@ROWCOUNT = 0
        THROW 50001, 'Product not found or insufficient stock.', 1;

    -- Step 2: Create the order
    INSERT INTO Orders
        (OrderID, CustomerID, EmployeeID,
         OrderDate, ShippedDate, Status, Channel)
    VALUES
        (9001, 1, NULL,
         CAST(GETDATE() AS DATE), NULL, N'Pending', N'Online');

    -- Step 3: Record the purchased product
    INSERT INTO OrderItems
        (OrderItemID, OrderID, ProductID,
         Quantity, UnitPrice, Discount)
    VALUES
        (9001, 9001, @ProductID, @Quantity, 650, 0);

    -- Demo only: undo all changes
    ROLLBACK TRANSACTION;

    PRINT 'Demo completed: all changes were rolled back.';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
SELECT ProductID, ProductName, StockQty
FROM Products
WHERE ProductID = 14;

SELECT *
FROM Orders
WHERE OrderID = 9001;

SELECT *
FROM OrderItems
WHERE OrderItemID = 9001;

UPDATE Products
SET StockQty = -5
WHERE ProductID = 14;