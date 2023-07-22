USE laptop;

-- Exploratory Data Analysis (EDA)
SELECT * FROM laptop;

-- Head
SELECT *
FROM laptop
LIMIT 5;

-- Tail
SELECT *
FROM laptop
ORDER BY `index` DESC
LIMIT 5;

-- Random Sample
SELECT *
FROM laptop
ORDER BY rand()
LIMIT 5;

-- Info
SELECT
  COUNT(Price) AS Count,
  MIN(Price) AS MinPrice,
  MAX(Price) AS MaxPrice,
  ROUND(AVG(Price), 2) AS AvgPrice,
  ROUND(STD(Price), 2) AS StdPrice
FROM laptop
ORDER BY `index`
 LIMIT 1;
 
 -- Check for missing values
 SELECT COUNT(*)
 FROM laptop
 WHERE price IS NULL;
 
 -- Define price categories
 SELECT price,
  CASE
    WHEN price BETWEEN 0 AND 25000 THEN '0-25K'
    WHEN price BETWEEN 25001 AND 50000 THEN '25K-50K'
    WHEN price BETWEEN 50001 AND 75000 THEN '50K-75K'
    WHEN price BETWEEN 75001 AND 100000 THEN '75K-100K'
    ELSE '>100K'
  END AS price_range
FROM laptop;

-- Count the laptops based on companies
SELECT Company, COUNT(*)
FROM laptop
GROUP BY Company;

-- CATEGORICAL DATA

-- Count the laptops based on gpu_brand
SELECT Company, COUNT(*) as 'TotalLaptop',
SUM(CASE WHEN gpu_brand = 'AMD' THEN 1 ELSE 0 END) as 'AMD',
SUM(CASE WHEN gpu_brand = 'Nvidia' THEN 1 ELSE 0 END) as 'Nvidia',
SUM(CASE WHEN gpu_brand = 'Intel' THEN 1 ELSE 0 END) as 'Intel',
SUM(CASE WHEN gpu_brand = 'ARM' THEN 1 ELSE 0 END) as 'ARM'
FROM laptop
GROUP BY Company;

-- ONE HOT ENCODING
SELECT gpu_brand FROM laptop
GROUP BY gpu_brand;

SELECT gpu_brand,
CASE WHEN gpu_brand = 'AMD' THEN 1 ELSE 0 END AS 'AMD',
CASE WHEN gpu_brand = 'Nvidia' THEN 1 ELSE 0 END AS 'Nvidia',
CASE WHEN gpu_brand = 'Intel' THEN 1 ELSE 0 END AS 'Intel',
CASE WHEN gpu_brand = 'ARM' THEN 1 ELSE 0 END AS 'ARM'
FROM laptop;

-- Count the number of laptops for each CPU brand
SELECT cpu_brand, 
       COUNT(*) as laptop_count
FROM laptop
GROUP BY cpu_brand;

-- Get the top 5 CPU models with the highest average CPU speed:
SELECT cpu_name, ROUND(AVG(cpu_speed), 2) as avg_cpu_speed
FROM laptop
GROUP BY cpu_name
ORDER BY avg_cpu_speed DESC
LIMIT 5;

-- Find the fastest CPU (highest CPU speed) and its details:
SELECT *
FROM laptop
WHERE cpu_speed = (SELECT MAX(cpu_speed) FROM laptop);

-- Find the number of laptops based on the RAM
SELECT ram, COUNT(*) as count
FROM laptop
GROUP BY ram
ORDER BY ram DESC;

-- EDA ends here
-- If you want to explore further, you can write some queries for memory,weight,etc. I think you got the idea. HAVE FUN!:)


 
 

