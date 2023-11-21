-- Query Description:
-- For each type of publication, count the total number of publications of that type between 2010-2019. 
-- Your query should return a set of (publication-type, count) pairs. For example, (article, 20000), (inproceedings, 30000), ...

-- Notes: 
-- Since most of web articles in the dblp database don't have the year attribute, we didn't include the year column in the www table when importing the data, so web articles are not included in this query
use dblp;

(select count(1) as total_number, 'article' as _type from article
where year>=2010 and year<=2019)
union
(select count(1) as total_number, _type from in_
where year>=2010 and year<=2019
group by _type)
union
(select count(1) as total_number, _type from thesis
where year>=2010 and year<=2019
group by _type)
union
(select count(1) as total_number, _type from publish
where year>=2010 and year<=2019
group by _type)
order by total_number desc;


