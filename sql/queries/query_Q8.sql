use dblp;
SELECT p.title AS PublicationTitle, COUNT(a.`key`) AS ArticleCount, a.year AS PublicationYear
FROM publish p
JOIN article a ON a.year = p.year AND a.journal = p.title
GROUP BY p.title, a.year
HAVING COUNT(a.`key`) > 30;
