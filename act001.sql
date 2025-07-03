CREATE TABLE author (
author_id VARCHAR(100),
first_name VARCHAR(100),
last_name VARCHAR(100),
short_biography short text(100),
birth_date VARCHAR(100)
);

CREATE TABLE publisher (
pub_id VARCHAR(100),
pub_name VARCHAR(100),
pub_country VARCHAR(100),
);

CREATE TABLE books (
book_id INT,
book_title VARCHAR(100),
book_isbn INT,
book_publication_date DATE,
book_price DECIMAL(4, 4),
);
