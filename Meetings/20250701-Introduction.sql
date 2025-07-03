
-- Connect to MariaDB as the root user and prompt for a password
mariadb -uroot -p

-- Show all available databases
show databases;

-- Select the database you want to use (replace <database name> with the actual name)
use <database name>;

-- Show all tables in the selected database
show tables;

-- Describe the structure of a specific table (replace <table name> with the actual name)
desc <table name>;

-- Create a new database named SAMPLEDB
CREATE DATABASE SAMPLEDB;

-- Switch to the SAMPLEDB database
USE SAMPLEDB;

-- Create a table named 'students' if it does not already exist, with the following columns:
CREATE TABLE if not exists students (
  last_name varchar(100),    -- Student's last name, up to 100 characters
  first_name varchar(100),   -- Student's first name, up to 100 characters
  id_number int(10),         -- Student's ID number, integer (up to 10 digits)
  age int(3),                -- Student's age, integer (up to 3 digits)
  address varchar(100),      -- Student's address, up to 100 characters
  description text,          -- Additional description, text type
  dob date                   -- Date of birth, date type
);

