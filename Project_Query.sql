--- NETFLIX PROJECT ---
 
--- Create Table ---

CREATE TABLE Netflix 
(
  Show_id VARCHAR(7),
  Content_Type VARCHAR(7),
  Title VARCHAR(160),
  Director VARCHAR(215),
  Casts VARCHAR(1100),
  Country VARCHAR(160),
  Date 	VARCHAR(60),
  Release_Year VARCHAR(15),
  Rating VARCHAR(15),
  Duration VARCHAR(20),
  Genres VARCHAR(300),
  Description VARCHAR(260)
);

--- Details of Table ---

SELECT * FROM Netflix;

--- No. of Data present in Table---

SELECT COUNT(*) FROM Netflix;

--- Business Questions ---

-- 1. Count No. of Movies and TV Shows

SELECT content_type, COUNT(*) FROM Netflix
GROUP BY content_type;

-- 2. Find the most common rating for Movies and TV Shows 

SELECT content_type , rating , COUNT(*)
FROM NetfLix
GROUP BY content_type , rating 
ORDER BY COUNT(*) DESC;


SELECT content_type , rating , ranking FROM 
( SELECT content_type , rating , COUNT(*),
RANK() OVER (PARTITION BY content_type ORDER BY COUNT(*) DESC) AS ranking 
FROM NetfLix
GROUP BY content_type , rating ) AS t
WHERE ranking = 1;


-- 3. List all Movies that is released in 2020

SELECT * FROM Netflix
WHERE content_type = 'Movie' AND release_year = '2020';


-- 4. Find the top 5 countries with the most content on Netflix 

SELECT country , COUNT(show_id)
FROM Netflix
GROUP BY country;

SELECT UNNEST (STRING_TO_ARRAY(country, ',')) as new_country,
COUNT(show_id) as total_content
FROM Netflix
GROUP BY new_country 
ORDER BY COUNT(show_id) DESC
LIMIT 5;


-- 5. Identify longest movie 

SELECT * FROM Netflix
WHERE content_type = 'Movie' AND duration =
(SELECT MAX(duration) FROM Netflix);


-- 6. Find content added in last 5 years

SELECT CURRENT_DATE - INTERVAL '5 years';

ALTER TABLE Netflix
ALTER COLUMN date TYPE DATE 
USING TO_DATE(date, 'Month DD, YYYY');


SELECT * FROM Netflix
WHERE date >= CURRENT_DATE - INTERVAL '5 years';


-- 7. Find all the Movies/TV Shows by Director 'Rajiv Chilaka'

SELECT * FROM Netflix
WHERE director = 'Rajiv Chilaka';

--- If there is two directors together ----

SELECT * FROM Netflix
WHERE director LIKE '%Rajiv Chilaka%';

--- If there is case-sensitive in name ---

SELECT * FROM Netflix
WHERE director ILIKE '%Rajiv Chilaka%';


-- 8. List all the TV Shows with more than 5 seasons

SELECT * FROM Netflix
WHERE content_type = 'TV Show' and duration > '5 seasons';


-- 9. Count the number of content in each genre

SELECT COUNT(show_id),
UNNEST(STRING_TO_ARRAY(genres,',')) as genre
FROM Netflix
GROUP BY genre;


-- 10. Find each year and the average numbers of content release by India on Netflix ,
-- return top 5 with highest avg content release

SELECT EXTRACT(YEAR FROM date)as year,
COUNT(*) as yearly_content,
ROUND(Count(*)::numeric/(SELECT COUNT(*) FROM Netflix WHERE country = 'India')::numeric 
*100,2) as average_content 
FROM Netflix
WHERE country = 'India'
GROUP BY year
ORDER BY COUNT(*) DESC
LIMIT(5);


-- 11. List all Movies that are documentaries

SELECT * FROM Netflix
WHERE content_type = 'Movie' and genres LIKE '%Documentaries%';


-- 12. Find all content without director

SELECT * FROM Netflix
WHERE director IS NULL;


-- 13 . Find how many movies actor ' Salman Khan' appeared in last 10 years

SELECT * FROM Netflix
WHERE casts LIKE '%Salman Khan%' AND
release_year::numeric > EXTRACT(YEAR from CURRENT_DATE) - 10;


--14. Find the top 10 actors who have appeared in the highest number of movies produced 
-- in India 

SELECT COUNT(*),
UNNEST(STRING_TO_ARRAY(casts, ',' )) AS actors FROM Netflix
WHERE Country LIKE '%India'
GROUP BY actors
ORDER BY COUNT(*) DESC
LIMIT(10);


-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence'
-- in the description field and Label content containing these keywords as 'bad' and all 
-- other content as 'good'. Count how many items fall into each category

WITH new_table
AS 
(
SELECT *, 
CASE 
WHEN 
description LIKE '%kill%' or description LIKE '%violence%' 
THEN 'Bad_Content' ELSE 'Good_Content'
END category
FROM Netflix
)
SELECT category, COUNT(*) AS total
FROM new_table
GROUP BY category;











