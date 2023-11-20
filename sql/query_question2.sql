SELECT DISTINCT publisher
FROM publish
GROUP BY publisher,year
HAVING COUNT(*) > 500;