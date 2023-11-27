-- Query Description:
-- Find the names and number of publications for authors who have the earliest publication record in DBLP
use dblp;
-- Find the earliest publication year
WITH EarliestYear AS (
    SELECT MIN(year) AS min_year
    FROM (
        SELECT DISTINCT year FROM article WHERE year > 0
        UNION
        SELECT DISTINCT year FROM in_ WHERE year > 0
        UNION
        SELECT DISTINCT year FROM publish WHERE year > 0
        UNION
        SELECT DISTINCT year FROM thesis WHERE year > 0
    ) AS AllYears
),
-- Find authors who published in the earliest year
AuthorsWithEarliestPublication AS (
    SELECT ra.author
    FROM R_author ra
    INNER JOIN (
        SELECT _key FROM article WHERE year = (SELECT min_year FROM EarliestYear) and publtype IS NULL
        UNION ALL
        SELECT _key FROM in_ WHERE year = (SELECT min_year FROM EarliestYear)
        UNION ALL
        SELECT _key FROM thesis WHERE year = (SELECT min_year FROM EarliestYear)
    ) AS PublicationsInEarliestYear
    ON ra._key = PublicationsInEarliestYear._key
)
-- Count all publications for those authors
SELECT
    ra.author AS name,
    COUNT(*) AS num_publications
FROM AuthorsWithEarliestPublication a
JOIN
    R_author ra ON a.author = ra.author
JOIN
    (SELECT _key FROM article
     UNION ALL
     SELECT _key FROM in_
     UNION ALL
     SELECT _key FROM publish
     UNION ALL
     SELECT _key FROM thesis) AS AllPublications
ON ra._key = AllPublications._key
GROUP BY ra.author
ORDER BY num_publications DESC;
