select * from employees1;
-- 1. High Salary Employees
-- Use a CTE to find employees with Salary > 55,000.
-- (Then select only their names in the final query).
with EmpHighSalary AS
(
select empname,deptid,salary from employees1 where salary>55000
)
select empname from EmpHighSalary;

-- 2. Department-wise Average Salary
-- Create a CTE that calculates average salary per department.
-- Then join it with Employees to display: EmpName, Salary, DeptID, AvgSalary.

with deptAvgSalary AS 
(
select deptid,avg(salary) as AvgSalary from employees1 group by deptid
)
select e.empname,e.salary,e.deptid, d.avgsalary 
from employees1 e
JOIN deptAvgSalary d  ON e.deptid=d.deptid;

-- 3.Top 3 Salaries
-- Use a CTE + ROW_NUMBER() to find the top 3 highest paid employees.
with topThreeSalaries AS
(
select  empname,salary,
		row_number() Over(order by salary desc) As sequence from employees1
)
select empname,salary from topThreeSalaries where sequence in (1,2,3);

-- 4. Create a CTE that selects only DeptID = 101 employees.
-- Then in final query, count how many employees are there in that department.

with department AS
(
select empname,deptid,salary from employees1 where deptid=101
)
select count(*)as totalEmployees from department;

-- 5. Generate Numbers (1 to 10)
-- Write a recursive CTE that prints numbers from 1 to 10

with recursive numbers AS
(
-- anchor part
 select 1 as n
 union all
 select n+1 from numbers where n<10 -- since it prints first then check condition like do while i gave condition <10
)
select * from numbers;

-- 6. From the Employees table (assume ManagerID column exists),
-- write a recursive CTE to print hierarchy starting from Asha (CEO).
ALTER TABLE Employees1
ADD ManagerID INT NULL;

UPDATE Employees1 SET ManagerID = NULL WHERE EmpID = 1;  -- Asha (CEO)
UPDATE Employees1 SET ManagerID = 1 WHERE EmpID = 2;     -- Raj reports to Asha
UPDATE Employees1 SET ManagerID = 1 WHERE EmpID = 3;     -- Meena reports to Asha
UPDATE Employees1 SET ManagerID = 2 WHERE EmpID = 4;     -- Arjun reports to Raj
UPDATE Employees1 SET ManagerID = 3 WHERE EmpID = 5;     -- Neha reports to Meena
UPDATE Employees1 SET ManagerID = 3 WHERE EmpID = 6;
UPDATE Employees1 SET ManagerID = 2 WHERE EmpID = 7;

with recursive levelOfEmp as
(
select empid,empname,managerid, 1 as Level  from employees1 where managerid is  null
union all
select e.empid,e.empname, e.managerid,l.level+1
from employees1 e
join levelOfEmp l ON e.managerid=l.empid
)
select empname, level from levelOfEmp;

-- Factorial Calculation
-- Write a recursive CTE to calculate factorial of numbers 1 to 5.

with recursive factorial as
(
 select 1 as n, 1 as fact
 union all
 select n+1, fact * (n+1) from factorial where n <5
)
select * from factorial;

-- Suppose you want all dates between '2025-01-01' and '2025-01-07'.
-- Use a recursive CTE to generate those dates.

with recursive cte_date as
(
select DATE('2025-01-01') as n
union all 
select DATE_ADD(n, interval 1 day) from cte_date where n<'2025-01-07'
)
select * from cte_date;