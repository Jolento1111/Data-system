USE `dblp`;

DROP TABLE IF EXISTS www; 

CREATE TABLE www (
    _key VARCHAR(255) NOT NULL,
    mdate DATE NOT NULL,
    title VARCHAR(255)
);