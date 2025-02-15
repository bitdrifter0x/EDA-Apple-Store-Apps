CREATE TABLE applestore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

-- check the number of unique apps in AppleStore and applestore_description_combined

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM applestore_description_combined

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

-- Check for any missing values in key feilds

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS MissingValues
FROM applestore_description_combined
WHERE app_desc IS NULL 

-- Find out No of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

-- Get an Overview of app ratings

SELECT min(user_rating) AS MinRating,
       max(user_rating) AS MaxRating,
      avg(user_rating) AS AvgRating
FROM AppleStore      

**DATA ANALYSIS**
-- Determine whether paid apps have higher rating than free apps

SELECT CASE
           WHEN price > 0 THEN 'Paid'
           ELSE 'Free'
           END AS App_Type,
           avg(user_rating) AS Avg_Rating
           
FROM AppleStore
GROUP BY App_Type

-- Check if apps with more supported language have higher rating

SELECT CASE
           WHEN lang_num < 10 THEN '<10 languages'
           WHEN lang_num BETWEEN 10 AND 30 THEN '10 - 30 languages'
           ELSE '>30 languages'
     END AS language_bucket, 
     avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC

-- Check Genre with lowest rating

SELECT prime_genre,
avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10

-- Check if there is correlation between length of App Description and user rating

SELECT CASE
           WHEN length(b.app_desc) < 500 THEN 'Short'
           WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
           ELSE 'Long'
       END AS description_length_bracket,
       avg(a.user_rating) AS average_rating
       
FROM
    AppleStore AS a
JOIN
    applestore_description_combined AS b
ON
    a.id = b.id
    
GROUP BY description_length_bracket
ORDER BY average_rating DESC

-- Top rated apps for each genre

SELECT
prime_genre,
track_name,
user_rating

FROM ( 
  SELECT
prime_genre,
track_name,
user_rating,
  RANK () OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
  FROM AppleStore
  ) AS a
  WHERE
  a.rank = 1
  


