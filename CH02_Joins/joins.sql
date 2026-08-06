use iti_new
--cartestion product
select St_fname ,dept_name
from Student cross join Department
-- inner join  --- equi join

select St_fname ,dept_name
from Student , Department
where Student.dept_id = Department.dept_id
---alies
select St_fname ,dept_name
from Student s , Department d
where s.dept_id = d.dept_id
select St_fname ,d.dept_name
from Student s , Department d
where s.dept_id = d.dept_id
-- opretion 
select St_fname ,d.dept_name
from Student s , Department d
where s.dept_id = d.dept_id and st_address = 'cairo'
order by St_fname 
---------
select St_fname ,d.dept_name
from Student s inner join Department d
on s.dept_id = d.dept_id --condition join
select St_fname ,d.dept_name
from Student s inner join Department d
on s.dept_id = d.dept_id and s.st_age > 23
 ---- outer join
select St_fname ,d.dept_name
from Student s left outer join Department d
on s.dept_id = d.dept_id
--right outer join
select St_fname ,d.dept_name  
from Student s right outer join Department d
on s.dept_id = d.dept_id  
--full outer join
select St_fname ,d.dept_name  
from Student s full outer join Department d
on s.dept_id = d.dept_id  
