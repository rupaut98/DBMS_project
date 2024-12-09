--Create Database
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- Create the Customers Table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(50),
    Country VARCHAR(50),
    CreatedAt DATETIME
);