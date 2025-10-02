-- Create Departments table
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

-- Insert data into Departments
INSERT INTO Departments (DeptID, DeptName) VALUES
(101, 'HR'),
(102, 'Finance'),
(103, 'IT');

-- Create Employees table
CREATE TABLE Employees1 (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT,
    Salary INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

-- Insert data into Employees
INSERT INTO Employees1 (EmpID, EmpName, DeptID, Salary) VALUES
(1, 'Asha', 101, 50000),
(2, 'Rohan', 102, 60000),
(3, 'Meena', 101, 55000),
(4, 'Karan', 103, 45000),
(5, 'Sita', 102, 70000),
(6, 'Arjun', 101, 40000),
(7, 'Pooja', 103, 65000);


select * from Departments;
select * from employees1;

-- Practising Subquery problems

-- 1. find the employee(s) with the highest salary

select empname,salary from employees1 where salary = (select max(salary) from employees1);

-- 2. Find employees who earn more than the average salary of all employees.
select empname, salary from employees1 where salary>(select avg(salary) from employees1);

-- 3. Show the name of the department where employee "Rohan" works.
select deptname from departments where deptid=(select deptid from employees1 where empname='Rohan');

-- 4. List all employees who work in Finance or IT department.

select empname from employees1 where deptid in (select deptid from departments where deptname ='IT' or deptname= 'Finance');

-- 5. Find employees whose salary is greater than the average salary of their own department.

select empname,deptid,salary from employees1 e1 where salary > (select avg(salary) from employees1 e2 where e2.deptid=e1.deptid);

-- List employees who earn the minimum salary in their department.

select empname,salary from employees1 e1 where salary = (select min(salary) from employees1 e2 where e2.deptid=e1.deptid);

-- For each department, show the employee with the highest salary.
select empname,salary from employees1 e1 where salary = (select max(salary) from employees1 e2 where e2.deptid=e1.deptid);