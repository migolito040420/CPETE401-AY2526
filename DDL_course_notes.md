# Course Notes: Data Definition Language (DDL) in MariaDB

This document provides detailed notes on the Data Definition Language (DDL) commands in MariaDB. DDL is a subset of SQL used to define and manage the structure of your database and its objects, such as tables, indexes, and views.

## 1. Introduction to DDL

DDL statements are used to create, modify, and delete database objects. These statements are auto-committed, meaning they are permanent and cannot be rolled back.

The primary DDL commands are:

- `CREATE`: Used to create new database objects.
- `ALTER`: Used to modify the structure of existing database objects.
- `DROP`: Used to delete existing database objects.
- `TRUNCATE`: Used to delete all records from a table.

---

## 2. `CREATE` Statement

The `CREATE` statement is used to build new database objects.

### Creating a Database

To create a new database, you use the `CREATE DATABASE` command.

**Syntax:**

```sql
CREATE DATABASE [IF NOT EXISTS] database_name;
```

**Example:**

```sql
CREATE DATABASE my_university;
```

### Creating a Table

To create a new table within a database, you use the `CREATE TABLE` command. You must first select the database you want to create the table in with the `USE` command.

**Syntax:**

```sql
CREATE TABLE table_name (
    column1_name data_type [constraints],
    column2_name data_type [constraints],
    ...
);
```

**Example:**

```sql
USE my_university;

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE
);
```

### Creating an Index

Indexes are used to retrieve data from the database more quickly. You can create an index on one or more columns of a table.

**Syntax:**

```sql
CREATE INDEX index_name ON table_name (column1, column2, ...);
```

**Example:**

```sql
CREATE INDEX idx_last_name ON students (last_name);
```

---

## 3. `ALTER` Statement

The `ALTER` statement is used to modify the structure of an existing table.

### Adding a Column

To add a new column to a table, you use `ALTER TABLE ... ADD COLUMN`.

**Syntax:**

```sql
ALTER TABLE table_name ADD COLUMN column_name data_type [constraints];
```

**Example:**

```sql
ALTER TABLE students ADD COLUMN email VARCHAR(100) UNIQUE;
```

### Modifying a Column

To change the data type or constraints of an existing column, you use `ALTER TABLE ... MODIFY COLUMN`.

**Syntax:**

```sql
ALTER TABLE table_name MODIFY COLUMN column_name new_data_type [new_constraints];
```

**Example:**

```sql
ALTER TABLE students MODIFY COLUMN email VARCHAR(150);
```

### Renaming a Column

To rename a column, you use `ALTER TABLE ... RENAME COLUMN`.

**Syntax:**

```sql
ALTER TABLE table_name RENAME COLUMN old_name TO new_name;
```

**Example:**

```sql
ALTER TABLE students RENAME COLUMN date_of_birth TO dob;
```

### Dropping a Column

To remove a column from a table, you use `ALTER TABLE ... DROP COLUMN`.

**Syntax:**

```sql
ALTER TABLE table_name DROP COLUMN column_name;
```

**Example:**

```sql
ALTER TABLE students DROP COLUMN dob;
```

---

## 4. `DROP` Statement

The `DROP` statement is used to delete entire database objects.

### Dropping a Database

This command will permanently delete the entire database, including all its tables and data.

**Syntax:**

```sql
DROP DATABASE [IF EXISTS] database_name;
```

**Example:**

```sql
DROP DATABASE my_university;
```

### Dropping a Table

This command will permanently delete a table and all of its data.

**Syntax:**

```sql
DROP TABLE [IF EXISTS] table_name;
```

**Example:**

```sql
DROP TABLE students;
```

### Dropping an Index

To delete an index from a table, you use the `DROP INDEX` command.

**Syntax:**

```sql
DROP INDEX index_name ON table_name;
```

**Example:**

```sql
DROP INDEX idx_last_name ON students;
```

---

## 5. `TRUNCATE` Statement

The `TRUNCATE TABLE` command is used to delete all data from a table quickly. Unlike `DELETE`, `TRUNCATE` is a DDL command and cannot be rolled back. It also resets any auto-incrementing counters.

**Syntax:**

```sql
TRUNCATE TABLE table_name;
```

**Example:**

```sql
TRUNCATE TABLE students;
```

---

## 6. MariaDB Data Types

Choosing the correct data type for your columns is crucial for database performance, data integrity, and efficient storage. Here are some of the most common data types in MariaDB, with scenarios and examples.

### Numeric Data Types

These are used for storing numerical data.

| Data Type           | Description                                                                                                                                                            |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `INT` or `INTEGER`  | A standard integer. Can be signed (positive or negative) or unsigned (positive only).                                                                                  |
| `DECIMAL(p, s)`     | A fixed-point number, ideal for calculations where precision is essential. `p` is the total number of digits, and `s` is the number of digits after the decimal point. |
| `FLOAT(p, s)`       | A single-precision floating-point number. Used for approximate values.                                                                                                 |
| `DOUBLE(p, s)`      | A double-precision floating-point number. Offers greater precision than `FLOAT`.                                                                                       |
| `BOOLEAN` or `BOOL` | Stores a value of `TRUE` or `FALSE`. In MariaDB, this is a synonym for `TINYINT(1)`.                                                                                   |

**Scenario and Examples:**

- **`INT` for User IDs:** Use an integer for unique identifiers that increment.

  ```sql
  CREATE TABLE users (
      user_id INT PRIMARY KEY AUTO_INCREMENT,
      username VARCHAR(50)
  );
  ```

- **`DECIMAL` for Financial Data:** Use `DECIMAL` to avoid rounding errors with currency.

  ```sql
  CREATE TABLE products (
      product_id INT PRIMARY KEY,
      name VARCHAR(100),
      price DECIMAL(10, 2) NOT NULL -- e.g., 99999999.99
  );
  ```

- **`BOOLEAN` for Status Flags:** Use a boolean for true/false states.
  ```sql
  CREATE TABLE articles (
      article_id INT PRIMARY KEY,
      title VARCHAR(255),
      is_published BOOLEAN DEFAULT FALSE
  );
  ```

### String Data Types

These are used for storing text.

| Data Type    | Description                                                                                       |
| ------------ | ------------------------------------------------------------------------------------------------- |
| `VARCHAR(n)` | A variable-length string with a maximum size of `n` characters. Storage is optimized.             |
| `CHAR(n)`    | A fixed-length string that is always `n` characters long. Shorter strings are padded with spaces. |
| `TEXT`       | For long-form text strings, such as article bodies or detailed descriptions.                      |
| `ENUM`       | An enumeration, which allows a column to have one of a predefined set of string values.           |

**Scenario and Examples:**

- **`VARCHAR` for Variable Text:** Ideal for names, emails, and titles where the length varies.

  ```sql
  CREATE TABLE employees (
      employee_id INT,
      first_name VARCHAR(50),
      email VARCHAR(100)
  );
  ```

- **`CHAR` for Fixed-Length Codes:** Use for data that is always the same length, like country codes or status flags.

  ```sql
  CREATE TABLE countries (
      country_code CHAR(2) PRIMARY KEY, -- e.g., 'US', 'CA', 'MX'
      country_name VARCHAR(100)
  );
  ```

- **`TEXT` for Long Content:** Perfect for storing blog posts or product descriptions.

  ```sql
  CREATE TABLE blog_posts (
      post_id INT PRIMARY KEY,
      post_title VARCHAR(255),
      post_content TEXT
  );
  ```

- **`ENUM` for Restricted Choices:** Use when a column should only contain specific values.
  ```sql
  CREATE TABLE orders (
      order_id INT PRIMARY KEY,
      order_status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL
  );
  ```

### Date and Time Data Types

These are used for storing temporal data.

| Data Type   | Description                                                                                                                       |
| ----------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `DATE`      | Stores a date in 'YYYY-MM-DD' format.                                                                                             |
| `TIME`      | Stores a time in 'HH:MM:SS' format.                                                                                               |
| `DATETIME`  | Stores a combination of date and time in 'YYYY-MM-DD HH:MM:SS' format.                                                            |
| `TIMESTAMP` | Similar to `DATETIME`, but it is timezone-aware and has a smaller range. Often used to track the last modification time of a row. |

**Scenario and Examples:**

- **`DATE` for Birthdays:** When you only need to store the date.

  ```sql
  CREATE TABLE students (
      student_id INT,
      full_name VARCHAR(100),
      birth_date DATE
  );
  ```

- **`DATETIME` for Events:** When you need to store both the date and time of an event.

  ```sql
  CREATE TABLE events (
      event_id INT,
      event_name VARCHAR(200),
      start_time DATETIME
  );
  ```

- **`TIMESTAMP` for Record Modifications:** Automatically track when a record was last updated.
  ```sql
  CREATE TABLE accounts (
      account_id INT,
      account_details VARCHAR(255),
      last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );
  ```
