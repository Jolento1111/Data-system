-- CREATE TABLES article
USE `dblp`;

-- drop article table
DROP TABLE IF EXISTS in_; 

-- create article table
CREATE TABLE in_ (
    _key VARCHAR(255) NOT NULL,
    mdate DATE NOT NULL,
    title VARCHAR(255),
    year INT,
    crossref VARCHAR(255),
    booktitle VARCHAR(255),
    ee VARCHAR(255),   
    _url VARCHAR(255),
    _type VARCHAR(255)
);


