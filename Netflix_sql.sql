CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
select * from netflix;

select 
	count(*) as total_content
from netflix;

select 
	distinct type
from netflix;

---
SELECT * 
FROM netflix;

-- 1. Count the number of Movies vs TV shows
SELECT 
	type,
	count(*) total_content
FROM netflix
GROUP by type;

-- 2. Find the most common rating for movies and TV shows
WITH count_cte AS(
SELECT 
	type,
	rating,
	count(rating) total_count,
	DENSE_RANK() OVER(PARTITION BY type ORDER BY count(rating) DESC) as rnk
FROM netflix
GROUP BY type,rating
ORDER BY total_count DESC) 

SELECT 
	type,
	rating,
	total_count
FROM count_cte
WHERE rnk = 1;


-- Subquery 

SELECT 
	type,
	rating,
	total_count
FROM (
SELECT 
	type,
	rating,
	count(rating) total_count,
	DENSE_RANK() OVER(PARTITION BY type ORDER BY count(rating) DESC) as rnk
FROM netflix
GROUP BY type,rating
ORDER BY total_count DESC) subquery
WHERE rnk = 1;

-- 3. List all movies released in a specific year (e.g. 2020)
SELECT * FROM netflix;
SELECT 
	title, 
	release_year
FROM netflix
WHERE type ILIKE 'movie' AND release_year = '2020';

-- 4. Find the top 5 countries with the most content on Netflix
SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country;
 
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS country, 
	count(country) total_count
FROM netflix 
WHERE country IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 5. Identify the longest movie
SELECT * FROM netflix;

SELECT 
	*
FROM netflix
WHERE type = 'Movie' AND duration = (SELECT MAX(duration)FROM netflix);

-- 6. Find content added in last 5 years
SELECT 
	* 
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

select TO_DATE(date_added, 'Month DD, YYYY') from netflix;

-- 7. Find all the Movies/ TV shows by director 'Rajiv Chilaka'
SELECT 
	title,
	UNNEST(STRING_TO_ARRAY(director,',')) AS director
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
AND SPLIT_PART(duration,' ', 1)::INT > 5
ORDER BY duration DESC;

-- 9. Count the Number of Content Items in Each Genre
DESCRIBE netflix; -- IT not work in Pl SQL

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'netflix';

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
	COUNT(*) AS total_count
FROM netflix
GROUP BY 1
ORDER BY total_count DESC;

-- 10. Find each year and the average number of content releases by India on Netflix.
-- Return the top 5 years with the highest avg content release
SELECT 
	EXTRACT( YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS YEAR,
	COUNT(*) yearly_content,
	ROUND(COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100 , 2) AS avg_count_per_year
FROM netflix 
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 11. List all movies that are documentaries
SELECT 
	* 
FROM netflix
WHERE listed_in ILIKE '%documentaries%';

-- 12. Find all content without a director
SELECT 
	*
FROM netflix
WHERE director IS NULL;

-- 13. Find how many movies actor 'Salaman Khan' appeared in last 10 years;
SELECT * 
FROM netflix 
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) -10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
	COUNT(*) AS count_num
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 15. Categorise the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label contest containing these keywords as 'Bad' and all other
-- content as 'Good'. Count how many items fall into each category.
WITH cte AS(SELECT 
	type,
	title,
	CASE
	WHEN description ILIKE '%kill%' or description ILIKE '%violence%' THEN 'Bad Content'
	ELSE 'Good Content'
	END AS case1		
FROM netflix)
SELECT 
	case1,
	COUNT(*)
FROM cte
GROUP BY case1;



















  
  












