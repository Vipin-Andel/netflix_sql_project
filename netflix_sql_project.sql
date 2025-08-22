SELECT * FROM netflix;
SELECT COUNT(*) AS total_content FROM netflix;

-- business problems 

--1. Count the  number of movies vs tv shows
SELECT type, COUNT(type) AS total_type
FROM netflix
GROUP BY type;

--2. Find the most common ratings for movie and TV show
SELECT type, rating
FROM (SELECT type, rating, COUNT(*), RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
	FROM netflix
	GROUP BY type, rating) AS t1
WHERE ranking = 1;

--3. Find the most common rating 
SELECT rating, COUNT(rating) as total_rating
FROM netflix
GROUP BY rating
ORDER BY total_rating DESC LIMIT 1;

--4. List all movies released in a specific year (e.g., 2020)
SELECT type, release_year, title
FROM netflix
Where type = 'Movie' AND release_year = 2020;

--5. Find the top 5 countries with the most content on Netflix
SELECT TRIM(UNNEST(STRING_TO_ARRAY(country,','))) AS new_country, COUNT(show_id) AS total_content
FROM netflix
WHERE country != 'null'
GROUP BY 1
ORDER BY 2 DESC LIMIT 5;

--6. Identify the longest movie
SELECT title, SPLIT_PART(duration,' ',1):: INT AS duration
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY duration DESC
LIMIT 1;            

--7. Find content added in the last 5 years
SELECT * FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--8. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT *
FROM netflix
-- WHERE director = 'Rajiv Chilaka'; as some movies as two or more director name we will not get accurate result using this
WHERE director ILIKE '%Rajiv Chilaka%'

--9. List all TV shows with more than 5 seasons
SELECT *,SPLIT_PART(duration,' ',1):: INT AS total_season
FROM netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration,' ',1):: INT > 5
ORDER BY total_season DESC;

--10. Count the number of content items in each genre
SELECT TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre, 
	   COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY total_content DESC;

--11. Find each year content release in India on netflix and its percent of total content.
--Return top 5 year with highest avg content release! 
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	   COUNT(*) AS total_content,
	   ROUND(COUNT(*):: NUMERIC/ (SELECT COUNT(*) FROM netflix WHERE country = 'India'):: NUMERIC * 100, 2) AS avg_content_per_year
FROM netflix
WHERE country ILIKE 'India'
GROUP BY 1
ORDER BY avg_content_per_year DESC LIMIT 5;

--12. List all movies that are documentaries
SELECT type, title, listed_in
FROM netflix
WHERE listed_in ILIKE '%documentaries%';

--13. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL;

--14. Find in how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT type, title,release_year, casts
FROM netflix
WHERE casts ILIKE '%Salman Khan%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

--15. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT UNNEST(STRING_TO_ARRAY(casts,',')) AS actors,
	   COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY actors
ORDER BY total_content DESC LIMIT 10;

-- 16. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
WITH new_table AS(
	SELECT *,
	CASE 
	WHEN
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'bad_content'
		ELSE 'good_content'
	END category	
FROM netflix
)
SELECT category, COUNT(*) AS total_content
FROM new_table
GROUP BY 1;



 



                                                                                                                                          

																																		 

