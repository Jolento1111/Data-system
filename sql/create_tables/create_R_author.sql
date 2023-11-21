-- CREATE TABLES R_author
USE `dblp`;

-- drop R_author table if exists
DROP TABLE IF EXISTS R_author; 

-- create R_author table
CREATE TABLE R_author (
    _key VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL
);



