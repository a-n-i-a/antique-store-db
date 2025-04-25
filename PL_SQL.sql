//*BEGIN
    DBMS_OUTPUT.PUT_LINE('test output from PL/SQL.');
END;
/ *//

--GetAntiquesSalesInfo - retrieves information about sales of a specific antique item using a cursor -> useful for monitoring the sales of specific items
CREATE OR REPLACE PROCEDURE GetAntiquesSalesInfo (
    p_AntiqueID IN NUMBER
)
AS
    CURSOR c1 IS
        SELECT
            s.SaleID,
            sa.Quantity,
            sa.Subtotal,
            s.SaleDate,
            c.Name AS CustomerName,
            c.Email AS CustomerEmail
        FROM
            Antique_Sale sa
                INNER JOIN Sale s ON sa.SaleID = s.SaleID
                INNER JOIN AntiqueCustomer c ON s.ACustomerID = c.ACustomerID
        WHERE sa.AntiqueID = p_AntiqueID;

    v_SaleID NUMBER;
    v_Quantity NUMBER;
    v_Subtotal NUMBER;
    v_SaleDate DATE;
    v_CustomerName VARCHAR2(100);
    v_CustomerEmail VARCHAR2(100);

BEGIN
    OPEN c1;

    LOOP
        FETCH c1 INTO v_SaleID, v_Quantity, v_Subtotal, v_SaleDate, v_CustomerName, v_CustomerEmail;
        EXIT WHEN c1%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Sale ID: ' || v_SaleID);
        DBMS_OUTPUT.PUT_LINE('Quantity: ' || v_Quantity);
        DBMS_OUTPUT.PUT_LINE('Subtotal: ' || v_Subtotal);
        DBMS_OUTPUT.PUT_LINE('Sale Date: ' || v_SaleDate);
        DBMS_OUTPUT.PUT_LINE('Customer Name: ' || v_CustomerName);
        DBMS_OUTPUT.PUT_LINE('Customer Email: ' || v_CustomerEmail);
        DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;

    CLOSE c1;
END;
/

CALL GetAntiquesSalesInfo(1);



--2 UpdateCondition - updates the condition of antiques stored at a specific location.
CREATE OR REPLACE PROCEDURE UpdateCondition (
    p_ALocationID IN NUMBER,
    p_NewConditionID IN NUMBER
)
AS
    v_CountUpdated NUMBER := 0;
BEGIN
    UPDATE Antique
    SET Condition_ConditionID = p_NewConditionID
    WHERE ALocationID = p_ALocationID;

    v_CountUpdated := SQL%ROWCOUNT;

    IF v_CountUpdated = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No antiques found at the specified location.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Update successful for Location: ' || p_ALocationID);
        DBMS_OUTPUT.PUT_LINE('Number of antiques updated: ' || v_CountUpdated);
    END IF;
END;
/
--checkers if above procedure works
SELECT * FROM ANTIQUE WHERE ALOCATIONID = 3;
CALL UpdateCondition(3, 1);
SELECT * FROM ANTIQUE WHERE ALOCATIONID =  3;

--PreventLowStockDeletion - prevents deleting an antique item if it has associated sales
CREATE OR REPLACE TRIGGER PreventLowStockDeletion
    BEFORE DELETE
    ON Antique
    FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Antique_Sale
        WHERE AntiqueID = :OLD.AntiqueID
    ) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete antique with associated sales.');
    END IF;
END;
/
--checker if above trigger works
BEGIN
    DELETE FROM Antique WHERE AntiqueID = 1;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('This should not be deleted - this item has associated sale');
END;
/

--UpdateTotalAmount - recalculates the TotalAmount in the Sale table whenever an Antique_Sale is updated
CREATE OR REPLACE TRIGGER UpdateTotalAmount
    FOR INSERT OR UPDATE OR DELETE ON Antique_Sale
    COMPOUND TRIGGER
    TYPE SaleIDList IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    affectedSaleIDs SaleIDList;

BEFORE EACH ROW IS
BEGIN
    IF INSERTING OR UPDATING THEN
        affectedSaleIDs(:NEW.SaleID) := 1;
    END IF;

    IF DELETING THEN
        affectedSaleIDs(:OLD.SaleID) := 1;
    END IF;
END BEFORE EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR saleID IN affectedSaleIDs.FIRST .. affectedSaleIDs.LAST LOOP
                UPDATE Sale
                SET TotalAmount = (
                    SELECT NVL(SUM(Subtotal), 0)
                    FROM Antique_Sale
                    WHERE SaleID = affectedSaleIDs(saleID)
                )
                WHERE SaleID = affectedSaleIDs(saleID);
            END LOOP;
    END AFTER STATEMENT;

    END;
/

--checkers for above trigger
SELECT SaleID, TotalAmount FROM Sale WHERE SaleID = 1;

INSERT INTO Antique_Sale (AntiqueSaleID, AntiqueID, SaleID, Quantity, Subtotal) VALUES (1001, 3, 1, 1, 500.00);

SELECT SaleID, TotalAmount FROM Sale WHERE SaleID = 1;

UPDATE Antique_Sale SET Subtotal = 600.00 WHERE AntiqueSaleID = 1001;

SELECT SaleID, TotalAmount FROM Sale WHERE SaleID = 1;

DELETE FROM Antique_Sale WHERE AntiqueSaleID = 1001;

SELECT SaleID, TotalAmount FROM Sale WHERE SaleID = 1;

