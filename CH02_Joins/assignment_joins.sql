USE Company_vsRion;
GO
SELECT * FROM Employee;
SELECT * FROM Departments;
SELECT * FROM Project;
SELECT * FROM Works_for;
SELECT * FROM Dependent;
USE Company_vsRion;
GO
-- 1. Display the Department id, name
-- and id and name of its manager.

SELECT 
    d.Dnum,
    d.Dname,
    e.SSN AS ManagerSSN,
    e.Fname + ' ' + e.Lname AS ManagerName
FROM Departments d
JOIN Employee e
    ON d.MGRSSN = e.SSN;


/* =====================================================
   2. Display the name of the departments
      and the name of the projects under its control
   ===================================================== */

SELECT 
    d.Dname,
    p.Pname
FROM Departments d
INNER JOIN Project p
    ON d.Dnum = p.Dnum;


/* =====================================================
   3. Display the full data about all the dependents
      associated with the name of the employee
      they depend on
   ===================================================== */

SELECT 
    d.*,
    e.Fname + ' ' + e.Lname AS EmployeeName
FROM Dependent d
INNER JOIN Employee e
    ON d.ESSN = e.SSN;


/* =====================================================
   4. Display the ID, name and location of the projects
      in Cairo or Alex city
   ===================================================== */

SELECT 
    Pnumber,
    Pname,
    Plocation
FROM Project
WHERE City IN ('Cairo', 'Alex');


/* =====================================================
   5. Display the full data of projects
      with a name starting with "a"
   ===================================================== */

SELECT *
FROM Project
WHERE Pname LIKE 'a%';


/* =====================================================
   6. Display all employees in department 30
      whose salary is between 1000 and 2000 LE monthly
   ===================================================== */

SELECT *
FROM Employee
WHERE Dno = 30
  AND Salary BETWEEN 1000 AND 2000;


/* =====================================================
   7. Retrieve the names of all employees in department 10
      who work >= 10 hours per week on "AL Rabwah" project
   ===================================================== */

SELECT 
    e.Fname + ' ' + e.Lname AS EmployeeName
FROM Employee e
INNER JOIN Works_for w
    ON e.SSN = w.ESSn
INNER JOIN Project p
    ON w.Pno = p.Pnumber
WHERE e.Dno = 10
  AND w.Hours >= 10
  AND p.Pname = 'AL Rabwah';


/* =====================================================
   8. Find the names of employees who are directly
      supervised by Kamel Mohamed
   ===================================================== */

SELECT 
    e.Fname + ' ' + e.Lname AS EmployeeName
FROM Employee e
INNER JOIN Employee supervisor
    ON e.Superssn = supervisor.SSN
WHERE supervisor.Fname = 'Kamel'
  AND supervisor.Lname = 'Mohamed';


/* =====================================================
   9. Retrieve the names of all employees and
      the names of the projects they are working on,
      sorted by project name
   ===================================================== */

SELECT 
    e.Fname + ' ' + e.Lname AS EmployeeName,
    p.Pname AS ProjectName
FROM Employee e
INNER JOIN Works_for w
    ON e.SSN = w.ESSn
INNER JOIN Project p
    ON w.Pno = p.Pnumber
ORDER BY p.Pname;


/* =====================================================
   10. For each project located in Cairo City,
       find:
       - Project number
       - Controlling department name
       - Department manager last name
       - Manager address
       - Manager birthdate
   ===================================================== */

SELECT 
    p.Pnumber,
    d.Dname AS DepartmentName,
    e.Lname AS ManagerLastName,
    e.Address,
    e.Bdate
FROM Project p
INNER JOIN Departments d
    ON p.Dnum = d.Dnum
INNER JOIN Employee e
    ON d.MGRSSN = e.SSN
WHERE p.City = 'Cairo';


/* =====================================================
   11. Display all data of the managers
   ===================================================== */

SELECT DISTINCT
    e.*
FROM Employee e
INNER JOIN Departments d
    ON e.SSN = d.MGRSSN;


/* =====================================================
   12. Display all employees data and their dependents,
       even if they have no dependents
   ===================================================== */

SELECT 
    e.*,
    d.Dependent_name,
    d.Sex AS DependentSex,
    d.Bdate AS DependentBdate
FROM Employee e
LEFT JOIN Dependent d
    ON e.SSN = d.ESSN;


/* =====================================================
   13. Insert your personal data
       Department = 30
       SSN = 102672
       Superssn = 112233
       Salary = 3000
   ===================================================== */

INSERT INTO Employee
(
    Fname,
    Lname,
    SSN,
    Bdate,
    Address,
    Sex,
    Salary,
    Superssn,
    Dno
)
VALUES
(
    'Kirollos',
    'Nabil',
    102672,
    '2001-01-01',
    'Alexandria',
    'M',
    3000,
    112233,
    30
);


/* =====================================================
   14. Insert your friend's data
       Department = 30
       SSN = 102660
       Salary and Superssn are not entered
   ===================================================== */

INSERT INTO Employee
(
    Fname,
    Lname,
    SSN,
    Bdate,
    Address,
    Sex,
    Dno
)
VALUES
(
    'FriendFirstName',
    'FriendLastName',
    102660,
    '2001-01-01',
    'Alexandria',
    'M',
    30
);


/* =====================================================
   15. Upgrade your salary by 20%
   ===================================================== */

UPDATE Employee
SET Salary = Salary * 1.20
WHERE SSN = 102672;


/* Check your new salary */

SELECT 
    SSN,
    Fname,
    Lname,
    Salary
FROM Employee
WHERE SSN = 102672;