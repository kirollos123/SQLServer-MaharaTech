INSERT INTO Employee (SSN, Fname, Lname, Bdate, Address, Sex, Salary, SuperSSN, Dno)
VALUES
(1001, 'Sara', 'Ahmed', '1980-05-12', 'Alexandria', 'F', 45000, NULL, 5),
(5030, 'Omar', 'Fathy', '1988-01-30', 'Mansoura', 'M', 42000, NULL, 1),
(3010, 'Karim', 'Hassan', '1985-07-15', 'Giza', 'M', 38000, 1001, 4),
(2005, 'Mohamed', 'Ali', '1990-03-20', 'Cairo', 'M', 30000, 1001, 5),
(4020, 'Nour', 'Sayed', '1992-11-02', 'Alexandria', 'F', 27000, 3010, 4);
INSERT INTO Departments (Dnum, Dname, MGRSSN, MGRStartDate)
VALUES
(1, 'Headquarters', NULL, NULL),
(4, 'Administration', NULL, NULL),
(5, 'Research', NULL, NULL);
UPDATE Departments SET MGRSSN = 1001, MGRStartDate = '2015-01-01' WHERE Dnum = 5;
UPDATE Departments SET MGRSSN = 3010, MGRStartDate = '2018-06-01' WHERE Dnum = 4;
SELECT * FROM Employee;
SELECT * FROM Departments;
