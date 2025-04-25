DROP TABLE ANTIQUE CASCADE CONSTRAINTS;
DROP TABLE ANTIQUECATEGORY CASCADE CONSTRAINTS;
DROP TABLE ANTIQUECUSTOMER CASCADE CONSTRAINTS;
DROP TABLE AntiqueEmployee CASCADE CONSTRAINTS;
DROP TABLE ANTIQUELOCATION CASCADE CONSTRAINTS;
DROP TABLE Antique_Sale CASCADE CONSTRAINTS;
DROP TABLE Auction CASCADE CONSTRAINTS;
DROP TABLE Condition CASCADE CONSTRAINTS;
DROP TABLE Role CASCADE CONSTRAINTS;
DROP TABLE Sale CASCADE CONSTRAINTS;
DROP TABLE Supplier CASCADE CONSTRAINTS;


CREATE TABLE Antique (
                         AntiqueID int  NOT NULL,
                         Name varchar2(100)  NOT NULL,
                         ACategoryID int  NOT NULL,
                         SupplierID int  NOT NULL,
                         Price decimal(10,2)  NOT NULL,
                         ALocationID int  NOT NULL,
                         Condition_ConditionID integer  NOT NULL,
                         CONSTRAINT Antique_pk PRIMARY KEY (AntiqueID)
) ;

CREATE TABLE AntiqueCategory (
                                 ACategoryID int  NOT NULL,
                                 Name varchar2(100)  NOT NULL,
                                 Description varchar2(200)  NULL,
                                 CONSTRAINT AntiqueCategory_pk PRIMARY KEY (ACategoryID)
) ;

CREATE TABLE AntiqueCustomer (
                                 ACustomerID int  NOT NULL,
                                 Name varchar2(100)  NOT NULL,
                                 Email varchar2(100)  NULL,
                                 Phone varchar2(20)  NULL,
                                 CONSTRAINT AntiqueCustomer_pk PRIMARY KEY (ACustomerID)
) ;

CREATE TABLE AntiqueEmployee (
                                 AEmployeeID int  NOT NULL,
                                 Name varchar2(100)  NOT NULL,
                                 ContactInfo varchar2(200)  NOT NULL,
                                 Role_RoleID integer  NOT NULL,
                                 CONSTRAINT AntiqueEmployee_pk PRIMARY KEY (AEmployeeID)
) ;

CREATE TABLE AntiqueLocation (
                                 ALocationID int  NOT NULL,
                                 Address varchar2(200)  NOT NULL,
                                 Capacity int  NOT NULL,
                                 CONSTRAINT AntiqueLocation_pk PRIMARY KEY (ALocationID)
) ;

CREATE TABLE Antique_Sale (
                              AntiqueSaleID int  NOT NULL,
                              AntiqueID int  NOT NULL,
                              SaleID int  NOT NULL,
                              Quantity int  NOT NULL,
                              Subtotal decimal(10,2)  NOT NULL,
                              CONSTRAINT Antique_Sale_pk PRIMARY KEY (AntiqueSaleID)
) ;

CREATE TABLE Auction (
                         AuctionID int  NOT NULL,
                         AntiqueID int  NOT NULL,
                         AuctionDate date  NOT NULL,
                         Auctioneer varchar2(100)  NOT NULL,
                         FinalPrice decimal(10,2)  NOT NULL,
                         ALocationID int  NOT NULL,
                         CONSTRAINT Auction_pk PRIMARY KEY (AuctionID)
) ;

CREATE TABLE Condition (
                           ConditionID integer  NOT NULL,
                           ConditionName varchar2(20)  NOT NULL,
                           CONSTRAINT Condition_pk PRIMARY KEY (ConditionID)
) ;

CREATE TABLE Role (
                      RoleID integer  NOT NULL,
                      RoleName varchar2(20)  NOT NULL,
                      CONSTRAINT Role_pk PRIMARY KEY (RoleID)
) ;

CREATE TABLE Sale (
                      SaleID int  NOT NULL,
                      ACustomerID int  NOT NULL,
                      AEmployeeID int  NOT NULL,
                      SaleDate date  NOT NULL,
                      TotalAmount decimal(10,2)  NOT NULL,
                      CONSTRAINT Sale_pk PRIMARY KEY (SaleID)
) ;

CREATE TABLE Supplier (
                          SupplierID int  NOT NULL,
                          Name varchar2(100)  NOT NULL,
                          ContactInfo varchar2(200)  NOT NULL,
                          Address varchar2(200)  NULL,
                          CONSTRAINT Supplier_pk PRIMARY KEY (SupplierID)
) ;


ALTER TABLE Antique ADD CONSTRAINT Antique_Condition
    FOREIGN KEY (Condition_ConditionID)
        REFERENCES Condition (ConditionID);

ALTER TABLE AntiqueEmployee ADD CONSTRAINT Employee_Role
    FOREIGN KEY (Role_RoleID)
        REFERENCES Role (RoleID);

ALTER TABLE Antique ADD CONSTRAINT FK_0
    FOREIGN KEY (ACategoryID)
        REFERENCES AntiqueCategory (ACategoryID);

ALTER TABLE Antique ADD CONSTRAINT FK_1
    FOREIGN KEY (SupplierID)
        REFERENCES Supplier (SupplierID);

ALTER TABLE Antique ADD CONSTRAINT FK_2
    FOREIGN KEY (ALocationID)
        REFERENCES AntiqueLocation (ALocationID);

ALTER TABLE Sale ADD CONSTRAINT FK_3
    FOREIGN KEY (ACustomerID)
        REFERENCES AntiqueCustomer (ACustomerID);

ALTER TABLE Sale ADD CONSTRAINT FK_4
    FOREIGN KEY (AEmployeeID)
        REFERENCES AntiqueEmployee (AEmployeeID);

ALTER TABLE Auction ADD CONSTRAINT FK_5
    FOREIGN KEY (AntiqueID)
        REFERENCES Antique (AntiqueID);

ALTER TABLE Auction ADD CONSTRAINT FK_6
    FOREIGN KEY (ALocationID)
        REFERENCES AntiqueLocation (ALocationID);

ALTER TABLE Antique_Sale ADD CONSTRAINT FK_7
    FOREIGN KEY (AntiqueID)
        REFERENCES Antique (AntiqueID);

ALTER TABLE Antique_Sale ADD CONSTRAINT FK_8
    FOREIGN KEY (SaleID)
        REFERENCES Sale (SaleID);


INSERT INTO AntiqueCategory (ACategoryID, Name, Description) VALUES (1, 'Furniture', 'Antique furniture items');
INSERT INTO AntiqueCategory (ACategoryID, Name, Description) VALUES (2, 'Paintings', 'Antique and vintage paintings');
INSERT INTO AntiqueCategory (ACategoryID, Name, Description) VALUES (3, 'Jewelry', 'Antique and vintage jewelry');
INSERT INTO AntiqueCategory (ACategoryID, Name, Description) VALUES (4, 'Books', 'Rare and antique books');

INSERT INTO Supplier (SupplierID, Name, ContactInfo, Address)
VALUES (1, 'Vintage Supplier Co.', 'vintage@suppliers.com', '123 Antique Road');
INSERT INTO Supplier (SupplierID, Name, ContactInfo, Address)
VALUES (2, 'Antique Artistry', 'artistry@suppliers.com', '456 Classic Ave');
INSERT INTO Supplier (SupplierID, Name, ContactInfo, Address)
VALUES (3, 'Timeless Treasures', 'contact@timeless.com', '789 Timeless Blvd');

INSERT INTO AntiqueLocation (ALocationID, Address, Capacity)
VALUES (1, 'Main Store', 100);
INSERT INTO AntiqueLocation (ALocationID, Address, Capacity)
VALUES (2, 'Storage Warehouse', 200);
INSERT INTO AntiqueLocation (ALocationID, Address, Capacity)
VALUES (3, 'Exhibition Hall', 300);

INSERT INTO Condition (ConditionID, ConditionName) VALUES (1, 'Excellent');
INSERT INTO Condition (ConditionID, ConditionName) VALUES (2, 'Good');
INSERT INTO Condition (ConditionID, ConditionName) VALUES (3, 'Fair');
INSERT INTO Condition (ConditionID, ConditionName) VALUES (4, 'Poor');

INSERT INTO Antique (AntiqueID, Name, ACategoryID, SupplierID, Price, ALocationID, Condition_ConditionID)
VALUES (1, 'Victorian Chair', 1, 1, 1200.00, 1, 1);
INSERT INTO Antique (AntiqueID, Name, ACategoryID, SupplierID, Price, ALocationID, Condition_ConditionID)
VALUES (2, 'Renaissance Painting', 2, 2, 5500.00, 2, 2);
INSERT INTO Antique (AntiqueID, Name, ACategoryID, SupplierID, Price, ALocationID, Condition_ConditionID)
VALUES (3, 'Gold Necklace', 3, 3, 2500.00, 3, 2);
INSERT INTO Antique (AntiqueID, Name, ACategoryID, SupplierID, Price, ALocationID, Condition_ConditionID)
VALUES (4, 'Shakespeare Folio', 4, 1, 7500.00, 1, 3);

INSERT INTO AntiqueCustomer (ACustomerID, Name, Email, Phone)
VALUES (1, 'Donald Chamberlin', 'donald.chamberlin@example.com', '123-456-7890');
INSERT INTO AntiqueCustomer (ACustomerID, Name, Email, Phone)
VALUES (2, 'Bill Gates', 'bill.gates@microsoft.com', '987-654-3210');
INSERT INTO AntiqueCustomer (ACustomerID, Name, Email, Phone)
VALUES (3, 'Michael Jordan', 'michael.jordan@example.com', '555-234-5678');
INSERT INTO AntiqueCustomer (ACustomerID, Name, Email, Phone)
VALUES (4, 'Raymond Boyce', 'raymond.boyce@example.com', '555-876-5432');

INSERT INTO Role (RoleID, RoleName) VALUES (1, 'Sales Manager');
INSERT INTO Role (RoleID, RoleName) VALUES (2, 'Auctioneer');
INSERT INTO Role (RoleID, RoleName) VALUES (3, 'Inventory Specialist');

INSERT INTO AntiqueEmployee (AEmployeeID, Name, ContactInfo, Role_RoleID)
VALUES (1, 'Alice Blue', 'alice.b@example.com', 1);
INSERT INTO AntiqueEmployee (AEmployeeID, Name, ContactInfo, Role_RoleID)
VALUES (2, 'Bob Brown', 'bob.b@example.com', 2);
INSERT INTO AntiqueEmployee (AEmployeeID, Name, ContactInfo, Role_RoleID)
VALUES (3, 'Charlie White', 'charlie.w@example.com', 3);

INSERT INTO Sale (SaleID, ACustomerID, AEmployeeID, SaleDate, TotalAmount)
VALUES (1, 1, 1, TO_DATE('2025-01-01', 'YYYY-MM-DD'), 1200.00);
INSERT INTO Sale (SaleID, ACustomerID, AEmployeeID, SaleDate, TotalAmount)
VALUES (2, 2, 2, TO_DATE('2025-01-03', 'YYYY-MM-DD'), 5500.00);
INSERT INTO Sale (SaleID, ACustomerID, AEmployeeID, SaleDate, TotalAmount)
VALUES (3, 3, 3, TO_DATE('2025-01-05', 'YYYY-MM-DD'), 2500.00);
INSERT INTO Sale (SaleID, ACustomerID, AEmployeeID, SaleDate, TotalAmount)
VALUES (4, 1, 1, SYSDATE, 1500.00);
INSERT INTO Sale (SaleID, ACustomerID, AEmployeeID, SaleDate, TotalAmount)
VALUES (5, 2, 2, SYSDATE, 7500.00);
INSERT INTO Sale (SaleID, ACustomerID, AEmployeeID, SaleDate, TotalAmount)
VALUES (6, 1, 1, SYSDATE, 1000.00);

INSERT INTO Auction (AuctionID, AntiqueID, AuctionDate, Auctioneer, FinalPrice, ALocationID)
VALUES (1, 2, TO_DATE('2025-01-02', 'YYYY-MM-DD'), 'Bob Brown', 6000.00, 2);
INSERT INTO Auction (AuctionID, AntiqueID, AuctionDate, Auctioneer, FinalPrice, ALocationID)
VALUES (2, 4, TO_DATE('2025-01-04', 'YYYY-MM-DD'), 'Charlie White', 8000.00, 3);

INSERT INTO Antique_Sale (AntiqueSaleID, AntiqueID, SaleID, Quantity, Subtotal)
VALUES (1, 1, 1, 1, 1200.00);
INSERT INTO Antique_Sale (AntiqueSaleID, AntiqueID, SaleID, Quantity, Subtotal)
VALUES (2, 2, 2, 1, 5500.00);
INSERT INTO Antique_Sale (AntiqueSaleID, AntiqueID, SaleID, Quantity, Subtotal)
VALUES (3, 3, 3, 1, 2500.00);