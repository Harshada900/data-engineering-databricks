-- Drop existing tables if they exist
use testdb;
DROP TABLE IF EXISTS Assignments;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees1;
DROP TABLE IF EXISTS Departments;

-- ========================
-- 1️ Create Departments
-- ========================
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO Departments (dept_id, dept_name, location) VALUES
(101, 'HR', 'Mumbai'),
(102, 'IT', 'Pune'),
(103, 'Finance', 'Delhi'),
(104, 'Marketing', 'Bangalore');

-- ========================
-- 2️ Create Employees
-- ========================
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    gender CHAR(1),
    dept_id INT,
    salary INT,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

INSERT INTO Employees (emp_id, name, gender, dept_id, salary, hire_date) VALUES
(1, 'Aisha Khan', 'F', 101, 55000, '2019-03-15'),
(2, 'Rohan Mehta', 'M', 102, 72000, '2018-07-23'),
(3, 'Neha Patil', 'F', 101, 60000, '2021-01-10'),
(4, 'Amit Sharma', 'M', 103, 80000, '2020-11-01'),
(5, 'Priya Das', 'F', 102, 75000, '2022-02-18'),
(6, 'Rahul Nair', 'M', 104, 50000, '2021-05-05');

-- ========================
-- 3️ Create Projects
-- ========================
CREATE TABLE Projects (
    proj_id VARCHAR(10) PRIMARY KEY,
    proj_name VARCHAR(100),
    dept_id INT,
    budget INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

INSERT INTO Projects (proj_id, proj_name, dept_id, budget) VALUES
('P1', 'Payroll System', 103, 800000),
('P2', 'HR Portal', 101, 400000),
('P3', 'E-commerce App', 102, 900000),
('P4', 'Ad Campaign', 104, 300000);

-- ========================
-- 4️ Create Assignments
-- ========================
CREATE TABLE Assignments (
    emp_id INT,
    proj_id VARCHAR(10),
    hours_worked INT,
    PRIMARY KEY (emp_id, proj_id),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id),
    FOREIGN KEY (proj_id) REFERENCES Projects(proj_id)
);

INSERT INTO Assignments (emp_id, proj_id, hours_worked) VALUES
(1, 'P2', 50),
(2, 'P3', 60),
(3, 'P2', 30),
(4, 'P1', 70),
(5, 'P3', 40),
(6, 'P4', 35);


SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Projects;
SELECT * FROM Assignments;




-- Level 1: Basic SELECT
-- Display all employees’ names and their salaries.
select name, salary from employees;

-- Show the names of employees who work in the IT department.
select name from employees where dept_id=102;

-- List all projects handled by the HR department.
select proj_name from projects where dept_id=101;

-- Find all female employees.
select name from employees where gender='F';

-- Show employees hired after 2020.
select name from employees where year(hire_date)>2020;

-- Level 2: Filtering & Sorting
-- Display employees with a salary greater than 60,000.
select name,salary from employees where salary >60000;

-- Show all employees sorted by salary (highest first).
select name,salary from employees order by salary desc;

-- List employees whose name starts with “A”.
select name from employees where substring(name,1,1)='A';

-- Show departments located in Pune or Delhi.
select dept_name from departments where location in ('Pune','Delhi');

-- Display employees not working in the Finance department.
select name from employees where dept_id!=103;

-- Level 3: Aggregations
-- Find the total salary of all employees.
select sum(salary) from employees;

-- Show the average salary of employees in each department.
select dept_id, avg(salary) from employees group by dept_id;

-- Count how many employees each department has.
select dept_id, count(emp_id) from employees group by dept_id;

-- Find the maximum and minimum salary in the company.
select max(salary),min(salary) from employees;

-- Display departments with more than one employee.
select dept_id, count(emp_id) as cnt from employees group by dept_id having cnt>1;

-- Level 4: Joins
-- Display employee name, department name, and location.
 select e.name, d.dept_name,  d.location 
 from employees e
 join departments d
 ON e.dept_id=d.dept_id;
 
 -- List each project name with the department name.
 select p.proj_name, d.dept_name 
from projects p
join departments d
on p.dept_id=d.dept_id;

-- Show which employee is working on which project (join 3 tables).
select e.name, p.proj_name, d.dept_id
from employees e
join projects p on e.dept_id=p.dept_id
join departments d on p.dept_id=d.dept_id;

-- Display all employees along with their assigned project hours.
select e.name, a.hours_worked
from employees e
join Assignments a on e.emp_id=a.emp_id;

-- Show employees who are not assigned to any project (use LEFT JOIN).
SELECT e.name
FROM Employees e
LEFT JOIN Assignments a ON e.emp_id = a.emp_id
WHERE a.proj_id IS NULL;

SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Projects;
SELECT * FROM Assignments;

-- Level 5: Subqueries
-- Find the employees who earn more than the average salary.
select name,salary from employees where salary>(select avg(salary) from employees);

-- Show departments whose average salary is more than ₹60,000.
select dept_id,avg(salary) from employees group by dept_id having avg(salary)>60000;

-- Display employees who work in the same department as “Neha Patil”.
select name from employees where dept_id = (select dept_id from employees where name='Neha Patil');

-- Find the highest-paid employee in each department.
select e.name,e.dept_id,e.salary 
from employees e
join (
select dept_id,max(salary) as max_salary from employees group by dept_id
) as m
on e.dept_id=m.dept_id and e.salary=m.max_salary;

-- Find employees who work on projects with a budget over ₹500,000.
select e.name from employees e
join 
(select dept_id from projects where budget>500000) as d
on e.dept_id=d.dept_id;

-- Bonus (Analytical Thinking)
-- Which project has the maximum total hours worked by employees?
SELECT p.proj_name
FROM projects p
JOIN (
    SELECT proj_id, SUM(hours_worked) AS total_hours
    FROM assignments
    GROUP BY proj_id
    ORDER BY total_hours DESC
    LIMIT 1
) AS a
ON p.proj_id = a.proj_id;

-- Find the department where total salary cost is the highest.
select d.dept_name from departments d
join (
select dept_id,sum(salary) as total_salary_cost 
from employees group by dept_id 
order by total_salary_cost desc
limit 1
)as e
on d.dept_id=e.dept_id;


SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Projects;
SELECT * FROM Assignments;

-- List all employees who don’t have any project yet (hint: NOT IN or LEFT JOIN).
select e.name from employees e where e.emp_id not in (select emp_id from assignments );

-- Find which gender has a higher average salary overall.
select gender, avg(salary) as max_salary from employees group by gender order by max_salary desc limit 1;

-- Rank employees based on salary (hint: use RANK() or DENSE_RANK()).
select name,
rank() over(order by salary desc) from employees;