--self join unariy realtionship
select x.St_Fname as 'Student Name',y.St_Fname as 'leadername'
from student x ,student y
where y.St_Id =x.St_Id --(y ,pk,primary key,foreign key)
select x.St_Fname as 'Student Name',y.*
from student x ,student y
where y.St_Id =x.St_Id --(y ,pk,primary key,foreign key)