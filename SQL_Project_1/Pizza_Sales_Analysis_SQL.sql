-- Data Analysis Project on Pizza Sales Database using SQL Queries.

---- Deterining the KPI's:

-- Checking whether all the data is imported correctly or not.
SELECT * FROM pizza_sales_csv;

-- Q. What is total revenue of all the pizza sales?

SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales_csv;

-- Q. What is the average order value?

SELECT SUM(total_price) / COUNT(DISTINCT(order_id)) AS Avg_Order_Value FROM pizza_sales_csv;

-- Q. What is the Total number of Pizzas sold?

SELECT SUM(quantity) AS Total_pizza_sold FROM pizza_sales_csv;

-- Q. What are the Total number of orders placed?

SELECT COUNT( DISTINCT(order_id)) AS Total_pizza_sold FROM pizza_sales_csv;

-- Q. What is the average pizzas sold per Order?

SELECT CAST (SUM(quantity) AS DECIMAL (10,2)) / CAST (COUNT(DISTINCT(order_id)) AS DECIMAL (10,2)) AS Avg_pizza_sold FROM pizza_sales_csv;


-- Q. What is the daily trend for all the orders?

SELECT DATENAME(DW, order_date) AS Order_day, COUNT(DISTINCT (order_id)) AS Total_orders
FROM pizza_sales_csv
GROUP BY DATENAME(DW, order_date);

-- Monthly Trend for Total Orders.

SELECT DATENAME(MONTH, order_date) AS Order_month, COUNT(DISTINCT (order_id)) AS Total_orders
FROM pizza_sales_csv
GROUP BY DATENAME(MONTH, order_date)
ORDER BY COUNT(DISTINCT (order_id)) DESC;

-- Q. What is the percentage of Sales for each Pizza category?

SELECT pizza_category, SUM(total_price) AS Total_sales, SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales_csv) AS Total_sales_percnt
FROM pizza_sales_csv
GROUP BY pizza_category;

-- Q. What is the percentange of Sales for each category for a specific month like we say January?

SELECT pizza_category, SUM(total_price) AS Total_sales, CAST(SUM(total_price) * 100 / 
(SELECT SUM(total_price) FROM pizza_sales_csv WHERE MONTH(order_date) = 1) AS DECIMAL (10,2))
AS Total_sales_percnt
FROM pizza_sales_csv
WHERE MONTH(order_date) = 1
GROUP BY pizza_category;

-- Q. What is the percentange of Sales for each Pizza Size?

SELECT pizza_size, SUM(total_price) AS Total_sales, CAST(SUM(total_price) * 100 / 
(SELECT SUM(total_price) FROM pizza_sales_csv) AS DECIMAL (10,2))
AS Total_sales_percnt
FROM pizza_sales_csv
GROUP BY pizza_size
ORDER BY SUM(total_price) DESC;


-- What is the percentage of sales for each pizza category for a quarter?

SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_sales, CAST(SUM(total_price) * 100 / 
(SELECT SUM(total_price) FROM pizza_sales_csv WHERE DATEPART(quarter, order_date) = 1) AS DECIMAL (10,2))
AS Total_sales_percnt
FROM pizza_sales_csv
WHERE DATEPART(quarter, order_date) = 1
GROUP BY pizza_size
ORDER BY SUM(total_price) DESC;

-- Q. What are the Top 5 best selling pizzas by Total Price?

SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue 
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY SUM(total_price) DESC;

-- Q. What are the Least 5 selling pizzas by Total Price?

SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue 
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY SUM(total_price);

-- Q. What are the 5 Best Selling Pizzas by Total quantity?

SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity 
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY SUM(quantity) DESC;

-- Q. What are the 5 least Selling Pizzas by Total quantity?

SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity 
FROM pizza_sales_csv
GROUP BY pizza_name
ORDER BY SUM(quantity) ASC;

--- Project Completed----