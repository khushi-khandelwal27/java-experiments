-- Run this in MySQL before using the application
CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;

CREATE TABLE IF NOT EXISTS students (
    roll_no  VARCHAR(20)  PRIMARY KEY,
    name     VARCHAR(100) NOT NULL,
    age      INT          NOT NULL,
    gender   VARCHAR(10)  NOT NULL,
    email    VARCHAR(100) NOT NULL,
    mobile   VARCHAR(10)  NOT NULL,
    course   VARCHAR(50)  NOT NULL,
    address  TEXT
);
