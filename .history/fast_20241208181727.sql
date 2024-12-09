--Create Database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

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

--Populate Orders Table with 10k rows
SET NOCOUNT ON;

DECLARE @i INT = 1;

WHILE @i <= 10000
BEGIN
    INSERT INTO Orders (CustomerID, OrderAmount, OrderDate)
    VALUES (
        FLOOR(1 + (RAND() * 1000)), -- Random CustomerID between 1 and 1000
        ROUND(10 + (RAND() * 490), 2), -- Random OrderAmount between 10 and 500
        DATEADD(DAY, FLOOR(RAND() * 1000), '2022-01-01') -- Random OrderDate
    );
    SET @i = @i + 1;
END;