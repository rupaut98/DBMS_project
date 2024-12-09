--Create Database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

DROP TABLE Orders;

-- Create the Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY, 
    Name VARCHAR(50),
    Email VARCHAR(50),
    Country VARCHAR(50),
    CreatedAt DATETIME
);

-- Create the Orders Table
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderAmount DECIMAL(10, 2),
    OrderDate DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--Populate Customers Table with 1k rows
SET NOCOUNT ON;

DECLARE @i INT = 1;

WHILE @i <= 1000
BEGIN
    INSERT INTO Customers (Name, Email, Country, CreatedAt)
    VALUES (
        CONCAT('Customer', @i), 
        CONCAT('customer', @i, '@example.com'),
        CASE 
            WHEN @i % 5 = 0 THEN 'USA'
            WHEN @i % 5 = 1 THEN 'Canada'
            WHEN @i % 5 = 2 THEN 'UK'
            WHEN @i % 5 = 3 THEN 'Australia'
            ELSE 'Germany'
        END,
        DATEADD(DAY, @i, '2020-01-01')
    );
    SET @i = @i + 1;
END;

--Populate Orders Table with 500k rows
SET NOCOUNT ON;

DECLARE @i INT = 1;

WHILE @i <= 500000
BEGIN
    INSERT INTO Orders (CustomerID, OrderAmount, OrderDate)
    VALUES (
        FLOOR(1 + (RAND() * 1000)), -- Random CustomerID between 1 and 1000
        ROUND(10 + (RAND() * 490), 2), -- Random OrderAmount between 10 and 500
        DATEADD(DAY, FLOOR(RAND() * 1000), '2022-01-01') -- Random OrderDate
    );
    SET @i = @i + 1;
END;

-- Verify Repopulated Data
SELECT COUNT(*) AS TotalOrders FROM Orders;

-- Checking if the tables are created and populated
SELECT COUNT(*) AS TotalCustomers FROM Customers;
SELECT COUNT(*) AS TotalOrders FROM Orders;

-- We will drop indexes to ensure that indexes aren't present in the operation
DROP INDEX IF EXISTS idx_country ON Customers;
DROP INDEX IF EXISTS idx_order_date ON Orders;

--query without partitioning
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT SUM(OrderAmount) AS TotalSales
FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31';
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;


--Create backup of orders table
SELECT *
INTO BackupOrders
FROM Orders;

DROP PARTITION SCHEME OrderDateRangePS;
DROP PARTITION FUNCTION OrderDateRangePF;

--create parition table
CREATE PARTITION FUNCTION OrderDateRangePF (DATETIME)
AS RANGE LEFT FOR VALUES (
    '2022-12-31', 
    '2023-12-31', 
    '2024-12-31'
);

--create partition scheme
CREATE PARTITION SCHEME OrderDateRangePS
AS PARTITION OrderDateRangePF
ALL TO ([PRIMARY]); 

--recreate table with partition scheme
DROP TABLE Orders;

CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderAmount DECIMAL(10, 2),
    OrderDate DATETIME,
    PRIMARY KEY (OrderDate, OrderID)
) ON OrderDateRangePS(OrderDate);

--repopulate table
INSERT INTO Orders (OrderID, CustomerID, OrderAmount, OrderDate)
SELECT OrderID, CustomerID, OrderAmount, OrderDate
FROM BackupOrders;

--query with partitioning
SET STATISTICS IO ON; 
SET STATISTICS TIME ON; 

SELECT SUM(OrderAmount) AS TotalSales
FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31';

SET STATISTICS IO OFF; 
SET STATISTICS TIME OFF; 

