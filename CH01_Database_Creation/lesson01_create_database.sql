/*==========================================================
    ITI Database
==========================================================*/

USE master;
GO

IF DB_ID('ITI') IS NOT NULL
BEGIN
    ALTER DATABASE ITI SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ITI;
END
GO

CREATE DATABASE ITI;
GO

USE ITI;
GO

/*==========================================================
    Departments
==========================================================*/

CREATE TABLE Departments
(
    Dnum INT PRIMARY KEY,
    Dname NVARCHAR(50) NOT NULL,
    MGRSSN INT NULL,
    MGRStartDate DATE
);
GO

/*==========================================================
    Employee
==========================================================*/

CREATE TABLE Employee
(
    SSN INT NOT NULL,
    Fname NVARCHAR(30),
    Lname NVARCHAR(30),
    Bdate DATE,
    Address NVARCHAR(100),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    SuperSSN INT NULL,
    Dno INT NULL,

    CONSTRAINT PK_Employee PRIMARY KEY (SSN)
);
GO

/*==========================================================
    Project
==========================================================*/

CREATE TABLE Project
(
    Pnumber INT PRIMARY KEY,
    Pname NVARCHAR(50),
    Plocation NVARCHAR(50),
    City NVARCHAR(50),
    Dnum INT
);
GO

/*==========================================================
    Dependent
==========================================================*/

CREATE TABLE Dependent
(
    ESSN INT,
    Dependent_name NVARCHAR(50),
    Sex CHAR(1),
    Bdate DATE,

    CONSTRAINT PK_Dependent
        PRIMARY KEY (ESSN, Dependent_name)
);
GO

/*==========================================================
    Works_for
==========================================================*/

CREATE TABLE Works_for
(
    ESSn INT,
    Pno INT,
    Hours DECIMAL(5,2),

    CONSTRAINT PK_Works_for
        PRIMARY KEY (ESSn, Pno)
);
GO

/*==========================================================
    Foreign Keys
==========================================================*/

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Supervisor
FOREIGN KEY (SuperSSN)
REFERENCES Employee(SSN);
GO

ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Department
FOREIGN KEY (Dno)
REFERENCES Departments(Dnum);
GO

ALTER TABLE Departments
ADD CONSTRAINT FK_Department_Manager
FOREIGN KEY (MGRSSN)
REFERENCES Employee(SSN);
GO

ALTER TABLE Project
ADD CONSTRAINT FK_Project_Department
FOREIGN KEY (Dnum)
REFERENCES Departments(Dnum);
GO

ALTER TABLE Dependent
ADD CONSTRAINT FK_Dependent_Employee
FOREIGN KEY (ESSN)
REFERENCES Employee(SSN);
GO

ALTER TABLE Works_for
ADD CONSTRAINT FK_WorksFor_Employee
FOREIGN KEY (ESSn)
REFERENCES Employee(SSN);
GO

ALTER TABLE Works_for
ADD CONSTRAINT FK_WorksFor_Project
FOREIGN KEY (Pno)
REFERENCES Project(Pnumber);
GO

/*==========================================================
    Show Tables
==========================================================*/

SELECT name
FROM sys.tables;
GO

/*==========================================================
    Show Employee Structure
==========================================================*/

EXEC sp_help 'Employee';
GO