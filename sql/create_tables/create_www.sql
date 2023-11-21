-- CREATE TABLES www
USE `dblp`;

-- drop www table if exists
DROP TABLE IF EXISTS www; 

-- create www table
CREATE TABLE www (
    _key VARCHAR(255) NOT NULL,
    mdate DATE NOT NULL,
    title VARCHAR(255)
);