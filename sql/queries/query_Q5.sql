use dblp;
SELECT author_name, COUNT(*) AS publication_count
FROM (
    SELECT
        SUBSTRING_INDEX(SUBSTRING_INDEX(art.author, '::', numbers.n), '::', -1) AS author_name
    FROM
        dblp.article AS art
    JOIN
        (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) numbers
        ON LENGTH(art.author) - LENGTH(REPLACE(art.author, '::', '')) >= (numbers.n - 1) * 2
    WHERE
        art.title LIKE '%Data%'
        AND art.year >= YEAR(CURDATE()) - 5
) AS split_authors
GROUP BY author_name
ORDER BY publication_count DESC
LIMIT 10;
