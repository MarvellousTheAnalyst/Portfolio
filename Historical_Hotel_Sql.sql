--Hello and welcome to this SQL project

--Questions that will be answered 

--Q1. Is hotel Revenue Growing by Year?
--Q2. Should parking lot size be Increased?
--Q3. What trends can be found/seen?

--Joining all tables into one 

WITH hotels as (
SELECT * FROM dbo.['2018$']
UNION
SELECT * FROM dbo.['2019$']
UNION
SELECT * FROM dbo.['2020$'])

--Q1. Is hotel revenue growing by year

SELECT arrival_date_year, hotel, ROUND(SUM((stays_in_week_nights + stays_in_weekend_nights) *adr), 2) AS revenue
FROM hotels
GROUP BY arrival_date_year, hotel


--Q2. Should we increase our parking lot size 
--Q3. What trend do we see in the Data
--(Both questions answered in Power Bi)

SELECT * 
FROM hotels
LEFT JOIN dbo.market_segment$
ON hotels.market_segment = market_segment$.market_segment
LEFT JOIN dbo.meal_cost$
ON meal_cost$.meal = hotels.meal

--Query result Loaded into POWER BI using ETL method (Extraction via SQL).
