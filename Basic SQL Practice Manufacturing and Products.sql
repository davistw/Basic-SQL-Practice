CREATE TABLE Manufacturers (
    Code INTEGER,
    Name VARCHAR(255) NOT NULL,
    PRIMARY KEY (Code)
);

CREATE TABLE Products (
    Code INTEGER,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Manufacturer INTEGER NOT NULL,
    PRIMARY KEY (Code),
    FOREIGN KEY (Manufacturer) REFERENCES Manufacturers(Code)
) ENGINE=INNODB;

-- Inserting data into Manufacturers table
INSERT INTO Manufacturers (Code, Name) VALUES (1, 'Sony');
INSERT INTO Manufacturers (Code, Name) VALUES (2, 'Creative Labs');
INSERT INTO Manufacturers (Code, Name) VALUES (3, 'Hewlett-Packard');
INSERT INTO Manufacturers (Code, Name) VALUES (4, 'Iomega');
INSERT INTO Manufacturers (Code, Name) VALUES (5, 'Fujitsu');
INSERT INTO Manufacturers (Code, Name) VALUES (6, 'Winchester');

-- Inserting data into Products table
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (1, 'Hard drive', 240.00, 5);
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (2, 'Memory', 120.00, 6);
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (3, 'ZIP drive', 150.00, 4);
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (4, 'Floppy disk', 5.00, 6);
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (5, 'Monitor', 240.00, 1);
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (6, 'DVD drive', 180.00, 2);
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (7, 'CD drive', 90.00, 2);
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (8, 'Printer', 270.00, 3);
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (9, 'Toner cartridge', 66.00, 3);
INSERT INTO Products (Code, Name, Price, Manufacturer) VALUES (10, 'DVD burner', 180.00, 2);




-- 1.1 Select the names of all the products in the store.
SELECT Name FROM Products;

-- 1.2 Select the names and the prices of all the products in the store.
SELECT Name, Price FROM Products;

-- 1.3 Select the name of the products with a price less than or equal to $200.
SELECT Name FROM Products WHERE Price <= 200;

-- 1.4 Select all the products with a price between $60 and $120.
SELECT * FROM Products WHERE Price BETWEEN 60 AND 120;

-- Alternative:
SELECT * FROM Products WHERE Price >= 60 AND Price <= 120;

-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
SELECT Name, Price * 100 FROM Products;

-- Alternative with string formatting:
SELECT Name, CONCAT(Price * 100, ' cents') FROM Products;

-- 1.6 Compute the average price of all the products.
SELECT AVG(Price) FROM Products;

-- Alternative:
SELECT SUM(Price) / COUNT(Price) FROM Products;

-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
SELECT AVG(Price) FROM Products WHERE Manufacturer = 2;

-- 1.8 Compute the number of products with a price larger than or equal to $180.
SELECT COUNT(*) FROM Products WHERE Price >= 180;

-- 1.9 Select the name and price of all products with a price larger than or equal to $180, sorted by price (descending) and name (ascending).
SELECT Name, Price FROM Products WHERE Price >= 180 ORDER BY Price DESC, Name ASC;

-- 1.10 Select all the data from the products, including all the data for each product's manufacturer.
SELECT a.*, b.Name AS ManufacturerName 
FROM Products a 
JOIN Manufacturers b ON a.Manufacturer = b.Code;

-- Alternative:
SELECT a.*, b.Name AS ManufacturerName 
FROM Products a, Manufacturers b 
WHERE a.Manufacturer = b.Code;

-- 1.11 Select the product name, price, and manufacturer name of all the products.
SELECT a.Name, a.Price, b.Name AS ManufacturerName 
FROM Products a 
JOIN Manufacturers b ON a.Manufacturer = b.Code;

-- Alternative:
SELECT Products.Name, Price, Manufacturers.Name 
FROM Products 
INNER JOIN Manufacturers ON Products.Manufacturer = Manufacturers.Code;

-- 1.12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
SELECT AVG(Price), Manufacturer 
FROM Products 
GROUP BY Manufacturer;

-- 1.13 Select the average price of each manufacturer's products, showing the manufacturer's name.
SELECT AVG(a.Price), b.Name 
FROM Products a 
JOIN Manufacturers b ON a.Manufacturer = b.Code 
GROUP BY b.Name;

-- 1.14 Select the names of manufacturers whose products have an average price larger than or equal to $150.
SELECT AVG(a.Price), b.Name 
FROM Manufacturers b 
JOIN Products a ON b.Code = a.Manufacturer 
GROUP BY b.Name 
HAVING AVG(a.Price) >= 150;

-- Alternative:
SELECT AVG(Price), Manufacturers.Name 
FROM Products, Manufacturers 
WHERE Products.Manufacturer = Manufacturers.Code 
GROUP BY Manufacturers.Name 
HAVING AVG(Price) >= 150;

-- 1.15 Select the name and price of the cheapest product.
SELECT Name, Price 
FROM Products 
WHERE Price = (SELECT MIN(Price) FROM Products);

-- 1.16 Select the name of each manufacturer along with the name and price of its most expensive product.
SELECT max_price_mapping.Name AS ManuName, max_price_mapping.Price, products_with_manu_name.Name AS ProductName
FROM (
    SELECT Manufacturers.Name, MAX(Price) Price
    FROM Products 
    JOIN Manufacturers ON Manufacturer = Manufacturers.Code
    GROUP BY Manufacturers.Name
) AS max_price_mapping
LEFT JOIN (
    SELECT Products.*, Manufacturers.Name AS ManuName
    FROM Products 
    JOIN Manufacturers ON Products.Manufacturer = Manufacturers.Code
) AS products_with_manu_name 
ON max_price_mapping.Name = products_with_manu_name.ManuName 
AND max_price_mapping.Price = products_with_manu_name.Price;

-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
INSERT INTO Products (Code, Name, Price, Manufacturer) 
VALUES (11, 'Loudspeakers', 70, 2);

-- 1.18 Update the name of product 8 to "Laser Printer".
UPDATE Products 
SET Name = 'Laser Printer' 
WHERE Code = 8;

-- 1.19 Apply a 10% discount to all products.
UPDATE Products 
SET Price = Price * 0.9;

-- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120.
UPDATE Products 
SET Price = Price * 0.9 
WHERE Price >= 120;



