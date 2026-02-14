
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

📁 Project Files  
- SQL_Spotify.sql → SQL queries for analysis  
- cleaned_dataset.csv → Spotify dataset used for analysis  
- README.md → Project documentation  
- logo.png → Spotify logo image  

📊 Business Problems Solved  
- Tracks with more than 1 billion streams  
- List albums along with their respective artists  
- Total comments for licensed tracks  
- Tracks belonging to single-type albums  
- Total tracks count by each artist  
- Average danceability score per album  
- Top 5 tracks with highest energy  
- Views and likes for official videos  
- Total views per album and track  
- Tracks streamed more on Spotify than YouTube  
- Top 3 most-viewed tracks per artist using DENSE_RANK  
- Tracks with liveness above average  
- Energy difference between highest and lowest track per album  
- Tracks with energy-to-liveness ratio greater than 1.2  
- Cumulative sum of likes ordered by views  

🧠 SQL Functions & Concepts Used  
This project demonstrates the use of the following SQL functions and analytical concepts:

✅ Aggregate Functions  
- COUNT() – Count total records and grouped occurrences  
- SUM() – Calculate total likes, comments, and views  
- AVG() – Compute average danceability and liveness  
- MAX() / MIN() – Find highest and lowest energy values  

✅ Window Functions  
- DENSE_RANK() – Retrieve top tracks per artist  
- SUM() OVER() – Calculate cumulative likes ordered by views  

✅ Conditional Logic  
- CASE WHEN – Compare streams between Spotify and YouTube  

✅ String & NULL Handling  
- COALESCE() – Replace NULL values with defaults  
- NULLIF() – Prevent division by zero in ratio calculations  

✅ SQL Concepts Covered  
- GROUP BY and ORDER BY  
- Subqueries  
- Common Table Expressions (CTEs)  
- Top-N Queries using ORDER BY + LIMIT  
- Analytical Ranking per Group  

🙌 Author  
Ketan Kokitkar  
SQL & Data Analytics Enthusiast  

⭐ If you found this project useful, feel free to star the repository!
🔙 **[Back to all sql projects](../README.md)**

