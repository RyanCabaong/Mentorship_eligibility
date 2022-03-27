-- step1 get the employees checlk
-- step 2 get title stuff
--step 3 create table (into)
--step 4 join 

-- Creating tables for PH-EmployeeDB
--Create table employees
CREATE TABLE employees (
	emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
	--Indexes the emp_no variable
     PRIMARY KEY (emp_no)
);
--Create table titles
CREATE TABLE titles(
 	emp_no int NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL
);
--tests
SELECT * FROM employees;
SELECT * FROM retirement_titles;
SELECT * FROM retirement_titles2;
SELECT * FROM titles;
SELECT * FROM unique_titles;

SELECT emp_no, first_name, last_name, birth_date
INTO retirement_titles
FROM employees

-- Joining retirement_titles and titles
--create unique titles table
SELECT retirement_titles.emp_no,
    retirement_titles.first_name,
    retirement_titles.last_name,
	titles.title,
	titles.from_date,
	titles.to_date
	into unique_titles
FROM retirement_titles
LEFT JOIN titles
ON retirement_titles.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
and titles.to_date = ('9999-01-01')
ORDER BY emp_no asc, from_date desc;

--create updated retirement_titles table
SELECT retirement_titles.emp_no,
    retirement_titles.first_name,
    retirement_titles.last_name,
	titles.title,
	titles.from_date,
	titles.to_date
into retirement_titles2
FROM retirement_titles
LEFT JOIN titles
ON retirement_titles.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no asc

--retiring_titles
select count(emp_no),
	retirement_titles2.title
into retiring_titles
from retirement_titles2
where to_date = ('9999-01-01')
group by retirement_titles2.title
order by count(emp_no) desc

select count(emp_no)
from employees

select count(title)
from unique_titles
group by title
--delierable 1 finished
--deliverable 2
--get employee and dept_emp stuff
CREATE TABLE dept_emp(
	emp_no int NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL
);
SELECT * FROM dept_emp;

--join emp_dept to emp
SELECT distinct employees.emp_no,
    employees.first_name,
    employees.last_name,
	employees.birth_date,
	dept_emp.from_date,
	dept_emp.to_date
	into emp_with_dept
FROM employees
LEFT JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no

--join titles to employees
SELECT distinct employees.emp_no,
    employees.first_name,
    employees.last_name,
	employees.birth_date,
	titles.title
	into emp_with_title
FROM employees
LEFT JOIN titles
ON employees.emp_no = titles.emp_no

--join to make mentorship_eligibilty
select
distinct on (emp_no)
	emp_with_dept.emp_no,
	emp_with_dept.first_name,
	emp_with_dept.last_name,
	emp_with_dept.birth_date,
	emp_with_dept.from_date,
	emp_with_dept.to_date,
	emp_with_title.title
	into mentorship_eligibilty
FROM emp_with_dept
LEFT JOIN emp_with_title
ON emp_with_dept.emp_no = emp_with_title.emp_no
where (emp_with_dept.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
and to_date = ('9999-01-01')
order by emp_no asc