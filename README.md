
# 🎬 Netflix Movies and TV Shows Data Analysis using SQL

<p align="center">
  <img src="logo.png" width="600">
</p>

## 📌 Overview

This project analyzes Netflix Movies and TV Shows data using SQL.  
The goal is to extract insights and solve real-world business questions based on the dataset.

## 🎯 Objectives

- Analyze Movies vs TV Shows distribution  
- Identify most common ratings  
- Explore content by release year, country, and duration  
- Find top genres and categories  
- Practice SQL interview-style business problems  

## 📂 Dataset

Dataset Source: Kaggle Netflix Movies and TV Shows Dataset  
https://www.kaggle.com/shivamb/netflix-shows

## 📁 Project Files

- `Netflix_sql.sql` → SQL queries for analysis  
- `netflix_dataset.csv` → Dataset file  
- `README.md` → Project documentation  
- `logo.png` → Netflix logo image  

## 📊 Business Problems Solved

1. Movies vs TV Shows count  
2. Most common ratings  
3. Top countries with most content  
4. Longest movie available  
5. Top genres on Netflix  

## 🧠 SQL Functions & Concepts Used

This project demonstrates the use of the following SQL functions and analytical concepts:

### ✅ Aggregate Functions
- `COUNT()` – Count total records and grouped occurrences  
- `MAX()` – Find maximum values (e.g., longest movie duration)  
- `ROUND()` – Round calculated percentages to decimal precision  

### ✅ Window Functions
- `DENSE_RANK()` – Rank ratings within each content type (Movies/TV Shows)  

### ✅ String Functions
- `STRING_TO_ARRAY()` – Split comma-separated values into arrays  
- `UNNEST()` – Convert array elements into rows (used for countries, genres, actors)  
- `SPLIT_PART()` – Extract season count from duration field  

### ✅ Date & Time Functions
- `TO_DATE()` – Convert string dates into proper date format  
- `CURRENT_DATE` – Fetch current system date  
- `INTERVAL` – Filter content added in the last 5 years  
- `EXTRACT()` – Extract year from date values  

### ✅ Filtering & Pattern Matching
- `LIKE` / `ILIKE` – Perform case-sensitive and case-insensitive searches  
- `IS NULL` / `IS NOT NULL` – Handle missing values  

### ✅ Conditional Logic
- `CASE WHEN` – Categorize content as *Good* or *Bad* based on keywords  

### ✅ SQL Concepts Covered
- `GROUP BY` and `HAVING`  
- Subqueries  
- Common Table Expressions (CTEs)  
- Top-N Queries using `ORDER BY` + `LIMIT`


## 🙌 Author

**Ketan Kokitkar**  
SQL & Data Analytics Enthusiast  

⭐ If you found this project useful, feel free to star the repository!
