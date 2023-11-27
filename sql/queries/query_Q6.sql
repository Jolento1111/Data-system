-- Query Description:
-- List the name of the conferences such that it has ever been held in June, and the corresponding
-- proceedings (in the year where the conference was held in June) contain more than 100 publications.
use dblp;
SELECT p.title, p.booktitle, p.year, COUNT(*) AS publication_count
FROM publish p
	JOIN in_ i ON p._key = i.crossref
WHERE
    p.title LIKE '%June%'
        AND SUBSTRING_INDEX(p._key, '/', 1) = 'conf'
GROUP BY p.title , p.booktitle , p.year
HAVING COUNT(*) > 100;


