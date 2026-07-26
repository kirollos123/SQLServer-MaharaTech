USE ITI_new;
GO


--SELECT st_id, st_fname 

SELECT *
from Student
WHERE St_Address  in ('Cairo' ,'alex')


SELECT *
FROM Student
WHERE St_Age not BETWEEN 20 and 25
SELECT *
from Student
WHERE St_Age >22 and( St_Address='alex' or St_Address ='Cairo')
SELECT distinct st_fname
from Student

SELECT distinct St_Age
from Student

SELECT distinct st_age , st_fname
from Student
SELECT st_fname +SPACE(4)+CONVERT(varchar(10),st_age)
FROM Student
