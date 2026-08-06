use iti_new
-- join muitiple table
SELECT st_fname ,crs_name ,grade
from Student S ,stud_course Sc ,course c
WHERE s.St_Id =sc.St_Id and
c.crs_id =sc.crs_id


-------innner 
SELECT st_fname ,crs_name ,grade ,Dept_Name
from Student S  inner JOIN stud_course Sc on 
 s.St_Id =sc.St_Id 
 INNER JOIN
 Course c
  on c.crs_id =sc.crs_id
  INNER JOIN
department d
 on d.Dept_Id =s .Dept_Id
-- join and DML
