-- Query Description:
-- (a) Find authors who have published at least 1 paper every year in the last 30 years, and whose family name start with ‘H’. 
USE dblp;
SELECT a.author
FROM R_author AS a
JOIN (
    SELECT _key, year
    FROM article
    WHERE article.publtype IS NULL
    UNION
    SELECT _key, year
    FROM in_
    UNION
    SELECT _key, year
    FROM thesis
) AS p ON a._key = p._key
WHERE RIGHT(a.author, LOCATE(' ', REVERSE(a.author)) - 1) LIKE 'H%'
AND p.year >= YEAR(CURDATE()) - 30
GROUP BY a.author
HAVING COUNT(DISTINCT p.year) = 30;
