
# 🎵 Spotify Data Analysis using SQL

<p align="center">
  <img src="spotify_logo.png" width="600">
</p>

📌 Overview  
This project analyzes Spotify music dataset using Advanced SQL queries.  
The goal is to extract meaningful insights and solve real-world business problems related to streams, views, likes, albums, and artist performance.

🎯 Objectives  
- Identify highly streamed tracks and popular albums  
- Analyze engagement metrics such as likes, comments, and views  
- Rank top-performing tracks by artists  
- Apply window functions and CTEs for advanced analytics  
- Practice SQL interview-style business problem solving  

📂 Dataset  
Dataset Source: Kaggle Spotify Dataset  
https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset  

---

## 📊 Business Problems Solved (With SQL Solutions)

---

### 1. Tracks with More Than 1 Billion Streams

```sql
SELECT 
    track,
    stream
FROM spotify
WHERE stream > 1000000000;
````

---

### 2. List Albums Along With Their Respective Artists

```sql
SELECT DISTINCT 
    album,
    artist
FROM spotify
ORDER BY 1;
```

---

### 3. Total Comments for Licensed Tracks

```sql
SELECT 
    SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE;
```

---

### 4. Tracks Belonging to Single-Type Albums

```sql
SELECT 
    track
FROM spotify
WHERE album_type = 'single';
```

---

### 5. Total Tracks Count by Each Artist

```sql
SELECT 
    artist,
    COUNT(*) AS total_tracks
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;
```

---

### 6. Average Danceability Score per Album

```sql
SELECT 
    album,
    AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;
```

---

### 7. Top 5 Tracks With Highest Energy

```sql
SELECT 
    track,
    MAX(energy) AS highest_energy
FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

---

### 8. Views and Likes for Official Videos

```sql
SELECT 
    track,
    SUM(views) AS total_views,
    SUM(likes) AS total_likes
FROM spotify
WHERE official_video = TRUE
GROUP BY 1;
```

---

### 9. Total Views per Album and Track

```sql
SELECT 
    album,
    track,
    SUM(views) AS total_views
FROM spotify
GROUP BY 1,2;
```

---

### 10. Tracks Streamed More on Spotify Than YouTube

```sql
WITH cte AS (
    SELECT 
        track,
        COALESCE(SUM(CASE 
            WHEN most_played_on = 'Spotify' THEN stream 
        END), 0) AS played_on_spotify,

        COALESCE(SUM(CASE 
            WHEN most_played_on = 'Youtube' THEN stream 
        END), 0) AS played_on_youtube
    FROM spotify
    GROUP BY 1
)
SELECT *
FROM cte
WHERE played_on_spotify > played_on_youtube
  AND played_on_youtube != 0;
```

---

### 11. Top 3 Most-Viewed Tracks per Artist Using DENSE_RANK

```sql
WITH cte AS (
    SELECT 
        artist,
        track,
        DENSE_RANK() OVER(
            PARTITION BY artist 
            ORDER BY SUM(views) DESC
        ) AS rnk
    FROM spotify
    GROUP BY 1,2
)
SELECT 
    track,
    artist,
    rnk AS top_3_tracks
FROM cte
WHERE rnk <= 3;
```

---

### 12. Tracks With Liveness Above Average

```sql
SELECT 
    track,
    artist,
    liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```

---

### 13. Energy Difference Between Highest and Lowest Track per Album

```sql
WITH cte AS (
    SELECT 
        album,
        MAX(energy) AS max_energy,
        MIN(energy) AS min_energy
    FROM spotify
    GROUP BY 1
)
SELECT 
    album,
    max_energy - min_energy AS energy_difference
FROM cte
ORDER BY 2 DESC;
```

---

### 14. Tracks With Energy-to-Liveness Ratio Greater Than 1.2

```sql
SELECT 
    track,
    energy,
    liveness,
    energy / NULLIF(liveness, 0) AS ratio
FROM spotify
WHERE energy / NULLIF(liveness, 0) > 1.2;
```

---

### 15. Cumulative Sum of Likes Ordered by Views

```sql
SELECT 
    track,
    SUM(COALESCE(likes, 0)) OVER(ORDER BY views) AS cumulative_likes
FROM spotify
ORDER BY views;
```

---

🧠 SQL Functions & Concepts Used
This project demonstrates the use of the following SQL functions and analytical concepts:

✅ Aggregate Functions

COUNT() – Count total records and grouped occurrences
SUM() – Calculate total likes, comments, and views
AVG() – Compute average danceability and liveness
MAX() / MIN() – Find highest and lowest energy values

✅ Window Functions

DENSE_RANK() – Retrieve top tracks per artist
SUM() OVER() – Calculate cumulative likes ordered by views

✅ Conditional Logic

CASE WHEN – Compare streams between Spotify and YouTube

✅ String & NULL Handling

COALESCE() – Replace NULL values with defaults
NULLIF() – Prevent division by zero in ratio calculations

✅ SQL Concepts Covered

GROUP BY and ORDER BY
Subqueries
Common Table Expressions (CTEs)
Top-N Queries using ORDER BY + LIMIT
Analytical Ranking per Group

---

## 🙌 Author

**Ketan Kokitkar**  
SQL & Data Analytics Enthusiast  

⭐ If you found this project useful, feel free to star the repository!
