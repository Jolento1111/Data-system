-- Query Description:
-- For each type of publication, count the total number of publications of that type between 2010-2019. 
-- Your query should return a set of (publication-type, count) pairs. For example, (article, 20000), (inproceedings, 30000), ...

-- Note: Since most of web articles in the dblp database don't have the year attribute, we didn't include the year column in the www table when importing the data, so web articles are not included in this query
use dblp;
(SELECT COUNT(1) AS total_number, 'article' AS _type
FROM article
WHERE year >= 2010 AND year <= 2019) 
UNION 
(SELECT COUNT(1) AS total_number, _type
FROM in_
WHERE year >= 2010 AND year <= 2019
GROUP BY _type) 
UNION 
(SELECT COUNT(1) AS total_number, _type
FROM thesis
WHERE year >= 2010 AND year <= 2019
GROUP BY _type) 
UNION 
(SELECT COUNT(1) AS total_number, _type
FROM publish
WHERE year >= 2010 AND year <= 2019
GROUP BY _type) 
ORDER BY total_number DESC;


