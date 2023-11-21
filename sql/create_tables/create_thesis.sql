-- CREATE TABLES article
USE `dblp`;

-- drop article table
DROP TABLE IF EXISTS thesis; 

-- create article table
CREATE TABLE thesis (
    _key VARCHAR(255) NOT NULL,
    mdate DATE NOT NULL,
    title VARCHAR(255),
    school VARCHAR(255),
    year INT,
    ee VARCHAR(255),
    _type VARCHAR(255)
);