-- 							Business Questions To Answer
-- Generic Question

-- 1. How many unique cities does the data have?
-- 2. In which city is each branch?

-- Product
-- 1. How many unique product lines does the data have?
-- 2. What is the most common payment method?
-- 3. What is the most selling product line?
-- 4. What is the total revenue by month?
-- 5. What month had the largest COGS?
-- 6. What product line had the largest revenue?
-- 7. What is the city with the largest revenue?
-- 8. What product line had the largest VAT?
-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
-- 10. Which branch sold more products than average product sold?
-- 11. What is the most common product line by gender?
-- 12. What is the average rating of each product line?


-- Sales
-- 1. Number of sales made in each time of the day per weekday
-- 2. Which of the customer types brings the most revenue?
-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
-- 4. Which customer type pays the most in VAT?


-- Customer
-- 1. How many unique customer types does the data have?
-- 2. How many unique payment methods does the data have?
-- 3. What is the most common customer type?
-- 4. Which customer type buys the most?
-- 5. What is the gender of most of the customers?
-- 6. What is the gender distribution per branch?
-- 7. Which time of the day do customers give most ratings?
-- 8. Which time of the day do customers give most ratings per branch?
-- 9. Which day fo the week has the best avg ratings?
-- 10. Which day of the week has the best average ratings per branch?


-- --------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE sales (
    invoice_id VARCHAR2(30) PRIMARY KEY,
    branch VARCHAR2(5) NOT NULL,
    city VARCHAR2(30) NOT NULL,
    customer_type VARCHAR2(30) NOT NULL,
    gender VARCHAR2(30) NOT NULL,
    product_line VARCHAR2(100) NOT NULL,
    unit_price NUMBER(10,2) NOT NULL,
    quantity NUMBER NOT NULL,
    VAT NUMBER(10,4) NOT NULL,
    total NUMBER(12, 4) NOT NULL,
    sale_date DATE NOT NULL,
    sale_time INTERVAL DAY TO SECOND NOT NULL,
    payment_method VARCHAR2(15) NOT NULL,
    cogs NUMBER(10,2) NOT NULL,
    gross_margin_pct NUMBER(11,9),
    gross_income NUMBER(12, 4) NOT NULL,
    rating NUMBER(3,1)
);

ALTER TABLE sales MODIFY (sale_time VARCHAR2(8), sale_date VARCHAR2(10));

-- FEATURE ENGINEERING 

-- 1. time_of_day - ADD NEW COLUMN IN THE TABLE

SELECT sale_time, 
    CASE 
        WHEN TO_DATE(sale_time, 'HH24:MI:SS') BETWEEN TO_DATE('00:00:00', 'HH24:MI:SS') AND TO_DATE('12:00:00', 'HH24:MI:SS') THEN 'Morning'
        WHEN TO_DATE(sale_time, 'HH24:MI:SS') BETWEEN TO_DATE('12:01:00', 'HH24:MI:SS') AND TO_DATE('16:00:00', 'HH24:MI:SS') THEN 'Afternoon'
        ELSE 'Evening' 
    END AS time_of_day
FROM sales;

ALTER TABLE sales 
ADD time_of_day VARCHAR2(20);

UPDATE sales 
SET time_of_day = (
    CASE 
        WHEN sale_time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN sale_time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening' 
    END
);

-- 2. day_name 

SELECT TO_DATE(sale_date, 'YYYY-MM-DD') AS sale_date, 
       TO_CHAR(TO_DATE(sale_date, 'YYYY-MM-DD'), 'Day') AS day_name
FROM sales;

ALTER TABLE sales
ADD day_name VARCHAR(10);

UPDATE sales
SET day_name = TO_CHAR(TO_DATE(sale_date, 'YYYY-MM-DD'), 'Day');

-- 3. month_name

ALTER TABLE sales
ADD month_name VARCHAR2(20);

UPDATE sales
SET month_name = TO_CHAR(TO_DATE(sale_date, 'YYYY-MM-DD'), 'Month');

SELECT sale_date, month_name
FROM sales;

-- -----------------------------------------------------------------------------------------------

SELECT * FROM sales;

-- Generic Question

-- 1. How many unique cities does the data have?

SELECT  DISTINCT city 
FROM sales;

-- 2. In which city is each branch?

SELECT DISTINCT city, branch
FROM sales; 

-- -------------------------------------------------------------------------------------

-- Product

-- 1. How many unique product lines does the data have?

SELECT COUNT(DISTINCT product_line) AS unique_product_lines
FROM sales;

-- 2. What is the most common payment method?

SELECT payment_method, COUNT(*) AS count
FROM sales
GROUP BY payment_method
ORDER BY count DESC
FETCH FIRST 1 ROWS ONLY;

-- 3. What is the most selling product line?

SELECT product_line,SUM(quantity) AS total_sales
FROM sales
GROUP BY product_line
ORDER BY total_sales DESC
FETCH FIRST 1 ROWS ONLY;

-- 4. What is the total revenue by month?

SELECT TO_CHAR(TO_DATE(sale_date, 'YYYY-MM-DD'),'YYYY-MM') AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY TO_CHAR(TO_DATE(sale_date, 'YYYY-MM-DD'),'YYYY-MM')
ORDER BY month;

-- 5. What month had the largest COGS?

SELECT TO_CHAR(TO_DATE(sale_date, 'YYYY-MM-DD'),'YYYY-MM') AS month, SUM(cogs) AS total_cogs
FROM sales
GROUP BY TO_CHAR(TO_DATE(sale_date, 'YYYY-MM-DD'),'YYYY-MM')
ORDER BY total_cogs DESC
FETCH FIRST 1 ROWS ONLY;

-- 6. What product line had the largest revenue?

SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC
FETCH FIRST 1 ROWS ONLY;

-- 7. What is the city with the largest revenue?

SELECT city, SUM(total) as total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC
FETCH FIRST 1 ROWS Only;

-- 8. What product line had the largest VAT?

SELECT product_line, SUM(vat) AS total_vat
FROM sales
GROUP BY product_line
ORDER BY total_vat DESC
FETCH FIRST 1 ROWS ONLY;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

WITH avg_sales AS (
    SELECT AVG(total) AS avg_sales
    FROM sales
)
SELECT product_line,
       CASE
           WHEN SUM(total) > (SELECT avg_sales FROM avg_sales) THEN 'Good'
           ELSE 'Bad'
       END AS sales_status
FROM sales
GROUP BY product_line;

-- 10. Which branch sold more products than average product sold?

WITH avg_sales AS (
    SELECT AVG(quantity) AS avg_sales
    FROM sales
)
SELECT branch, SUM(quantity) AS total_sales
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT avg_sales FROM avg_sales);

-- 11. What is the most common product line by gender?

SELECT gender, product_line, COUNT(*) AS sales_count
FROM sales
GROUP BY gender,product_line
ORDER BY sales_count DESC;

-- 12. What is the average rating of each product line?

SELECT product_line, AVG(rating) AS avg_rating
FROM sales
GROUP BY product_line;

-- -------------------------------------------------------------------------------------

-- Sales
-- 1. Number of sales made in each time of the day per weekday

SELECT day_name, time_of_day, COUNT(*) AS number_of_sales
FROM sales
GROUP BY day_name, time_of_day
ORDER BY day_name, time_of_day;

-- 2. Which of the customer types brings the most revenue?

SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC
FETCH FIRST 1 ROWS ONLY;

-- 3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?

SELECT city, SUM(vat) AS total_vat
FROM sales
GROUP BY city
ORDER BY total_vat DESC
FETCH FIRST 1 ROWS ONLY;

-- 4. Which customer type pays the most in VAT?

SELECT customer_type, SUM(vat) AS total_vat_paid
FROM sales
GROUP BY customer_type
ORDER BY total_vat_paid DESC
FETCH FIRST 1 ROWS ONLY;

-- -------------------------------------------------------------------------------------

-- Customer
-- 1. How many unique customer types does the data have?

SELECT COUNT(DISTINCT customer_type) AS unique_customer_types
FROM sales;

-- 2. How many unique payment methods does the data have?

SELECT COUNT(DISTINCT payment_method) AS unique_payment_methods
FROM sales;

-- 3. What is the most common customer type?

SELECT customer_type, COUNT(*) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC
FETCH FIRST 1 ROWS ONLY;

-- 4. Which customer type buys the most?

SELECT customer_type, SUM(quantity) AS total_quantity
FROM sales
GROUP BY customer_type
ORDER BY total_quantity DESC
FETCH FIRST 1 ROWS ONLY;

-- 5. What is the gender of most of the customers?

SELECT gender, COUNT(*) AS count
FROM sales
GROUP BY gender
ORDER BY count DESC
FETCH FIRST 1 ROWS ONLY;

-- 6. What is the gender distribution per branch?

SELECT branch, gender, COUNT(*) AS count
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender;

-- 7. Which time of the day do customers give most ratings?

SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC
FETCH FIRST 1 ROWS ONLY;

-- 8. Which time of the day do customers give most ratings per branch?

SELECT branch, time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY branch, time_of_day
ORDER BY avg_rating DESC;

-- 9. Which day fo the week has the best avg ratings?

SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC
FETCH FIRST 1 ROWS ONLY;

-- 10. Which day of the week has the best average ratings per branch

SELECT branch, day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY branch, day_name
ORDER BY avg_rating DESC;
