USE iti_new;
GO

UPDATE sc
SET Grade = Grade + 10
FROM dbo.Stud_Course AS sc
JOIN dbo.Student AS s
    ON s.St_Id = sc.St_Id
WHERE s.St_Address = 'Cairo';
-----------------
DELETE sc
from Stud_Course sc ,course c 
where c.crs_id = sc.crs_id and crs_name ='sql server '