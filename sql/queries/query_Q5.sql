-- Query Description:
-- Data analytics and data science are very popular topics. Find the top 10 authors with the largest
-- number of publications that are published in conferences and journals whose titles contain word “Data” in the last 5 years.

USE dblp;
SELECT 
    ra.author, COUNT(*) AS publication_count
FROM
    (SELECT a._key
    FROM article a
    WHERE
        a.journal LIKE '%Data%'
            AND a.publtype IS NULL
            AND (SUBSTRING_INDEX(a._key, '/', 1) = 'conf' OR SUBSTRING_INDEX(a._key, '/', 1) = 'journals')
            AND a.year >= YEAR(CURDATE()) - 5 
	UNION ALL 
    SELECT I._key
    FROM in_ I
    JOIN publish P ON I.crossref = P._key
    WHERE
        SUBSTRING_INDEX(I._key, '/', 1) = 'conf'
            AND P.title LIKE '%Data%'
            AND I.year >= YEAR(CURDATE()) - 5) AS publication_keys
        JOIN
    R_author ra ON publication_keys._key = ra._key
GROUP BY ra.author
ORDER BY publication_count DESC
LIMIT 10;
