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

--Populate Cus