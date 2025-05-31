USE Walmart_Project;

-- create table
DROP TABLE IF EXISTS sales;
CREATE TABLE Sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
);

SELECT * FROM sales;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------- Feature Engineering ----------------------------------------------------------------------------------------------------
-- time_day --------------------------------------------------------------------
SELECT
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END    
	) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END  
);

-- day_name --------------------------------------------------------------
SELECT 
	date,
    DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(15);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name -----------------------------------------------------------
SELECT 
	date,
    MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);

UPDATE sales
SET month_name = MONTHNAME(date);
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- -------------------------------------------- Generic ---------------------------------------------------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT DISTINCT(city)
FROM Sales;

-- In which city is each branch?
SELECT DISTINCT branch
FROM sales;

SELECT DISTINCT city,branch
FROM sales;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------- Product --------------------------------------------------------------------------------------------------------------

-- How many unique product lines does the data have?
SELECT COUNT(DISTINCT(product_line))
FROM sales;

-- What is the most common payment method?
SELECT payment_method,COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC LIMIT 1;

-- what is the most selling product line?
SELECT product_line,COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC LIMIT 1;

-- what is total revenue by month?
SELECT month_name AS months,SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- what month had the largest COGS?
SELECT 
	month_name AS months,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- whatproduct line had the largest revenue?
SELECT 
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- city with largest revenue
SELECT
	city,
    sum(total) AS total_revenue
FROM sales
GROUP by city
ORDER BY total_revenue DESC;

-- which product line had the largest VAT?
SELECT
	product_line,
    AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line 
ORDER BY avg_tax DESC;

-- which branch sold more products than the average product sold?
SELECT
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (select AVG(quantity) FROM sales);

-- what is the most common product line by gender?
SELECT 
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- average rating of each product line?
SELECT
	product_line,
    AVG(rating) AS AVG_rating
FROM sales
GROUP BY product_line
ORDER BY AVG_rating DESC;