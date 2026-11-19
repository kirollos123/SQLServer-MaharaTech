use ITI
SELECT *FROM Employee
CREATE DATABASE itidb ;
USE itidb;
GO
CREATE table Departments(
    did int PRIMARY KEY,
    dnname VARCHAR (20)
)
 create TABLE Employee(
     eid  int PRIMARY KEY ,
     ename VARCHAR (20)NOT NULL,
     eadd VARCHAR (30)default 'alex',
     hiredate DATE  DEFAULT GETDATE(),
     Salary int , 
     age int ,
     dnum int FOREIGN KEY REFERENCES Departments(did)

 )
 --  if want edit 
 ALTER TABLE Employee add OVERtime int 

 ALTER TABLE Employee add OVERtime bigint 
 ALTER TABLE Employee drop COLUMN OVERtime