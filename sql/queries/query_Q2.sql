-- Query Description:
-- Find all the conferences that have ever published more than 500 papers in one year. Note that one conference may be held every year 
-- (e.g., KDD runs many years, and each year the conference has a number of papers)
use dblp;
SELECT DISTINCT conference
FROM
    (SELECT 
        SUBSTRING_INDEX(SUBSTRING_INDEX(I._key, '/', 2), '/', - 1) AS conference,
            year,
            COUNT(1) AS NumOfPapers
    FROM in_ AS I
    WHERE SUBSTRING_INDEX(I._key, '/', 1) = 'conf'
    GROUP BY conference , year
    HAVING NumOfPapers > 500) t;