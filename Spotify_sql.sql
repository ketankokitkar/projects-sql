-- Advance SQL Project - Spotify Dataset
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
-- EDA
SELECT COUNT(*) FROM spotify;

-- Easy level
--1. Retrieve the names of all the tracks that have more than 1 billion streams
SELECT * FROM spotify;
SELECT 
	track,
	stream
FROM spotify
WHERE stream > 1000000000;

--2 List all albums along with their respective artists.
SELECT 
  DISTINCT album,	
	artist
FROM spotify 
ORDER BY 1;

--3. Get the total number of comments for the tracks where licensed = TRUE
SELECT 
	SUM(comments)
FROM spotify
WHERE licensed = 'True';

--4. Find all tracks that belong to the album type single
SELECT 
	track
FROM spotify
WHERE album_type = 'single';

--5. Count the total number of tracks by each artist
SELECT 
	artist,
	count(*)
FROM spotify
GROUP BY 1
ORDER BY 2 ;

--6. Calculate the average danceability of tracks in each album.
SELECT 
	album,
	AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

--7. Find the top 5 tracks with the highest energy values.
SELECT 
	track,
	MAX(energy)
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--8. List all tracks along with their views and likes where official_video = TRUE.
SELECT 
	track,
	SUM(views) total_views,
	SUM(likes) total_likes
FROM spotify
WHERE official_video = 'true'
GROUP BY 1;

--9. For each album, calculate the total views of all associated tracks.
SELECT 
	album,
	track,
	SUM(views) total_views
FROM spotify
GROUP BY 1,2;
--10. Retrieve the track names that have been streamed on Spotify more than on YouTube.
WITH cte AS(
SELECT 
	track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS played_on_spotify,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS played_on_youtube	
FROM spotify
GROUP BY 1
)
SELECT 
	*
FROM cte
WHERE played_on_spotify > played_on_youtube and played_on_youtube !=0;


--11. Find the top 3 most-viewed tracks for each artist using window functions.
WITH cte AS (SELECT 
	artist,
	track,
	DENSE_RANK()OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rnk
FROM spotify
GROUP BY 2,1
ORDER BY 1,3 DESC)
SELECT 
	track,
	artist,
	rnk as top_3_tracks
FROM cte 
WHERE rnk<=3;


--12. Write a query to find tracks where the liveness score is above the average.
SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

--13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH cte AS (
SELECT 
	album,
	MAX(energy) AS 	max_energy,
	MIN(energy) AS  min_energy
FROM spotify 
GROUP BY 1
ORDER BY 1
)
SELECT 
	album,
	max_energy - min_energy AS energy_difference
FROM cte
ORDER BY 2 DESC

-- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2
SELECT 
	track,
	energy,
	liveness,
	energy/NULLIF(liveness, 0) AS ratio
FROM Spotify
WHERE energy/NULLIF(liveness, 0) > 1.2;
 
-- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using a window function
SELECT 
	track,
	SUM(COALESCE(likes, 0)) OVER(ORDER BY views )
FROM Spotify
ORDER BY views ;














