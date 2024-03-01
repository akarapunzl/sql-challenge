CREATE TABLE titles(
title_id VARCHAR(30) PRIMARY KEY,
title_names VARCHAR(30)) NOT NULL;

CREATE TABLE employees(
emp_no INT PRIMARY KEY,
emp_title_id VARCHAR(30) NOT NULL,
birth_date DATE NOT NULL,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
sex VARCHAR(1) NOT NULL,
hire_date DATE NOT NULL,
FOREIGN KEY (emp_title_id) REFERENCES titles(title_id));

CREATE TABLE salaries(
emp_no INT NOT NULL,
salary INT NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees(emp_no));

CREATE TABLE departments(
dept_no VARCHAR(30) PRIMARY KEY,
dept_name VARCHAR(30) NOT NULL);

CREATE TABLE dept_manager(
dept_no VARCHAR(30) NOT NULL,
emp_no INT NOT NULL,
FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
FOREIGN KEY (emp_no) REFERENCES employees(emp_no));

CREATE TABLE dept_emp(
emp_no INT NOT NULL,
dept_no VARCHAR(30) NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
FOREIGN KEY (dept_no) REFERENCES departments(dept_no));

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salary.salary
FROM employees
JOIN salaries as salary
ON employees.emp_no = salary.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

--List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT dept_manager.emp_no, dept_manager.dept_no, departments.dept_name, employees.last_name, employees.first_name
FROM dept_manager
JOIN departments as departments
ON dept_manager.dept_no = departments.dept_no
JOIN employees as employees
ON dept_manager.emp_no = employees.emp_no;

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT dept_emp.dept_no, dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
JOIN departments as departments
ON dept_emp.dept_no = departments.dept_no
JOIN employees as employees
ON dept_emp.emp_no = employees.emp_no;

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' and last_name like 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT emp_no, last_name, first_name
FROM employees
WHERE emp_no in
(
	SELECT emp_no
	FROM dept_emp
	WHERE dept_no =
	(
		SELECT dept_no
		FROM departments
		WHERE dept_name = ('Sales')));
		
--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, dept.dept_name
FROM employees e
	JOIN dept_emp de 
	ON e.emp_no = de.emp_no
	JOIN departments dept 
	ON de.dept_no = dept.dept_no
WHERE dept.dept_name IN ('Sales', 'Development');

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;

