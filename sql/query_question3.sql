WITH DistinctYears AS (
  SELECT DISTINCT year
  FROM publish
  WHERE year >= 1970
)

SELECT
  CONCAT(FLOOR(d.year / 10) * 10, ' - ', FLOOR(d.year / 10) * 10 + 9) AS YearRange,
  COUNT(*) AS TotalPublications
FROM
  DistinctYears d, publish p
WHERE
  p.year = d.year
GROUP BY
  YearRange
ORDER BY
  YearRange;





