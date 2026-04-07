-- Data Analysis Project on Blinkit Sales Database using SQL Queries.

-- Created Database & uploaded the data from .csv file in MySQL
CREATE DATABASE IF NOT EXISTS blinkit_db;

-- Selecting the desired database for further analysis
USE blinkit_db;

-- Checking the whole data
SELECT 
	* 
FROM 
	blinkit_data;

-- Data Cleaning

-- 1) Updating the column names
UPDATE 
	blinkit_data
SET 
	`Item Fat Content` = Item_fat_content,
	`Item Identifier` = Item_identifier,
	`Item Type` = Item_type,
	`Outlet Establishment Year` = Outlet_establishment_year,
	`Outlet Identifier` = Outlet_Identifier,
	`Outlet Location Type` = Outlet_location_type,
	`Outlet Size` = Outlet_size,
	`Outlet Type` = Outlet_size,
	`Item Visibility` = Item_visibility,
	`Item Weight` = Item_weight,
	`Sales` = Sales,
	`Rating` = Rating;

-- 2) Updating the incorrect values
UPDATE blinkit_data
SET Item_Fat_Content = 
    CASE 
        WHEN Item_fat_content IN ('LF', 'low fat') THEN 'Low Fat'
        WHEN Item_fat_content = 'reg' THEN 'Regular'
        ELSE Item_fat_content
    END;

-- No of products based on Item Fat Content (Cheking if updates have been made successfully or not)
SELECT 
	Item_fat_content, 
	COUNT(*) AS No_of_products
FROM 
	blinkit_data 
GROUP BY 
	Item_fat_content;


-- 1) KPI's 

-- Total Sales
SELECT 
	CONCAT(CAST(SUM(Sales) / 1000 AS DECIMAL(10,2)), ' Thousand') AS Total_Sales
FROM 
	blinkit_data;

-- Average Sales
SELECT 
	CONCAT(ROUND(AVG(Sales), 2), ' Thousand') AS Avg_Sales
FROM 
	blinkit_data;

-- No of Orders
SELECT 
	COUNT(*) AS No_of_Orders
FROM 
	blinkit_data;

-- Average Rating
SELECT 
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM 
	blinkit_data;


-- 2) Further Analysis

-- Total Sales by Item fat content
SELECT 
	Item_fat_content, 
    CONCAT(CAST(SUM(Sales) / 1000 AS DECIMAL(10, 2)), ' Thousand') AS total_sales
FROM 
	blinkit_data
GROUP BY 
	Item_fat_content;

-- Total Sales by Item type
SELECT
	Item_type,
    CONCAT(CAST(SUM(Sales) / 1000 AS DECIMAL(10, 2)), ' Thousand') AS total_sales
FROM 
	blinkit_data
GROUP BY 
	Item_type
ORDER BY 
	total_sales;

-- Total sales by Item fat content & Outlet location type
SELECT 
    Outlet_location_type,
    SUM(CASE WHEN Item_fat_content = 'Low Fat' THEN Total_sales ELSE 0 END) AS Low_Fat,
    SUM(CASE WHEN Item_fat_content = 'Regular' THEN Total_sales ELSE 0 END) AS Regular
FROM (
    SELECT 
        Outlet_location_type,
        Item_fat_content,
        CONCAT(CAST(SUM(Sales) / 1000 AS DECIMAL(10, 2)), ' Thousand') AS Total_sales
    FROM 
		blinkit_data
    GROUP BY 
		Outlet_location_type, Item_fat_content
) AS SourceTable
GROUP BY 
	Outlet_location_type
ORDER BY 
	Outlet_location_type;

-- Total sales by Outlet_establishment_year
SELECT 
	Outlet_establishment_year, 
	CONCAT(CAST(SUM(Sales) / 1000 AS DECIMAL(10,2)), " Thousand") AS Total_Sales
FROM 
	blinkit_data
GROUP BY 
	Outlet_establishment_year
ORDER BY 
	Outlet_establishment_year;

-- Percentage of Sales by Outlet Size
SELECT 
    Outlet_size, 
    CONCAT(CAST(SUM(Sales) / 1000 AS DECIMAL(10,2)), ' Thousand') AS Total_Sales,
    CONCAT(CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)), ' %') AS Sales_Percentage
FROM 
	blinkit_data
GROUP BY 
	Outlet_size
ORDER BY 
	Total_Sales DESC;

-- Sales by Outlet Location
SELECT 
	Outlet_location_type, CONCAT(CAST(SUM(Sales) / 1000 AS DECIMAL(10,2)), ' Thousand') AS Total_Sales
FROM 
	blinkit_data
GROUP BY 
	Outlet_location_type
ORDER BY 
	Total_Sales DESC;

-- All metrics by Outlet location type
SELECT 
	Outlet_type, 
	CONCAT(CAST(SUM(Sales) / 1000 AS DECIMAL(10,2)), ' Thousand') AS Total_Sales,
	CAST(AVG(Sales) AS DECIMAL(10,0)) AS Avg_Sales,
	COUNT(*) AS No_Of_Items,
	CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
	CAST(AVG(Item_visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM 
	blinkit_data
GROUP BY 
	Outlet_type
ORDER BY 
	Total_Sales DESC;