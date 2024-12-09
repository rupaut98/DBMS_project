--Create Database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- Create the Customers Table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY, -- Use IDENTITY for auto-increment
    Name VARCHAR(50),
    Email VARCHAR(50),
    Country VARCHAR(50),
    CreatedAt DATETIME
);