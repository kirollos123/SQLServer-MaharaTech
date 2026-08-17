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