# Course Notes: Stored Procedures in MariaDB (Library Case Study)

## 1. Introduction

This document provides a different set of examples for stored procedures using a new case study: a simple library management system.

## 2. Library Database Schema

The database consists of three tables: `books`, `members`, and `loans`.

### `books` table
| Column | Type | Description |
|---|---|---|
| `book_id` | INT | Primary Key |
| `title` | VARCHAR(255) | The title of the book |
| `author` | VARCHAR(255) | The author of the book |
| `available_copies` | INT | Number of available copies |

### `members` table
| Column | Type | Description |
|---|---|---|
| `member_id` | INT | Primary Key |
| `member_name` | VARCHAR(255) | The name of the member |
| `email` | VARCHAR(255) | The email of the member |

### `loans` table
| Column | Type | Description |
|---|---|---|
| `loan_id` | INT | Primary Key |
| `book_id` | INT | Foreign Key to `books` table |
| `member_id` | INT | Foreign Key to `members` table |
| `loan_date` | DATE | The date the book was loaned |
| `return_date` | DATE | The date the book was returned (NULL if not returned) |

## 3. Sample Data

Use the following SQL statements to create and populate the tables:

```sql
-- Create tables
CREATE TABLE `books` (
  `book_id` INT PRIMARY KEY AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `author` VARCHAR(255) NOT NULL,
  `available_copies` INT NOT NULL
);

CREATE TABLE `members` (
  `member_id` INT PRIMARY KEY AUTO_INCREMENT,
  `member_name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL
);

CREATE TABLE `loans` (
  `loan_id` INT PRIMARY KEY AUTO_INCREMENT,
  `book_id` INT NOT NULL,
  `member_id` INT NOT NULL,
  `loan_date` DATE NOT NULL,
  `return_date` DATE,
  FOREIGN KEY (`book_id`) REFERENCES `books`(`book_id`),
  FOREIGN KEY (`member_id`) REFERENCES `members`(`member_id`)
);

-- Insert data
INSERT INTO `books` (`title`, `author`, `available_copies`) VALUES
('The Hobbit', 'J.R.R. Tolkien', 5),
('The Lord of the Rings', 'J.R.R. Tolkien', 3),
('Pride and Prejudice', 'Jane Austen', 7);

INSERT INTO `members` (`member_name`, `email`) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');

INSERT INTO `loans` (`book_id`, `member_id`, `loan_date`) VALUES
(1, 1, '2025-09-01'),
(2, 2, '2025-09-05');
```

## 4. Sample Problems

1.  **`get_all_books`**: Create a stored procedure that returns all books from the `books` table.
2.  **`get_member_by_email`**: Create a stored procedure that takes a member's email as input and returns their details.
3.  **`get_borrowed_books_by_member`**: Create a stored procedure that takes a `member_id` as input and returns a list of all books currently borrowed by that member.
4.  **`add_new_book`**: Create a stored procedure that takes a book's `title`, `author`, and `available_copies` as input and adds it to the `books` table.
5.  **`loan_book`**: Create a stored procedure that takes a `book_id` and a `member_id` as input. It should create a new loan record and decrement the number of available copies of the book.
6.  **`return_book`**: Create a stored procedure that takes a `loan_id` as input. It should set the `return_date` to the current date and increment the number of available copies of the book.

## 5. Answer Key

1.  **`get_all_books`**

    ```sql
    CREATE PROCEDURE get_all_books()
    BEGIN
        SELECT * FROM books;
    END;
    ```

2.  **`get_member_by_email`**

    ```sql
    CREATE PROCEDURE get_member_by_email(IN p_email VARCHAR(255))
    BEGIN
        SELECT * FROM members WHERE email = p_email;
    END;
    ```

3.  **`get_borrowed_books_by_member`**

    ```sql
    CREATE PROCEDURE get_borrowed_books_by_member(IN p_member_id INT)
    BEGIN
        SELECT b.title, b.author, l.loan_date
        FROM loans l
        JOIN books b ON l.book_id = b.book_id
        WHERE l.member_id = p_member_id AND l.return_date IS NULL;
    END;
    ```

4.  **`add_new_book`**

    ```sql
    CREATE PROCEDURE add_new_book(IN p_title VARCHAR(255), IN p_author VARCHAR(255), IN p_available_copies INT)
    BEGIN
        INSERT INTO books (title, author, available_copies)
        VALUES (p_title, p_author, p_available_copies);
    END;
    ```

5.  **`loan_book`**

    ```sql
    CREATE PROCEDURE loan_book(IN p_book_id INT, IN p_member_id INT)
    BEGIN
        -- Create a new loan record
        INSERT INTO loans (book_id, member_id, loan_date)
        VALUES (p_book_id, p_member_id, CURDATE());

        -- Decrement the number of available copies
        UPDATE books SET available_copies = available_copies - 1 WHERE book_id = p_book_id;
    END;
    ```

6.  **`return_book`**

    ```sql
    CREATE PROCEDURE return_book(IN p_loan_id INT)
    BEGIN
        DECLARE v_book_id INT;

        -- Get the book_id from the loan record
        SELECT book_id INTO v_book_id FROM loans WHERE loan_id = p_loan_id;

        -- Set the return_date
        UPDATE loans SET return_date = CURDATE() WHERE loan_id = p_loan_id;

        -- Increment the number of available copies
        UPDATE books SET available_copies = available_copies + 1 WHERE book_id = v_book_id;
    END;
    ```
