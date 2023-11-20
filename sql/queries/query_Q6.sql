use dblp;
SELECT p.booktitle AS ConferenceName, COUNT(a.`key`) AS PublicationCount, YEAR(p.mdate) AS ConferenceYear
FROM publish p
JOIN article a ON a.journal = p.booktitle AND a.year = YEAR(p.mdate)
WHERE MONTH(p.mdate) = 6
GROUP BY p.booktitle, YEAR(p.mdate)
HAVING COUNT(a.`key`) > 100;
