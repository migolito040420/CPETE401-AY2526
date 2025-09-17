# Case Study: Project & Task Management Analysis

## Introduction

This case study focuses on a common business scenario: tracking work within a company. We have a database designed to keep records of departments, the employees within them, the projects they work on, and the specific tasks assigned to them, including the hours logged for each task.

This dataset is designed to have specific gaps:
- Not all employees are assigned to a task.
- Not all departments have employees.
- Not all projects have tasks.

These gaps make it a good exercise for understanding the differences between `INNER JOIN`, `LEFT JOIN`, and `RIGHT JOIN`.

## Database Schema

The database consists of four tables:
- `Departments`: Lists all company departments.
- `Employees`: Lists all employees and the department they belong to.
- `Projects`: Lists all company projects.
- `Tasks`: A linking table that assigns employees to specific tasks within a project and logs the hours spent.

### SQL Schema (DDL)

```sql
-- First, drop tables if they exist to ensure a clean slate.
DROP TABLE IF EXISTS Tasks;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- Table for Departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- Table for Employees
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE SET NULL
);

-- Table for Projects
CREATE TABLE Projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    due_date DATE
);

-- Table for Tasks (linking Employees and Projects)
CREATE TABLE Tasks (
    task_id INT PRIMARY KEY AUTO_INCREMENT,
    project_id INT,
    employee_id INT,
    task_name VARCHAR(200),
    hours_logged DECIMAL(5, 2),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id) ON DELETE CASCADE
);
```

### Sample Data (DML)

```sql
-- Insert data into Departments
INSERT INTO Departments (department_name) VALUES
('Engineering'),
('Marketing'),
('Human Resources'),
('Legal'); -- A department with no employees

-- Insert data into Employees
INSERT INTO Employees (first_name, last_name, email, department_id) VALUES
('Alice', 'Smith', 'alice.s@example.com', 1),    -- Engineering
('Bob', 'Johnson', 'bob.j@example.com', 1),      -- Engineering
('Charlie', 'Brown', 'charlie.b@example.com', 2), -- Marketing
('Diana', 'Prince', 'diana.p@example.com', 2),    -- Marketing
('Ethan', 'Hunt', 'ethan.h@example.com', 3);      -- Human Resources

-- Insert data into Projects
INSERT INTO Projects (project_name, start_date, due_date) VALUES
('Project Alpha', '2025-01-15', '2025-06-30'),
('Project Beta', '2025-03-01', '2025-09-15'),
('Project Gamma', '2025-07-01', '2025-12-31'); -- A project with no tasks

-- Insert data into Tasks
INSERT INTO Tasks (project_id, employee_id, task_name, hours_logged) VALUES
(1, 1, 'Develop API endpoints', 80.5),
(1, 2, 'Design database schema', 45.0),
(1, 1, 'Write unit tests for API', 35.5),
(2, 4, 'Create marketing campaign', 120.0),
(2, 2, 'Technical consultation for marketing tools', 25.0);

-- Note: Employee 'Charlie Brown' (ID 3) and 'Ethan Hunt' (ID 5) have no tasks.
-- Note: Department 'Legal' (ID 4) has no employees.
-- Note: Project 'Project Gamma' (ID 3) has no tasks.
```

---

## Problem Set

1.  **Basic Inner Join**: List the first name, last name, and department name of every employee.
2.  **Basic Aggregation**: How many employees are in each department? List the department name and the count of employees.
3.  **Left Join**: List all employees (first and last name) and the name of the project they are working on. Include employees who are not assigned to any project.
4.  **Right Join**: List all departments and the full names of the employees in them. Include departments that have no employees.
5.  **Aggregation with Inner Join**: Calculate the total hours logged for each project. List the project name and the total hours, ordered from most hours to least.
6.  **Three-Table Inner Join**: List the full name of the employee, the project name, and the task name for every task recorded.
7.  **Left Join with `IS NULL`**: Find all employees who have not been assigned to any tasks. List their first and last names.
8.  **Right Join with `IS NULL`**: Find all departments that do not have any employees. List the department name.
9.  **Aggregation with `HAVING`**: List the departments that have more than one employee. Show the department name and the employee count.
10. **Complex Aggregation**: What is the average number of hours logged per task for "Project Alpha"?
11. **Left Join to find Unstaffed Projects**: List all projects and the number of tasks associated with each. Include projects that have no tasks.
12. **Distinct Count**: How many distinct employees have logged hours on "Project Alpha"?
13. **Sum with a Condition**: What are the total hours logged by employees from the "Engineering" department?
14. **Combining Joins and Aggregation**: List each project, the number of distinct employees working on it, and the total hours logged.
15. **Full Scope Analysis**: List every department, the number of employees in it, and the total hours logged by employees from that department across all projects. Include departments with no employees and employees with no logged hours.

---

## Answers

**1. Basic Inner Join**: List the first name, last name, and department name of every employee.
```sql
SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM Employees AS e
INNER JOIN Departments AS d ON e.department_id = d.department_id;
```

**2. Basic Aggregation**: How many employees are in each department? List the department name and the count of employees.
```sql
SELECT
    d.department_name,
    COUNT(e.employee_id) AS number_of_employees
FROM Departments AS d
LEFT JOIN Employees AS e ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY number_of_employees DESC;
```

**3. Left Join**: List all employees (first and last name) and the name of the project they are working on. Include employees who are not assigned to any project.
```sql
SELECT
    e.first_name,
    e.last_name,
    p.project_name
FROM Employees AS e
LEFT JOIN Tasks AS t ON e.employee_id = t.employee_id
LEFT JOIN Projects AS p ON t.project_id = p.project_id;
```

**4. Right Join**: List all departments and the full names of the employees in them. Include departments that have no employees.
```sql
SELECT
    d.department_name,
    e.first_name,
    e.last_name
FROM Employees AS e
RIGHT JOIN Departments AS d ON e.department_id = d.department_id;
```

**5. Aggregation with Inner Join**: Calculate the total hours logged for each project. List the project name and the total hours, ordered from most hours to least.
```sql
SELECT
    p.project_name,
    SUM(t.hours_logged) AS total_hours
FROM Projects AS p
INNER JOIN Tasks AS t ON p.project_id = t.project_id
GROUP BY p.project_name
ORDER BY total_hours DESC;
```

**6. Three-Table Inner Join**: List the full name of the employee, the project name, and the task name for every task recorded.
```sql
SELECT
    e.first_name,
    e.last_name,
    p.project_name,
    t.task_name
FROM Tasks AS t
INNER JOIN Employees AS e ON t.employee_id = e.employee_id
INNER JOIN Projects AS p ON t.project_id = p.project_id;
```

**7. Left Join with `IS NULL`**: Find all employees who have not been assigned to any tasks. List their first and last names.
```sql
SELECT
    e.first_name,
    e.last_name
FROM Employees AS e
LEFT JOIN Tasks AS t ON e.employee_id = t.employee_id
WHERE t.task_id IS NULL;
```

**8. Right Join with `IS NULL`**: Find all departments that do not have any employees. List the department name.
```sql
SELECT d.department_name
FROM Employees AS e
RIGHT JOIN Departments AS d ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;
```

**9. Aggregation with `HAVING`**: List the departments that have more than one employee. Show the department name and the employee count.
```sql
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM Departments AS d
JOIN Employees AS e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 1;
```

**10. Complex Aggregation**: What is the average number of hours logged per task for "Project Alpha"?
```sql
SELECT
    AVG(t.hours_logged) AS average_hours_per_task
FROM Tasks AS t
JOIN Projects AS p ON t.project_id = p.project_id
WHERE p.project_name = 'Project Alpha';
```

**11. Left Join to find Unstaffed Projects**: List all projects and the number of tasks associated with each. Include projects that have no tasks.
```sql
SELECT
    p.project_name,
    COUNT(t.task_id) AS number_of_tasks
FROM Projects AS p
LEFT JOIN Tasks AS t ON p.project_id = t.project_id
GROUP BY p.project_name
ORDER BY number_of_tasks DESC;
```

**12. Distinct Count**: How many distinct employees have logged hours on "Project Alpha"?
```sql
SELECT
    COUNT(DISTINCT t.employee_id) AS distinct_employees
FROM Tasks AS t
JOIN Projects AS p ON t.project_id = p.project_id
WHERE p.project_name = 'Project Alpha';
```

**13. Sum with a Condition**: What are the total hours logged by employees from the "Engineering" department?
```sql
SELECT
    SUM(t.hours_logged) AS total_engineering_hours
FROM Tasks AS t
JOIN Employees AS e ON t.employee_id = e.employee_id
JOIN Departments AS d ON e.department_id = d.department_id
WHERE d.department_name = 'Engineering';
```

**14. Combining Joins and Aggregation**: List each project, the number of distinct employees working on it, and the total hours logged.
```sql
SELECT
    p.project_name,
    COUNT(DISTINCT t.employee_id) AS distinct_employees,
    SUM(t.hours_logged) AS total_hours_logged
FROM Projects AS p
LEFT JOIN Tasks AS t ON p.project_id = t.project_id
GROUP BY p.project_name
ORDER BY p.project_name;
```

**15. Full Scope Analysis**: List every department, the number of employees in it, and the total hours logged by employees from that department across all projects. Include departments with no employees and employees with no logged hours.
```sql
SELECT
    d.department_name,
    COUNT(DISTINCT e.employee_id) AS number_of_employees,
    IFNULL(SUM(t.hours_logged), 0) AS total_hours_logged
FROM Departments AS d
LEFT JOIN Employees AS e ON d.department_id = e.department_id
LEFT JOIN Tasks AS t ON e.employee_id = t.employee_id
GROUP BY d.department_name
ORDER BY d.department_name;
```
