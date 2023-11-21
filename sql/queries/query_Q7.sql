USE dblp;

WITH RECURSIVE numbers (n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 5
),
AuthorYears AS (
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(article.author, '::', numbers.n), '::', -1) AS single_author,
           article.year
    FROM numbers INNER JOIN article
    ON CHAR_LENGTH(article.author)
       -CHAR_LENGTH(REPLACE(article.author, '::', '')) >= numbers.n - 1
    WHERE article.year BETWEEN YEAR(CURRENT_DATE) - 29 AND YEAR(CURRENT_DATE)
    AND article.author LIKE '%H%'
    GROUP BY single_author, article.year
)
SELECT single_author
FROM AuthorYears
GROUP BY single_author
HAVING COUNT(DISTINCT year) = 30;
