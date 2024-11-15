create database Amazon
use Amazon
-- 1. Product Analysis
-- Top-Performing Product Lines:


SELECT * FROM `amazon (1)`;
-- 1. Product Analysis
-- Top-Performing Product Lines:

SELECT `Product line`, SUM(Total) AS total_sales
FROM `amazon (1)`
GROUP BY `Product line`
ORDER BY total_sales DESC;

SELECT `Product line`, SUM(Total) AS total_sales
FROM `amazon (1)`
GROUP BY `Product line`
ORDER BY total_sales asc


-- Average Ratings by Product Line:

SELECT `Product line`, AVG(Rating) AS avg_rating
FROM `amazon (1)`
GROUP BY `Product line`
ORDER BY avg_rating DESC;

-- Sales Analysis
-- Sales Trends: Aggregate sales by time, day, and month to look for patterns.

SELECT Time, SUM(Total) AS total_sales
FROM `amazon (1)`
GROUP BY Time
ORDER BY total_sales DESC;

SELECT 
    City, 
    `Product line`, 
    SUM(Total) AS total_sales
FROM 
    `amazon (1)`
GROUP BY 
    City, `Product line`
ORDER BY 
    City, total_sales DESC;
    
    WITH RankedSales AS (
    SELECT 
        City,
        `Product line`,
        SUM(Total) AS total_sales,
        RANK() OVER (PARTITION BY City ORDER BY SUM(Total) DESC) AS sales_rank
    FROM 
        `amazon (1)`
    GROUP BY 
        City, `Product line`
)
SELECT 
    City,
    `Product line`,
    total_sales
FROM 
    RankedSales
WHERE 
    sales_rank = 1
ORDER BY 
    total_sales DESC;


SELECT City, SUM(Total) AS total_sales
FROM `amazon (1)`
GROUP BY City
ORDER BY total_sales DESC;
ALTER TABLE `amazon (1)` 
MODIFY `Invoice Id` VARCHAR(255);
ALTER TABLE `amazon (1)` 
ADD PRIMARY KEY (`Invoice Id`);

ALTER TABLE `amazon (1)` ADD COLUMN dayname VARCHAR(10);
ALTER TABLE `amazon (1)`
drop column dayname 

SELECT `Customer type`, COUNT(*) AS transaction_count, SUM(Total) AS total_spent, AVG(Total) AS avg_spent
FROM `amazon (1)`
GROUP BY `Customer type`
ORDER BY total_spent DESC;

SELECT Gender, SUM(Total) AS total_sales
FROM `amazon (1)`
GROUP BY Gender;


ALTER TABLE `amazon (1)`
ADD COLUMN `timeofday` VARCHAR(20);

UPDATE `amazon (1)`
SET `timeofday` = CASE
    WHEN HOUR(`Time`) BETWEEN 0 AND 11 THEN 'Morning'
    WHEN HOUR(`Time`) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END;

ALTER TABLE `amazon (1)`
ADD COLUMN `dayname` VARCHAR(10);

UPDATE `amazon (1)`
SET `Date` = STR_TO_DATE(`Date`, '%d-%m-%Y');

ALTER TABLE `amazon (1)`
ADD COLUMN `monthname` VARCHAR(3);

UPDATE `amazon (1)`
SET `monthname` = LEFT(MONTHNAME(`Date`), 3);

select * from `amazon (1)`

SELECT COUNT(DISTINCT `City`) AS distinct_city_count
FROM `amazon (1)`;

SELECT `Branch`, `City`
FROM `amazon (1)`
GROUP BY `Branch`, `City`;

SELECT COUNT(DISTINCT `Product line`) AS Distinct_Product_Count
FROM `amazon (1)`;

-- Which payment method occurs most frequently?

SELECT `Payment`, COUNT(*) AS Payment_Method_Occurence
FROM `amazon (1)`
GROUP BY `Payment`
ORDER BY Payment_Method_Occurence DESC;

select `Product line`, sum(Total) as Total_Sales
from `amazon (1)`
group by `Product line`
order by sum(Total) desc

select monthname, sum(Total) as Total_Sales 
from `amazon (1)` 
group by monthname
order by Total_Sales

SELECT `Product line`, SUM(`Tax 5%`) AS Highest_TaxPaid
FROM `amazon (1)`
GROUP BY `Product line`
ORDER BY Highest_TaxPaid DESC;

SELECT `Product line`,
       Total,
       IF(Total > (SELECT AVG(Total) FROM `amazon (1)`), 'Good', 'Bad') AS Sales_Category
FROM `amazon (1)`;

SELECT Branch,
SUM(Quantity) AS total_products_sold
FROM `amazon (1)`
GROUP BY Branch
HAVING total_products_sold > (SELECT AVG(total_branch_sales) 
FROM (SELECT Branch, SUM(Quantity) AS total_branch_sales 
FROM `amazon (1)`
GROUP BY branch) AS branch_totals);

SELECT Gender, 
       `Product line`, 
       COUNT(*) AS purchase_count
FROM `amazon (1)`
GROUP BY Gender, `Product line`
ORDER BY Gender, purchase_count DESC;

select `Product line`, avg(Rating) as Average_Rating
from `amazon (1)`
group by `Product line`
order by Average_Rating

-- Sales Occurence 

Select DAYNAME(date) AS weekday,
timeofday,
COUNT(*) AS sales_count
FROM `amazon (1)`
GROUP BY weekday, timeofday
ORDER BY FIELD(weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), timeofday;

SELECT `Customer type`, 
       COUNT(*) AS Customer_Count, 
       SUM(Total) AS Total_Revenue
FROM `amazon (1)`
GROUP BY `Customer type`
ORDER BY Total_Revenue DESC;

select City, Count(*) as City_Count, 
sum(`Tax 5%`) as Total_Tax
from `amazon (1)`
group by City 
order by Total_Tax desc

select `Customer type`, Count(*) as Custpmer_Count, 
sum(`Tax 5%`) as Total_Tax
from `amazon (1)`
group by `Customer type`
order by Total_Tax desc

SELECT COUNT(DISTINCT `Customer type`) AS distinct_customer_types
FROM `amazon (1)`;

SELECT COUNT(DISTINCT `Payment`) AS distinct_payment_method
FROM `amazon (1)`;

SELECT `Customer type`, 
       COUNT(*) AS occurrence_count
FROM `amazon (1)`
GROUP BY `Customer type`
ORDER BY occurrence_count DESC
LIMIT 1;

SELECT `Customer type`, COUNT(*) AS purchase_frequency
FROM `amazon (1)`
WHERE `Total` > 0  
GROUP BY `Customer type`
ORDER BY purchase_frequency DESC
LIMIT 1;

select Gender, count(*) as Gender_Count
from `amazon (1)`
group by Gender
order by Gender_Count

SELECT Branch, 
       Gender, 
       COUNT(*) AS Gender_Count
FROM `amazon (1)`
GROUP BY Branch, Gender
ORDER BY Branch, Gender_Count DESC;

SELECT timeofday, 
       COUNT(*) AS Count_of_the_day, 
       SUM(Rating) AS Total_Rating
FROM `amazon (1)`
GROUP BY timeofday
ORDER BY Count_of_the_day DESC, Total_Rating DESC;

-- Determine the time of day with the highest customer ratings for each branch.

WITH branch_ratings AS (
    SELECT Branch, 
           timeofday, 
           SUM(Rating) AS Total_Rating
    FROM `amazon (1)`
    GROUP BY Branch, timeofday
)
SELECT Branch, 
       timeofday, 
       Total_Rating
FROM branch_ratings
WHERE (Branch, Total_Rating) IN (
    SELECT Branch, MAX(Total_Rating)
    FROM branch_ratings
    GROUP BY Branch
)
ORDER BY Branch, timeofday;


SELECT DAYNAME(date) AS Day_of_Week, 
       AVG(Rating) AS Average_Rating
FROM `amazon (1)`
GROUP BY Day_of_Week
ORDER BY Average_Rating DESC
LIMIT 1;


SELECT Branch, 
       DAYNAME(date) AS Day_of_Week, 
       AVG(Rating) AS Average_Rating
FROM `amazon (1)`
GROUP BY Branch, Day_of_Week
HAVING AVG(Rating) = (
    SELECT MAX(AVG_Rating)
    FROM (
        SELECT Branch, 
               DAYNAME(date) AS Day_of_Week, 
               AVG(Rating) AS AVG_Rating
        FROM `amazon (1)`
        GROUP BY Branch, Day_of_Week
    ) AS subquery
    WHERE subquery.Branch = `amazon (1)`.Branch
)
ORDER BY Branch;