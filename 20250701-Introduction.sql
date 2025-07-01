
-- Login to mariadb
-- describe the command to login to mariadb
mariadb -uroot -p
show databases;
use <database name>;
show tables;
desc <table name>;

CREATE DATABASE SAMPLEDB;
USE SAMPLEDB;

CREATE TABLE if not exists students (
  last_name varchar(100),
  first_name varchar(100),
  id_number int(10),
  age int(3),
  address varchar(100),
  description text,
  dob date
);

