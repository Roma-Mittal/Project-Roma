-- TASK 1 LIBRARY MANAGEMENT SYSTEM
-- Database creation
create database Library_Management;

-- Query to use task 1 database
use Library_Management;

-- Query to create books table
CREATE TABLE Books (
    BOOK_ID INT PRIMARY KEY,
    TITLE VARCHAR(100),
    AUTHOR VARCHAR(100),
    GENRE VARCHAR(50),
    YEAR_PUBLISHED INT,
    AVAILABLE_COPIES INT
);

-- Query to insert data in books table
INSERT INTO Books (BOOK_ID, TITLE, AUTHOR, GENRE, YEAR_PUBLISHED, AVAILABLE_COPIES) VALUES
(1, '2 States', 'Chetan Bhagat', 'Romance', 2014, 20),
(2, 'Half Girlfriend', 'Chetan Bhagat', 'Romance', 2018, 25),
(3, 'Pride and Prejudice', 'Jane Austen', 'Romance', 1813, 6);

-- Query to create members table
CREATE TABLE Members (
    MEMBER_ID INT PRIMARY KEY,
    NAME VARCHAR(100),
    EMAIL VARCHAR(100),
    PHONE_NO VARCHAR(15),
    ADDRESS VARCHAR(200),
    MEMBERSHIP_DATE DATE
);

-- Query to insert data in members table
INSERT INTO Members (MEMBER_ID, NAME, EMAIL, PHONE_NO, ADDRESS, MEMBERSHIP_DATE) VALUES
(101, 'Roma Mittal', 'roma.mittal@gmail.com', '9876543210', 'Delhi, India', '2023-01-15'),
(102, 'Piyush Sharma', 'piyushsharma@gmail.com', '9123456789', 'Banglore, India', '2023-03-22'),
(103, 'Shilpa Shashidharan', 'shilpasashidharan@gmail.com', '9812345678', 'Kerela, India', '2023-05-10'),
(104, 'Divyanshi Chamoli', 'divyanshichamoli@gmail.com', '9988776655', 'Pune, India', '2023-02-01'),
(105, 'Rishabh Jain', 'rishabhjain@gmail.com', '9090909090', 'Chennai, India', '2023-07-08');

-- Query to create Borrowing Records table
CREATE TABLE BorrowingRecords (
    BORROW_ID INT PRIMARY KEY,
    MEMBER_ID INT,
    BOOK_ID INT,
    BORROW_DATE DATE,
    RETURN_DATE DATE,
    FOREIGN KEY (MEMBER_ID) REFERENCES Members(MEMBER_ID),
    FOREIGN KEY (BOOK_ID) REFERENCES Books(BOOK_ID)
);

-- Query to insert data into borrowing Records
INSERT INTO BorrowingRecords (BORROW_ID, MEMBER_ID, BOOK_ID, BORROW_DATE, RETURN_DATE) VALUES
(1, 101, 2, '2024-12-01', '2024-12-15'),
(2, 102, 1, '2025-01-10', '2025-01-24'),
(3, 103, 3, '2025-02-05', '2025-02-20'),
(4, 104, 1, '2025-03-01', '2025-04-16'),
(5, 105, 3, '2025-04-12', '2025-04-27');

-- Information retrieval 
-- Retrieve a list of books currently borrowed by a specific member
SELECT 
    B.BOOK_ID,
    B.TITLE,
    B.AUTHOR,
    B.GENRE,
    BR.BORROW_DATE
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
WHERE BR.MEMBER_ID = 101 AND BR.RETURN_DATE IS Not NULL;

-- Find members who have overdue books (borrowed more than 30 days ago, not returned).
SELECT M.MEMBER_ID, M.NAME, M.EMAIL, B.TITLE, BR.BORROW_DATE
FROM BorrowingRecords BR
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
WHERE BR.RETURN_DATE IS NULL
AND BR.BORROW_DATE <= CURDATE() - INTERVAL 30 DAY;
    
-- Retrieve books by genre along with the count of available copies.
SELECT GENRE, SUM(AVAILABLE_COPIES) AS TOTAL_AVAILABLE_COPIES
FROM BOOKS
GROUP BY GENRE;
   
-- Find the most borrowed book(s) overall.
SELECT B.BOOK_ID, B.TITLE, B.AUTHOR, B.GENRE, COUNT(BR.BOOK_ID) AS TIMES_BORROWED
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY BR.BOOK_ID
HAVING COUNT(BR.BOOK_ID) = (
        SELECT 
            MAX(BorrowCount)
        FROM (
            SELECT 
                COUNT(BOOK_ID) AS BorrowCount
            FROM 
                BorrowingRecords
            GROUP BY 
                BOOK_ID
        ) AS BorrowStats
    );
    
-- Retrieve members who have borrowed books from at least three different genres.
SELECT B.BOOK_ID, B.TITLE, B.AUTHOR, B.GENRE, COUNT(BR.BOOK_ID) AS TIMES_BORROWED
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY BR.BOOK_ID
HAVING COUNT(BR.BOOK_ID) = (
        SELECT 
            MAX(BorrowCount)
        FROM (
            SELECT 
                COUNT(BOOK_ID) AS BorrowCount
            FROM 
                BorrowingRecords
            GROUP BY 
                BOOK_ID
        ) AS BorrowStats
    );

-- Calculate the total number of books borrowed per month.
SELECT DATE_FORMAT(BORROW_DATE, '%Y-%m') AS BORROW_MONTH, COUNT(*) AS TOTAL_BORROWED
FROM BorrowingRecords
GROUP BY BORROW_MONTH
ORDER BY BORROW_MONTH;
    
-- Find the top three most active members based on the number of books borrowed.
SELECT M.MEMBER_ID, M.NAME, COUNT(BR.BOOK_ID) AS TOTAL_BORROWED
FROM BorrowingRecords BR
JOIN Members M ON BR.MEMBER_ID = M.MEMBER_ID
GROUP BY M.MEMBER_ID, M.NAME
ORDER BY TOTAL_BORROWED DESC
LIMIT 3;

-- Retrieve authors whose books have been borrowed at least 10 times.
SELECT B.AUTHOR, COUNT(*) AS TIMES_BORROWED
FROM BorrowingRecords BR
JOIN Books B ON BR.BOOK_ID = B.BOOK_ID
GROUP BY B.AUTHOR
HAVING COUNT(*) >= 10
ORDER BY TIMES_BORROWED DESC;
    
-- Identify members who have never borrowed a book.
SELECT M.MEMBER_ID, M.NAME, M.EMAIL
FROM Members M
LEFT JOIN BorrowingRecords BR ON M.MEMBER_ID = BR.MEMBER_ID
WHERE BR.BORROW_ID IS NULL;
    
-- TASK 2 EMPLOYEE PAYROLL MANAGEMNET
-- payroll_database creation
CREATE DATABASE Payroll_Database;

-- Use Database query
USE Payroll_Database;

-- Query to create employees table
CREATE TABLE employees (
    EMPLOYEE_ID INT PRIMARY KEY,
    NAME TEXT NOT NULL,
    DEPARTMENT TEXT,
    EMAIL TEXT,
    PHONE_NO NUMERIC,
    JOINING_DATE DATE,
    SALARY NUMERIC,
    BONUS NUMERIC,
    TAX_PERCENTAGE NUMERIC
);

-- Insert 10 sample values in Payroll_Database
INSERT INTO employees (EMPLOYEE_ID, NAME, DEPARTMENT, EMAIL, PHONE_NO, JOINING_DATE, SALARY, BONUS, TAX_PERCENTAGE) VALUES
(1, 'Pooja Mishra', 'Finance', 'poojamishra@gmail.com', 9876543210, '2021-04-15', 60000, 5000, 10),
(2, 'Peeyush Sharma', 'IT', 'peeyush@gmail.com', 9876543211, '2020-08-01', 80000, 8000, 12),
(3, 'Shivani Gupta', 'HR', 'shivanigupta@gmail.com', 9876543212, '2022-01-10', 55000, 3000, 9),
(4, 'Deepak Manodi', 'Marketing', 'deepakmanodi@gmail.com', 9876543213, '2024-06-21', 72000, 6000, 11),
(5, 'Divyanshi Chamoli', 'Operations', 'divyanshi@gmail.com', 9876543214, '2023-02-11', 65000, 4000, 10),
(6, 'Rishabh Jain', 'Finance', 'rishabhjain@gmail.com', 9876543215, '2025-11-19', 70000, 4500, 10),
(7, 'Abhishek Rawat', 'IT', 'abhishek@gmail.com', 9876543216, '2020-03-25', 90000, 10000, 13),
(8, 'Neha Jain', 'IT', 'nehajain@gmail.com', 9876543217, '2021-09-05', 58000, 3500, 9),
(9, 'Rahul Sharma', 'Marketing', 'rahulsharma@gmail.com', 9876543218, '2022-05-30', 75000, 5000, 11),
(10, 'Roma Mittal', 'Operations', 'romamittal@gmail.com', 9876543219, '2023-07-01', 67000, 4200, 10);

-- Retrieve the list of employees sorted by salary in descending order.
SELECT * FROM employees ORDER BY SALARY DESC;

-- Find employees with a total compensation (SALARY + BONUS) greater than $100,000.
SELECT * FROM employees WHERE (SALARY + BONUS) > 100000;

-- Update the bonus for employees in the ‘Sales’ department by 10%.
-- updating 1 row data with sales department to update bonus in the same department.
UPDATE employees SET DEPARTMENT = 'Sales' WHERE EMPLOYEE_ID = 6;
UPDATE employees SET BONUS = BONUS * 1.10 WHERE DEPARTMENT = 'Sales';

-- getting error of safe update mode running query for that
SET SQL_SAFE_UPDATES = 0;

-- Calculate the net salary after deducting tax for all employees.
SELECT 
    EMPLOYEE_ID,
    NAME,
    SALARY,
    BONUS,
    TAX_PERCENTAGE,
    (SALARY + BONUS) AS TOTAL_COMPENSATION,
    (SALARY + BONUS) * (1 - TAX_PERCENTAGE / 100.0) AS NET_SALARY
FROM employees;

-- Retrieve the average, minimum, and maximum salary per department.
SELECT DEPARTMENT,
    AVG(SALARY) AS AVERAGE_SALARY,
    MIN(SALARY) AS MIN_SALARY,
    MAX(SALARY) AS MAX_SALARY
FROM employees
GROUP BY DEPARTMENT;

-- Retrieve employees who joined in the last 6 months.
SELECT * FROM employees WHERE JOINING_DATE >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- Group employees by department and count how many employees each has.
SELECT DEPARTMENT, COUNT(*) AS EMPLOYEE_COUNT FROM employees GROUP BY DEPARTMENT;

-- Find the department with the highest average salary.
SELECT DEPARTMENT,
AVG(SALARY) AS AVERAGE_SALARY
FROM employees
GROUP BY DEPARTMENT
ORDER BY AVERAGE_SALARY DESC
LIMIT 1;

-- Identify employees who have the same salary as at least one other employee.
SELECT * FROM employees
WHERE SALARY IN (
    SELECT SALARY
    FROM employees
    GROUP BY SALARY
    HAVING COUNT(*) > 1
);

-- TASK 3 ONLINE STORE ORDER MANAGEMENT
-- Query to create database online_store
CREATE DATABASE Online_Store;

-- Query to use online_store database
USE Online_Store;

-- Query to create customers table
CREATE TABLE Customers (
    CUSTOMER_ID INT AUTO_INCREMENT PRIMARY KEY,
    NAME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) UNIQUE NOT NULL,
    PHONE VARCHAR(15),
    ADDRESS TEXT
);

-- Query to create products table
CREATE TABLE Products (
    PRODUCT_ID INT AUTO_INCREMENT PRIMARY KEY,
    PRODUCT_NAME VARCHAR(100) NOT NULL,
    CATEGORY VARCHAR(50),
    PRICE DECIMAL(10, 2) NOT NULL,
    STOCK INT NOT NULL
);

-- Query to create orders table
CREATE TABLE Orders (
    ORDER_ID INT AUTO_INCREMENT PRIMARY KEY,
    CUSTOMER_ID INT,
    PRODUCT_ID INT,
    QUANTITY INT NOT NULL,
    ORDER_DATE DATE,
    FOREIGN KEY (CUSTOMER_ID) REFERENCES Customers(CUSTOMER_ID),
    FOREIGN KEY (PRODUCT_ID) REFERENCES Products(PRODUCT_ID)
);

-- Insert sample data in customers table
INSERT INTO Customers (NAME, EMAIL, PHONE, ADDRESS) VALUES
('Roma Mittal', 'romamittal@gmail.com', '9876543210', '101 Shakti Nagar'),
('Divyanshi Chamoli', 'divyanshi@gmail.com', '9876543211', '456 Talkatora Stadium'),
('Peeyush Sharma', 'peeyush@gmail.com', '9876543212', '789 Mangolpuri'),
('Rishabh Jain', 'rishabhjain@gmail.com', '9876543213', '321 Shahadra');

-- Insert sample data in Products table
INSERT INTO Products (PRODUCT_NAME, CATEGORY, PRICE, STOCK) VALUES
('T-Shirt', 'Apparel', 800.00, 80),
('Smartphone', 'Electronics', 35000.00, 50),
('Speaker', 'Electronics', 4000.00, 100),
('Shoes', 'Footwear', 3000.00, 40),
('Backpack', 'Accessories', 1500.00, 60);

-- Insert sample data in orders table
INSERT INTO Orders (CUSTOMER_ID, PRODUCT_ID, QUANTITY, ORDER_DATE) VALUES
(1, 1, 1, '2025-07-10'),  
(2, 2, 2, '2025-07-11'),  
(3, 3, 3, '2025-07-12'),  
(1, 4, 1, '2025-07-13'),  
(4, 5, 2, '2025-07-14'),  
(2, 1, 1, '2025-07-14');  

-- Retrieve all orders placed by a specific customer.
SELECT 
    o.ORDER_ID,
    c.NAME AS CUSTOMER_NAME,
    p.PRODUCT_NAME,
    o.QUANTITY,
    o.ORDER_DATE
FROM Orders o
JOIN Customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
WHERE c.NAME = 'Roma Mittal';

-- Find products that are out of stock.
SELECT * FROM Products WHERE STOCK = 0;

-- Calculate the total revenue generated per product.
SELECT 
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    SUM(p.PRICE * o.QUANTITY) AS TOTAL_REVENUE
FROM Orders o
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY p.PRODUCT_ID, p.PRODUCT_NAME;

-- Retrieve the top 5 customers by total purchase amount.
SELECT 
    c.CUSTOMER_ID,
    c.NAME AS CUSTOMER_NAME,
    SUM(p.PRICE * o.QUANTITY) AS TOTAL_PURCHASE_AMOUNT
FROM Orders o
JOIN Customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY c.CUSTOMER_ID, c.NAME
ORDER BY TOTAL_PURCHASE_AMOUNT DESC
LIMIT 5;

-- Find customers who placed orders in at least two different product categories.
SELECT 
    c.CUSTOMER_ID,
    c.NAME AS CUSTOMER_NAME,
    COUNT(DISTINCT p.CATEGORY) AS CATEGORY_COUNT
FROM Orders o
JOIN Customers c ON o.CUSTOMER_ID = c.CUSTOMER_ID
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY c.CUSTOMER_ID, c.NAME
HAVING CATEGORY_COUNT >= 2;

-- Find the month with the highest total sales.
SELECT 
    DATE_FORMAT(o.ORDER_DATE, '%Y-%m') AS ORDER_MONTH,
    SUM(p.PRICE * o.QUANTITY) AS TOTAL_SALES
FROM Orders o
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID
GROUP BY ORDER_MONTH
ORDER BY TOTAL_SALES DESC
LIMIT 1;

-- Identify products with no orders in the last 6 months.
SELECT * 
FROM Products
WHERE PRODUCT_ID NOT IN (
    SELECT DISTINCT PRODUCT_ID
    FROM Orders
    WHERE ORDER_DATE >= CURDATE() - INTERVAL 6 MONTH
);

-- Retrieve customers who have never placed an order.
SELECT c.* FROM Customers c
LEFT JOIN Orders o ON c.CUSTOMER_ID = o.CUSTOMER_ID
WHERE o.ORDER_ID IS NULL;

-- Calculate the average order value across all orders.
SELECT 
    AVG(p.PRICE * o.QUANTITY) AS AVERAGE_ORDER_VALUE
FROM Orders o
JOIN Products p ON o.PRODUCT_ID = p.PRODUCT_ID;

-- TASK 4 MOVIE RENTAL ANALYSIS SYSTEM
-- Query to create database
CREATE DATABASE MovieRental;

-- Query to use MovieRental database
USE MovieRental;

-- Query to create table rental_data
CREATE TABLE rental_data (
    MOVIE_ID INT,
    CUSTOMER_ID INT,
    GENRE VARCHAR(50),
    RENTAL_DATE DATE,
    RETURN_DATE DATE,
    RENTAL_FEE NUMERIC(6,2)
);

-- Query to insert data
INSERT INTO rental_data (MOVIE_ID, CUSTOMER_ID, GENRE, RENTAL_DATE, RETURN_DATE, RENTAL_FEE) VALUES
(101, 1, 'Action', '2025-07-01', '2025-07-03', 120.00),
(102, 2, 'Romance', '2025-06-15', '2025-06-18', 90.00),
(103, 3, 'Comedy', '2025-05-20', '2025-05-21', 75.00),
(104, 1, 'Action', '2025-04-10', '2025-04-13', 110.00),
(105, 4, 'Thriller', '2025-07-05', '2025-07-06', 100.00),
(106, 5, 'Action', '2025-07-07', '2025-07-08', 130.00),
(107, 2, 'Romance', '2025-07-10', '2025-07-12', 95.00),
(108, 3, 'Comedy', '2025-06-01', '2025-06-03', 80.00),
(109, 6, 'Action', '2025-05-01', '2025-05-03', 115.00),
(110, 1, 'Horror', '2025-07-12', '2025-07-13', 85.00),
(111, 7, 'Horror', '2025-07-14', '2025-07-15', 100.00),
(112, 2, 'Action', '2025-07-13', '2025-07-14', 125.00),
(113, 3, 'Comedy', '2025-04-22', '2025-04-23', 70.00),
(114, 4, 'Romance', '2025-03-15', '2025-03-17', 88.00),
(115, 5, 'Thriller', '2025-02-10', '2025-02-11', 105.00);

-- Drill Down: Analyze rentals from genre to individual movie level.
SELECT GENRE, MOVIE_ID, COUNT(*) AS RENTAL_COUNT, SUM(RENTAL_FEE) AS TOTAL_REVENUE
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, MOVIE_ID;

-- Rollup: Summarize total rental fees by genre and then overall.
SELECT IFNULL(GENRE, 'ALL GENRES') AS GENRE,
SUM(RENTAL_FEE) AS TOTAL_RENTAL_FEES
FROM rental_data
GROUP BY GENRE WITH ROLLUP;

-- Cube: Analyze total rental fees across combinations of genre, rental date, and customer.
-- Fees by GENRE
SELECT GENRE, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY GENRE;

-- Fees by RENTAL_DATE
SELECT RENTAL_DATE, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY RENTAL_DATE;

-- Fees by CUSTOMER_ID
SELECT CUSTOMER_ID, SUM(RENTAL_FEE) AS TOTAL_FEES
FROM rental_data
GROUP BY CUSTOMER_ID;

-- Slice: Extract rentals only from the ‘Action’ genre.
SELECT * FROM rental_data WHERE GENRE = 'Action';

-- Dice: Extract rentals where GENRE = 'Action' or 'Drama' and RENTAL_DATE is in the last 3 months.
SELECT * FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
AND RENTAL_DATE >= CURDATE() - INTERVAL 3 MONTH;




