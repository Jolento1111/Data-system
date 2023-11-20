WITH Coauthor AS (
    SELECT
        R_author.author AS author,
        COUNT(DISTINCT article._key) AS article_coauthor_count,
        COUNT(DISTINCT in_._key) AS in_coauthor_count
    FROM
        R_author
        LEFT JOIN article ON R_author._key = article._key AND article.journal LIKE '%data%'
        LEFT JOIN in_ ON R_author._key = in_._key AND in_.booktitle LIKE '%data%'
    GROUP BY
        R_author.author
)

SELECT
    author,
    COALESCE(article_coauthor_count, 0) + COALESCE(in_coauthor_count, 0) AS total_coauthor_count
FROM
    Coauthor
WHERE
     COALESCE(article_coauthor_count, 0) + COALESCE(in_coauthor_count, 0) >= ALL (SELECT COALESCE(article_coauthor_count, 0) + COALESCE(in_coauthor_count, 0)
                                                                                  FROM Coauthor)
