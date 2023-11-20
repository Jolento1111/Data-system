use dblp;
SELECT a.name, COUNT(*) AS publication_count
FROM author a
JOIN article ar ON ar.author LIKE '%' || a.name || '%'
GROUP BY a.name
ORDER BY MIN(ar.year), COUNT(*) DESC
LIMIT 1;
