use  ITI_new
go
CREATE TABLE myemp 
(
    id int PRIMARY KEY IDENTITY (1,1),
    ename VARCHAR(20)
)
INSERT INTO myemp VALUES
('Ahmed'),
('Omar'),
('Youssef'),
('Mohamed'),
('Mahmoud'),
('Mostafa'),
('Karim'),
('Hassan'),
('Hossam'),
('Amr'),
('Tarek'),
('Khaled'),
('Sherif'),
('Adel'),
('Samir'),
('Fady'),
('Bassem'),
('Wael'),
('Peter'),
('George'),
('John'),
('Daniel'),
('Michael'),
('David'),
('James');

SELECT * from myemp
INSERT into myemp (id,ename)VALUES( 50,'mina')
set IDENTITY_INSERT myemp on 
SELECT @@IDENTITY
SELECT SCOPE_IDENTITY( )
select IDENT_CURRENT( 'myemp')
SELECT IDENT_INCR('myemp')
SELECT IDENT_SEED( 'myemp')
SELECT * from myemp
DELETE from myemp
DBCC checkident ('myemp', reseed)
SELECT  isnull (st_fname ,'student has no name')
from Student 
--WHERE st_fname is not null

