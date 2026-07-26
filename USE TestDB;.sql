USE TestDB;
GO
CREATE TABLE Employee (
    id INT,
    name VARCHAR(10),
    dept VARCHAR(10),
    ssn INT,
    salary INT
);
GO
INSERT INTO Employee
VALUES
(1,'Alice','Sales',123,2000),
(2,'Bob','Sales',456,3000),
(3,'Charlie','HR',345,5000),
(4,'John','Eng',987,2000),
(5,'Bob','Eng',678,4000),
(6,'Alice','IT',384,3000);
GO