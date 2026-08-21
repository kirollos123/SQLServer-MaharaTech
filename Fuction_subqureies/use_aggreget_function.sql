use iti_new
SELECT Salary
FROM Instructor
USE iti_new;

WITH
    CTE
    AS
    (
        SELECT *,
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
        FROM Instructor
    )
UPDATE CTE
SET Salary = CASE rn
    WHEN 1 THEN 5000
    WHEN 2 THEN 6000
    WHEN 3 THEN 7000
    WHEN 4 THEN 8000
    WHEN 5 THEN 9000
    WHEN 6 THEN 10000
    WHEN 7 THEN 11000
    WHEN 8 THEN 12000
END;
SELECT Salary
FROM Instructor;
SELECT min (salary), MAX(salary)
FROM Instructor
SELECT
    COUNT(*) AS Total_Students,
    COUNT(st_id) AS Students_With_ID,
    COUNT(st_fname) AS Students_With_Name,
    COUNT(st_age) AS Students_With_Age
FROM Student;
SELECT (ISNULL(st_age,0))--hige perfomance 
from Student

SELECT avg (st_age)/COUNT(*)
from Student
SELECT sum (salary ) , dept_id
from Instructor
GROUP BY Dept_Id


SELECT sum (salary ) , d.dept_id , Dept_name

from Instructor i INNER JOIN Department  d
    on d.Dept_Id=i.Dept_Id

GROUP BY d.Dept_Id,Dept_name
SELECT count (st_id ),st_address,dept_id 
from Student
GROUP BY St_Address ,dept_id
SELECT count (st_id),dept_id 
 from Student
 GROUP BY Dept_Id
SELECT sum (salary) ,dept_id
from Instructor 
 where salary>1000
GROUP BY dept_id

SELECT sum (salary) ,dept_id
from Instructor 
 
GROUP BY dept_id
having sum (Salary)>30000

SELECT sum (salary) ,dept_id
from Instructor 
 
GROUP BY dept_id
having sum (Ins_Id)>6
--group by with having 
-- having withou group by 
SELECT SUM(salary ),AVG(salary)
FROM Instructor 
HAVING count (Ins_Id)<100
--subqure 
SELECT * 
from Student 
WHERE st_age <(select avg(st_age)FROM Student)--inner quruie
select * , (select count(st_id)from Student)
from Student
SELECT dept_name
from Department 
WHERE dept_id  in (
    select distinct Dept_Id
    from Student 
    WHERE Dept_Id is not Null
) 
SELECT distinct dept_name
from Student  s INNER JOIN Department D 
on d.Dept_Id =s.Dept_Id 
SELECT *
from  Student 
WHERE St_Age > ALL (select distinct st_age from Student WHERE St_Address ='cairo')
--join _dml 
--sub +dml 
DELETE from Stud_Course 
where st_id ='sd'
----------
DELETE from Stud_Course 
where st_id in (select st_id
from Student s INNER JOIN Department d 
on d.Dept_Id =s.Dept_Id and Dept_Name ='sd')
----------
--union
-- batch 
-- sef of indebnednt queries 
SELECT st_fname as [names]
from Student 
UNION ALL
SELECT ins_name 
FROM Instructor 
----------------
SELECT  CONVERT( varchar(10),St_Id) as [student]
from Student 
UNION ALL
SELECT ins_name 
FROM Instructor 
-- union --distinct  order _uniqe+  data 
select st_fname as names 
from Student 
UNION 
SELECT ins_name 
from Instructor
------
select  St_Fname  
from student 
INTERSECT 
SELECT ins_name 
from Instructor 

-----------
select  St_Fname   ,St_Id
from student 
INTERSECT 
SELECT ins_name ,Ins_Id
from Instructor 
------------
select  St_Fname   
from student 
EXCEPT  ---EXCEPTion after that 

SELECT ins_name 
from Instructor 
-----
SELECT st_fname  +' '+st_lname  as fallname
from Student
ORDER BY fullname

-----
SELECT st_fname  +' '+st_lname  as fallname
from Student
WHERE fullname=' kirollos nabil '

---- 
select *
from (SELECT st_fname +''+st_lname as  fullname
          from Student) as newtable
where fullname ='ahmed hassan'
-- -------bulit in fnction
-- Built-in Functions
-- │
-- ├── Aggregate Functions
-- │   ├── COUNT()
-- │   ├── SUM()
-- │   ├── AVG()
-- │   ├── MIN()
-- │   └── MAX()
-- │
-- ├── String Functions
-- │   ├── LEN()
-- │   ├── UPPER()
-- │   ├── LOWER()
-- │   └── CONCAT()
-- │
-- ├── Date & Time Functions
-- │   ├── GETDATE()
-- │   ├── DATEPART()
-- │   └── DATEDIFF()
-- │
-- ├── Mathematical Functions
-- │   ├── ROUND()
-- │   ├── CEILING()
-- │   └── FLOOR()
-- │
-- ├── NULL Functions
-- │   ├── ISNULL()
-- │   └── COALESCE()
-- │
-- └── Conditional Logic
--     └── CASE
SELECT DB_NAME()
SELECT SUSER_NAME() 
select HOST_NAME()
if OBJECT_ID('exam') is null 
CREATE TABLE exam
    (
      id int , 
      edate VARCHAR (10)
    )
SELECT  COL_NAME(OBJECT_ID('student '),2)
SELECT IDENT_CURRENT('student')
-- NOW() – Current date and time (MySQL)
-- CURRENT_DATE – Current date
-- CURRENT_TIME – Current time
-- DATE_ADD() – Add time interval
-- DATE_SUB() – Subtract time interval
-- DATEDIFF() – Difference between dates
-- DATE_FORMAT() – Format date
-- YEAR(), MONTH(), DAY() – Extract date parts
-- HOUR(), MINUTE(), SECOND() – Extract time parts
-- EXTRACT() – Extract any part of a date/time (PostgreSQL, MySQL)
SELECT GETDATE()
SELECT YEAR(GETDATE())
SELECT day(GETDATE())
SELECT MONTH(GETDATE())
SELECT DATEPART(MONTH,GETDATE())
SELECT DATENAME(MONTH,GETDATE())
SELECT dept_name ,year(manager_hiredate)
from Department 
-----
SELECT dept_name ,DATEDIFF(year,manager_hiredate,GETDATE())
from Department 
select DATEFROMPARTS(2000,3,23 )
SELECT ISDATE('1/1/2000')
SELECT DATEADD(day,7,GETDATE())
SELECT CONVERT(VARCHAR(50),GETDATE() )
SELECT cast(GETDATE()as varchar(50))

SELECT CONVERT(VARCHAR(50),GETDATE() ,101)
SELECT CONVERT(VARCHAR(50),GETDATE() ,105)
SELECT FORMAT( GETDATE(),'dd-mm-yyyy')
--nu
SELECT isNULL(st_fname,st_lname)
FROM Student 
SELECT coalesce(st_fname,st_address ,'no data')
from Student
SELECT nullif('ahmed','amr')
---string fun
SELECT isnull (st_fname,'')+''+CONVERT(varchar(20),ISNULL (st_age,0))
from student
SELECT CONCAT (st_fname,' ',st_age)
from Student
SELECT CONCAT ('stud name= ',st_fname,'&age= ',st_age)
from Student
select string_agg (st_fname,'')
from Student
select * from string_split('c#,mvc ,gtmal ',',') 
CREATE table mydata
(
    eid int PRIMARY KEy ,
    ename VARCHAR(20),
    skills VARCHAR(40)
)
SELECT * from mydata 

SELECT eid ,ename ,value
from mydata cross apply string_split(skills,',') 
---aggtegetion function 
----math function 
--cass stetemnt 
SELECT ins_name ,salary 
from Instructor 
SELECT ins_name,
    case
      when salary>=3000 then 'high salary'
      when salary <3000 then 'low'
      end 
from Instructor
SELECT ins_name,
    case gender 
      when 'f' then 'female'
      when 'm' then 'male'
      end as gend
from Instructor

SELECT ins_name, iif (salary>=3000,'high','low')
from  Instructor
UPDATE Instructor 
set Salary =Salary *1.20
SELECT salary from  Instructor
UPDATE Instructor 
    set salary =
         case 
            when Salary >=3000then salary *1.20
            else salary *1.10
        end
    