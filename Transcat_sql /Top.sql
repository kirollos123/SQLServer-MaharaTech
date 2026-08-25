use ITI_new
select db_name()-- retrive bd
SELECT * 
from student
WHERE st_address='cairo'
-- TOP
SELECT top (2)*
from Student
SELECT top (5) st_fname
from Student
SELECT top (1)*
from Instructor  WHERE Salary >8000

SELECT top (2)max (salary)
from Instructor 
select top (2) salary 
from Instructor
ORDER BY  salary DESC
SELECT top (3)with ties * 
from student 
ORDER BY st_age DESC
---newID()
SELECT NEWID()
SELECT *, NEWID()as NEWId
from Student 
ORDER BY NEWId
SELECT top (1)* 
from Student 
ORDER BY NEWId()
CREATE table myusers
(
    userid UNIQUEIDENTIFIER PRIMARY KEY  DEFAULT NEWID() , 
    USERNAME VARCHAR(20),
    _password VARCHAR(20)
)
INSERT into myusers(USERNAME, _password) VALUES('kirollos','dgwddr')
SELECT * from myusers
---- obj full bath ---sever name db name schema name obj name 
select * from Student
SELECT * from project
---select into
--ddl 
--create table  copy tables 

SELECT  * into TABLE3
from Student

SELECT  * into HR.Student
from Student
SELECT  * into TABLE7
from Student
WHERE 1=2
SELECT *
from TABLE7
--bulk insert 
