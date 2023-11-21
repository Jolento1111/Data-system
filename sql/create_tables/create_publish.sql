-- CREATE TABLES article
USE `dblp`;

-- drop article table
DROP TABLE IF EXISTS publish; 

-- create article table
CREATE TABLE publish (
    _key VARCHAR(255) NOT NULL,
    mdate DATE NOT NULL,
    title VARCHAR(255),
    year INT,
    publisher VARCHAR(255),
    booktitle VARCHAR(255),
    volume VARCHAR(255),
    series VARCHAR(255),
    ee VARCHAR(255),
    _url VARCHAR(255),
    isbn VARCHAR(255),
    _type VARCHAR(255)
);



