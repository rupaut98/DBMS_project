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

--Populate Customers Table
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