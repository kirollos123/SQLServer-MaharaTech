-- 1. Restore Company DB then create the following queries

-- 2. Display the employee First name, last name, Salary and Department number.


-- 3. Display all the projects names, locations and the department which is responsible about it.


-- 4. If the company policy is to pay an annual commission for each employee 
--    with specific percent equals 10% of his/her annual salary,
--    display each employee full name and his annual commission in an ANNUAL COMM column (alias).


-- 5. Display the employees Id, name who earns more than 1000 LE monthly.


-- 6. Display the employees Id, name who earns more than 10000 LE annually.


-- 7. Display the names and salaries of the female employees


-- 8. Display each department id, name which managed by a manager with id equals 968574.


-- 9. Display the ids, names and locations of the projects which controlled with department 10.
use Company_SD ;
SELECT * FROM EMPLOYEE;
SELECT   Fname, lname, Salary ,dno 
from Employee;
SELECT  pname , Dnum,plocation
from Project ;

SELECT 
    FNAME + ' ' + LNAME AS Full_Name,
    (SALARY * 12) * 0.10 AS ANNUAL_COMM
FROM Employee;

SELECT fname ,SSN 

from EMPLOYEE
WHERE salary >1000 ;
SELECT fname, SSN
FROM EMPLOYEE
WHERE SALARY * 12 > 10000;
SELECT fname ,salary  
from employee
where sex = 'f';
SELECT name FROM sys.tables;
SELECT * FROM Departments;
SELECT Dnum, Dname
FROM Departments
WHERE MGRSSN = 968574;
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Project';