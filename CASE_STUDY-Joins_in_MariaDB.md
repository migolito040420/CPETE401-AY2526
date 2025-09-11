
# Case Study: University Course Enrollment Analysis

This case study demonstrates the practical use of `INNER JOIN`, `LEFT JOIN`, and `RIGHT JOIN` in MariaDB to analyze relationships between students, courses, and their enrollments.

---

## 1. Database Schema (DDL)

Here is the SQL code to create the necessary tables: `Students`, `Courses`, and the linking table `Enrollments`.

```sql
-- Drop tables if they exist to start fresh
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;

-- Create the Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- Create the Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    course_credits INT NOT NULL
);

-- Create the Enrollments table to link Students and Courses
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
```

---

## 2. Sample Data (DML)

Here is the SQL code to populate the tables with sample data. Notice that one student (`Alice Johnson`) is not enrolled in any course, and one course (`Advanced Quantum Mechanics`) has no students enrolled.

```sql
-- Insert data into Students table
INSERT INTO Students (first_name, last_name, email) VALUES
('John', 'Doe', 'john.doe@university.com'),
('Jane', 'Smith', 'jane.smith@university.com'),
('Peter', 'Jones', 'peter.jones@university.com'),
('Mary', 'Williams', 'mary.williams@university.com'),
('Alice', 'Johnson', 'alice.j@university.com'); -- This student has no enrollments

-- Insert data into Courses table
INSERT INTO Courses (course_name, course_credits) VALUES
('Introduction to Databases', 3),
('Web Development Basics', 4),
('Calculus I', 4),
('Advanced Quantum Mechanics', 3); -- This course has no students

-- Insert data into Enrollments table
INSERT INTO Enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2025-09-01'), -- John Doe in Intro to Databases
(1, 2, '2025-09-01'), -- John Doe in Web Development
(2, 3, '2025-09-02'), -- Jane Smith in Calculus I
(3, 1, '2025-09-03'), -- Peter Jones in Intro to Databases
(4, 1, '2025-09-04'), -- Mary Williams in Intro to Databases
(4, 3, '2025-09-04'); -- Mary Williams in Calculus I
```

---

## 3. Problem Set

Use the schema and data above to answer the following questions.

1.  **Problem:** List the first names of all students and the names of the courses they are enrolled in.
2.  **Problem:** Show the enrollment date for every student enrolled in 'Introduction to Databases'.
3.  **Problem:** List all students, including those who have not enrolled in any courses. For students who are enrolled, show the course name.
4.  **Problem:** Find the names of all students who are **not** currently enrolled in any course.
5.  **Problem:** List all available courses and the names of the students enrolled in them. Include courses that have no students.
6.  **Problem:** Find the names of all courses that currently have **no** students enrolled.
7.  **Problem:** Count how many students are enrolled in each course. Only include courses that have at least one student.
8.  **Problem:** Modify the previous query to list all courses, including those with zero enrolled students.
9.  **Problem:** List the full name (concatenated) of each student and the name of the course they are enrolled in, ordered by the course name.
10. **Problem:** Find out which courses `John Doe` is enrolled in.

---

## 4. Answers

### Answer 1: Students and their Enrolled Courses (`INNER JOIN`)

```sql
SELECT 
    s.first_name, 
    c.course_name
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id;
```

### Answer 2: Enrollment Dates for a Specific Course (`INNER JOIN` with `WHERE`)

```sql
SELECT 
    s.first_name, 
    s.last_name, 
    e.enrollment_date
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Introduction to Databases';
```

### Answer 3: All Students and Their Enrollments (`LEFT JOIN`)

```sql
SELECT 
    s.first_name, 
    s.last_name, 
    c.course_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
LEFT JOIN Courses c ON e.course_id = c.course_id;
```

### Answer 4: Students with No Enrollments (`LEFT JOIN` with `IS NULL`)

```sql
SELECT 
    s.first_name, 
    s.last_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;
```

### Answer 5: All Courses and Their Enrolled Students (`RIGHT JOIN`)

```sql
SELECT 
    c.course_name, 
    s.first_name, 
    s.last_name
FROM Students s
RIGHT JOIN Enrollments e ON s.student_id = e.student_id
RIGHT JOIN Courses c ON e.course_id = c.course_id;
```

### Answer 6: Courses with No Students (`RIGHT JOIN` with `IS NULL`)

```sql
SELECT 
    c.course_name
FROM Enrollments e
RIGHT JOIN Courses c ON e.course_id = c.course_id
WHERE e.enrollment_id IS NULL;
```

### Answer 7: Count of Students in Each Course (`INNER JOIN` with `GROUP BY`)

```sql
SELECT 
    c.course_name, 
    COUNT(s.student_id) AS number_of_students
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;
```

### Answer 8: Count of Students for All Courses (`LEFT JOIN` with `GROUP BY`)

*Note: We use a LEFT JOIN from Courses to ensure all courses are included.*
```sql
SELECT 
    c.course_name, 
    COUNT(e.student_id) AS number_of_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name;
```

### Answer 9: Full Student Name and Course, Ordered (`INNER JOIN` with `CONCAT` and `ORDER BY`)

```sql
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS full_name,
    c.course_name
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
ORDER BY c.course_name, full_name;
```

### Answer 10: Courses for a Specific Student (`INNER JOIN` with `WHERE`)

```sql
SELECT 
    c.course_name, 
    c.course_credits
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE s.first_name = 'John' AND s.last_name = 'Doe';
```
