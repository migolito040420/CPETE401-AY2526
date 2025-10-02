# Course Notes: Stored Procedures in MariaDB

## 1. Introduction to Stored Procedures

A stored procedure is a set of SQL statements that are stored in the database. Instead of sending individual SQL statements from the application to the database, the application can call the stored procedure by its name. This has several advantages, which we will discuss below.

## 2. Advantages of Using Stored Procedures

*   **Performance:** Stored procedures are pre-compiled and stored in the database. This means that the database does not have to compile the SQL statements every time they are executed, which can lead to a significant performance improvement.
*   **Reduced Network Traffic:** Instead of sending multiple long SQL statements over the network, the application only needs to send the name of the stored procedure and its parameters. This can reduce network traffic and improve the overall performance of the application.
*   **Reusability:** Stored procedures can be called by multiple applications, which promotes code reuse and reduces development time.
*   **Security:** Stored procedures can be used to restrict access to the underlying database tables. Instead of giving users direct access to the tables, you can grant them permission to execute a stored procedure that performs a specific task. This helps to ensure data integrity and prevent unauthorized access.
*   **Maintainability:** Stored procedures are stored in a central location (the database), which makes them easier to maintain. If you need to change the logic of a query, you only need to update the stored procedure, and all applications that use it will automatically get the updated logic.

## 3. Syntax

### Creating a Stored Procedure

```sql
CREATE PROCEDURE procedure_name ([parameter1, parameter2, ...])
BEGIN
    -- SQL statements
END;
```

*   `procedure_name`: The name of the stored procedure.
*   `parameter1, parameter2, ...`: An optional list of parameters.

### Calling a Stored Procedure

```sql
CALL procedure_name ([parameter1, parameter2, ...]);
```

### Dropping a Stored Procedure

```sql
DROP PROCEDURE [IF EXISTS] procedure_name;
```

## 4. Parameters

Stored procedures can have three types of parameters:

*   **`IN`**: The default parameter type. The value of an `IN` parameter is passed from the application to the stored procedure. The stored procedure can use the value of the parameter, but it cannot change it.
*   **`OUT`**: The value of an `OUT` parameter is passed from the stored procedure to the application. The stored procedure can change the value of the parameter.
*   **`INOUT`**: An `INOUT` parameter is a combination of an `IN` and an `OUT` parameter. The value of the parameter is passed from the application to the stored procedure, and the stored procedure can change the value of the parameter.

**Example:**

```sql
CREATE PROCEDURE get_product_count_by_category(IN category_name VARCHAR(255), OUT product_count INT)
BEGIN
    SELECT COUNT(*) INTO product_count
    FROM products
    WHERE category = category_name;
END;
```

To call this stored procedure, you would use the following syntax:

```sql
CALL get_product_count_by_category('Electronics', @product_count);
SELECT @product_count;
```

## 5. Variables

You can declare and use variables within a stored procedure. Variables are used to store intermediate results.

**Example:**

```sql
CREATE PROCEDURE calculate_total_price(IN quantity INT, IN unit_price DECIMAL(10, 2))
BEGIN
    DECLARE total_price DECIMAL(10, 2);
    SET total_price = quantity * unit_price;
    SELECT total_price;
END;
```

## 6. Control Flow Statements

Stored procedures support control flow statements such as `IF`, `CASE`, `LOOP`, and `WHILE`.

### `IF` Statement

```sql
IF condition THEN
    -- statements
ELSEIF condition THEN
    -- statements
ELSE
    -- statements
END IF;
```

### `CASE` Statement

```sql
CASE expression
    WHEN value1 THEN
        -- statements
    WHEN value2 THEN
        -- statements
    ELSE
        -- statements
END CASE;
```

### `LOOP` Statement

```sql
label: LOOP
    -- statements
    IF condition THEN
        LEAVE label;
    END IF;
END LOOP;
```

### `WHILE` Statement

```sql
WHILE condition DO
    -- statements
END WHILE;
```