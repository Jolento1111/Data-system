USE `dblp`;

DROP TABLE IF EXISTS thesis; 

CREATE TABLE thesis (
    _key VARCHAR(255) NOT NULL,
    mdate DATE NOT NULL,
    title VARCHAR(255),
    school VARCHAR(255),
    year INT,
    ee VARCHAR(255),
    _type VARCHAR(255)
);