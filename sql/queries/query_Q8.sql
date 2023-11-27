-- Query Description:
-- Retrieve only the top 10 authors with the most records of conference papers containing "reinforcement learning" between 2020 and 2023.
use dblp;
SELECT ra.author, COUNT(*) AS record_count
FROM (
    SELECT _key, title FROM article WHERE _key LIKE '%conf%' AND title LIKE '%reinforcement learning%' AND year BETWEEN 2020 AND 2023
    UNION ALL
    SELECT _key, title FROM in_ WHERE _key LIKE '%conf%' AND title LIKE '%reinforcement learning%' AND year BETWEEN 2020 AND 2023
) AS combined
JOIN R_author ra ON combined._key = ra._key
GROUP BY ra.author
ORDER BY record_count DESC
LIMIT 10;
