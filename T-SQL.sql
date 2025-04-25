PRINT 'test';
--1 GetCustomerPurchaseHistory
ALTER PROCEDURE GetCustomerPurchaseHistory
    @CustomerID INT
AS
BEGIN
    PRINT 'Starting GetCustomerPurchaseHistory for CustomerID: ' + CAST(@CustomerID AS VARCHAR);

    SELECT SaleID, SaleDate, TotalAmount
    FROM Sale
    WHERE ACustomerID = @CustomerID;
END;

--checker if above procedure works
EXEC GetCustomerPurchaseHistory @CustomerID = 1;

SELECT s.SaleID, s.SaleDate, s.TotalAmount
FROM Sale s
WHERE s.ACustomerID = 1;

--2 TransferInventory - transfers antiques from one location to another
ALTER PROCEDURE TransferInventory
        @SourceLocationID INT,
        @TargetLocationID INT
AS
    BEGIN
        DECLARE @AntiqueID INT;
        DECLARE @ItemsTransferred INT = 0;

        DECLARE c2 CURSOR FOR
            SELECT AntiqueID
            FROM Antique
            WHERE ALocationID = @SourceLocationID;

        OPEN c2;

        FETCH NEXT FROM c2 INTO @AntiqueID;

        WHILE @@FETCH_STATUS = 0
            BEGIN
                UPDATE Antique
                SET ALocationID = @TargetLocationID
                WHERE AntiqueID = @AntiqueID;

                SET @ItemsTransferred = @ItemsTransferred + 1;

                FETCH NEXT FROM c2 INTO @AntiqueID;
        END;

        CLOSE c2;
        DEALLOCATE c2;

        PRINT 'Inventory transfer complete. Items transferred: ' + CAST(@ItemsTransferred AS NVARCHAR);
END;

--checker if above procedure works
EXEC TransferInventory @SourceLocationID = 3, @TargetLocationID = 1;


--3 PreventNegativeQuantity - prevents an update or insert in Antique_Sale that would result in a negative Quantity.
DROP TRIGGER PreventNegativeQuantity;
CREATE TRIGGER PreventNegativeQuantity
    ON Antique_Sale
    INSTEAD OF INSERT, UPDATE
    AS
    BEGIN
        DECLARE @NegativeQuantityCount INT;
        SELECT @NegativeQuantityCount = COUNT(*)
        FROM INSERTED
        WHERE Quantity < 0;

        IF @NegativeQuantityCount > 0
            BEGIN
                THROW 50001, 'Quantity cannot be negative.', 1;
                RETURN;
            END;

        INSERT INTO Antique_Sale (AntiqueSaleID, AntiqueID, SaleID, Quantity, Subtotal)
        SELECT AntiqueSaleID, AntiqueID, SaleID, Quantity, Subtotal
        FROM INSERTED;
END;

--checker if above trigger works
BEGIN TRY
    INSERT INTO Antique_Sale (AntiqueSaleID, AntiqueID, SaleID, Quantity, Subtotal)
    VALUES (2, 102, 2, -5, 700);
END TRY
BEGIN CATCH
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;

--4 TrackHighValueSales - logs sales where the TotalAmount exceeds a threshold.
DROP TRIGGER TrackHighValueSales;
    CREATE TRIGGER TrackHighValueSales
    ON Sale
    AFTER INSERT, UPDATE
    AS
BEGIN
    DECLARE @SaleID INT, @SaleDate DATETIME, @TotalAmount DECIMAL(10, 2);

    DECLARE c3 CURSOR FOR
        SELECT SaleID, SaleDate, TotalAmount
        FROM INSERTED
        WHERE TotalAmount > 5000;

    OPEN c3;

    FETCH NEXT FROM c3 INTO @SaleID, @SaleDate, @TotalAmount;

    WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT 'High-value sale detected: Sale ID ' + CAST(@SaleID AS NVARCHAR) +
                      ', Sale Date: ' + CAST(@SaleDate AS NVARCHAR) +
                      ', Total Amount: ' + CAST(@TotalAmount AS NVARCHAR);

            FETCH NEXT FROM c3 INTO @SaleID, @SaleDate, @TotalAmount;
        END;

    CLOSE c3;
    DEALLOCATE c3;
END;

--checker if above trigger works
UPDATE Sale
SET TotalAmount = 7000
WHERE SaleID = 1;
