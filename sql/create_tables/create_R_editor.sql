-- CREATE TABLES R_editor
USE `dblp`;

-- drop R_editor table if exists
DROP TABLE IF EXISTS R_editor; 

-- create R_editor table
CREATE TABLE R_editor (
    _key VARCHAR(255) NOT NULL,
    editor VARCHAR(255) NOT NULL
);



