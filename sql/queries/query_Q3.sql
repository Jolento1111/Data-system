-- Query Description:
-- For each 10 consecutive years starting from 1970, i.e., [ 1970, 1979 ], [ 1980, 1989 ],…, [2010,2019], 
-- compute the total number of conference publications in DBLP in that 10 years. 
-- Hint: for this query you may want to compute a temporary table with all distinct years.
use dblp;
WITH DistinctYears AS (
  SELECT DISTINCT year
  FROM publish
  WHERE year >= 1970
)
SELECT
  CONCAT(FLOOR(d.year / 10) * 10, ' - ', FLOOR(d.year / 10) * 10 + 9) AS YearRange,
  COUNT(*) AS TotalPublications
FROM DistinctYears d, publish p
WHERE p.year = d.year AND SUBSTRING_INDEX(p._key,'/',1) = 'conf'
GROUP BY YearRange
ORDER BY YearRange;





