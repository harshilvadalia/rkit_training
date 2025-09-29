CREATE DATABASE Payroll;
use Payroll;

CREATE TABLE Departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(50)
);

CREATE TABLE Employees (
  emp_id INT PRIMARY KEY,
  name VARCHAR(50),
  dept_id INT,
  salary DECIMAL(10,2),
  FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Salaries (
  emp_id INT,
  month VARCHAR(20),
  amount DECIMAL(10,2),
  FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

INSERT INTO Departments (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'Sales');

INSERT INTO Employees (emp_id, name, dept_id, salary) VALUES
(101, 'Amit Sharma', 1, 40000),
(102, 'Priya Singh', 2, 55000),
(103, 'Rahul Mehta', 3, 60000),
(104, 'Sneha Patel', 4, 45000),
(105, 'Vikram Rao', 5, 50000);

INSERT INTO Salaries (emp_id, month, amount) VALUES
(101, 'Jan', 40000),
(101, 'Feb', 40000),
(102, 'Jan', 55000),
(102, 'Feb', 55000),
(103, 'Jan', 60000),
(103, 'Feb', 60000),
(104, 'Jan', 45000),
(104, 'Feb', 46000),  
(105, 'Jan', 50000),
(105, 'Feb', 50000);


-- join
SELECT e.emp_id, e.name, d.dept_name, s.month, s.amount
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
JOIN Salaries s ON e.emp_id = s.emp_id;

-- subquery
SELECT name, salary
FROM Employees e
WHERE salary > (
  SELECT AVG(salary)
  FROM Employees
  WHERE dept_id = e.dept_id
);

-- Calculate yearly salary of an employee
DELIMITER //
CREATE PROCEDURE GetYearlySalary(IN emp INT)
BEGIN
  SELECT emp_id, name, SUM(amount) AS yearly_salary
  FROM Salaries
  WHERE emp_id = emp
  GROUP BY emp_id, name;
END //
DELIMITER ;

-- triggers
CREATE TABLE SalaryLog (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT,
  month VARCHAR(20),
  amount DECIMAL(10,2),
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER AfterSalaryInsert
AFTER INSERT ON Salaries
FOR EACH ROW
BEGIN
  INSERT INTO SalaryLog(emp_id, month, amount)
  VALUES (NEW.emp_id, NEW.month, NEW.amount);
END //
DELIMITER ;

-- views
DROP VIEW EmployeeSalarySummary;
CREATE VIEW EmployeeSalarySummary AS
SELECT e.emp_id, e.name, d.dept_name, SUM(s.amount) AS total_salary
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
JOIN Salaries s ON e.emp_id = s.emp_id
GROUP BY e.emp_id, e.name, d.dept_name;








