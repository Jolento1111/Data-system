-- Find the most collaborative authors who published in a conference or journal whose name contains “data”  
-- (e.g., ACM SIGKDD International Conference on Knowledge Discovery and Data Mining). 
-- That is, for each author determine its number of collaborators, and then find the author with the most number of collaborators. 
-- Hint: for this question you may want to compute a temporary table of coauthors.

USE dblp;

DROP VIEW IF EXISTS data_article;
DROP TABLE IF EXISTS Coauthor; 

CREATE VIEW data_article AS (
    SELECT
        article._key 
    FROM 
        article
    WHERE
        article.journal LIKE '%data%' OR article.journal LIKE '%Data%'
    UNION
    SELECT
        in_._key 
    FROM 
        in_
    WHERE
        in_.booktitle LIKE '%data%' OR in_.booktitle LIKE '%Data%'
);

CREATE Temporary TABLE Coauthor AS (
    SELECT
        ra1.author AS author,
        ra2.author AS coauthor
    FROM
        data_article da
        JOIN R_author ra1 ON da._key = ra1._key
        JOIN R_author ra2 ON da._key = ra2._key
    WHERE
        ra1.author <> ra2.author
);

-- Query using the Temporary Tables
SELECT
    Coauthor.author,
    COUNT(DISTINCT coauthor) AS coauthor_count
FROM
    Coauthor
GROUP BY
    Coauthor.author
order by
	coauthor_count DESC
Limit 10;
