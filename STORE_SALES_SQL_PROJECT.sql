create database sql_project;
use sql_project;
create table sales as select * from sales_store;
CREATE TABLE sales_store (
transaction_id VARCHAR(15),
customer_id VARCHAR(15),
customer_name VARCHAR(30),
customer_age INT,
gender VARCHAR(15),
product_id VARCHAR(15),
product_name VARCHAR(15),
product_category VARCHAR(15),
quantiy INT,
prce FLOAT,
payment_mode VARCHAR(15),
purchase_date DATE,
time_of_purchase TIME,
status VARCHAR(15)
);

-- Data Cleaning
-- Step 1
--  Find duplicates
SELECT transaction_id, COUNT(*) AS duplicate_count
FROM sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;

-- Use CTE with ROW_NUMBER
WITH CTE AS (
    SELECT s.*, 
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS Row_Num
    FROM sales s
)
SELECT *
FROM CTE
WHERE transaction_id IN ('TXN240646','TXN342128','TXN855235','TXN981773');

--  Delete duplicates (keep first occurrence)
WITH CTE AS (
    SELECT s.*, 
           ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS Row_Num
    FROM sales s
)
DELETE FROM sales
WHERE transaction_id IN (
    SELECT transaction_id 
    FROM CTE 
    WHERE Row_Num > 1
);


-- step 2 Rename column
ALTER TABLE sales CHANGE quantiy Quantity INT;
ALTER TABLE sales CHANGE prce Price DECIMAL(10,2);

-- step 3  check Data type
DESCRIBE sales;

-- checks null coount
SELECT 
    SUM(transaction_id IS NULL) AS transaction_id_nulls,
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(customer_name IS NULL) AS customer_name_nulls,
    SUM(customer_age IS NULL) AS customer_age_nulls,
    SUM(gender IS NULL) AS gender_nulls,
    SUM(product_id IS NULL) AS product_id_nulls,
    SUM(product_name IS NULL) AS product_name_nulls,
    SUM(product_category IS NULL) AS product_category_nulls,
    SUM(quantity IS NULL) AS quantity_nulls,
    SUM(payment_mode IS NULL) AS payment_mode_nulls,
    SUM(purchase_date IS NULL) AS purchase_date_nulls,
    SUM(status IS NULL) AS status_nulls,
    SUM(price IS NULL) AS price_nulls
FROM sales;

-- Find all rows having NULL values
SELECT *
FROM sales
WHERE 
    transaction_id IS NULL OR
    customer_id IS NULL OR
    customer_name IS NULL OR
    customer_age IS NULL OR
    gender IS NULL OR
    product_id IS NULL OR
    product_name IS NULL OR
    product_category IS NULL OR
    quantity IS NULL OR
    payment_mode IS NULL OR
    purchase_date IS NULL OR
    status IS NULL OR
    price IS NULL;
-- Update Wrong Records
-- 1) Update Customer of Ehsaan Ram
UPDATE sales
SET customer_id = 'CUST9494'
WHERE transaction_id = 'TXN977900';

-- 2) Update Customer of Damini Raju
UPDATE sales
SET customer_id = 'CUST1401'
WHERE transaction_id = 'TXN985663';

-- 3) Update Customer details for ID CUST1003
UPDATE sales
SET customer_name = 'Mahika Saini',
    customer_age = 35,
    gender = 'Male'
WHERE transaction_id = 'TXN432798';

--
SELECT DISTINCT gender FROM sales;
-- standardizing
UPDATE sales SET gender = 'M' WHERE gender = 'Male';
UPDATE sales SET gender = 'F' WHERE gender = 'Female';

SELECT DISTINCT payment_mode FROM sales;
UPDATE sales 
SET payment_mode = 'Credit Card'
WHERE payment_mode = 'CC';




-----------------------------------------------------------------------------------------------------------
-- Data Analysis

-- 1. What are the top 5 most selling products by quantity?

SELECT * FROM sales;
SELECT DISTINCT status
from sales;

SELECT product_name, SUM(quantity) AS total_quantity_sold
FROM sales
WHERE status='delivered'
GROUP BY product_name
ORDER BY total_quantity_sold DESC
limit 5;

-- Business Problem: We don't know which products are most in demand.

-- Business Impact: Helps prioritize stock and boost sales through targeted promotions.

-- ---------------------------------------------------------------------------------------------------------

-- 2. Which products are most frequently cancelled?

SELECT product_name, COUNT(*) AS total_cancelled
FROM sales
WHERE status='cancelled'
GROUP BY product_name
ORDER BY total_cancelled DESC
limit 10;

-- Business Problem: Frequent cancellations affect revenue and customer trust.

-- Business Impact: Identify poor-performing products to improve quality or remove from catalog.

-- ---------------------------------------------------------------------------------------------------------
-- 3. What time of the day has the highest number of purchases?

select * from sales;
SELECT 
    CASE 
        WHEN HOUR(time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
        WHEN HOUR(time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
        WHEN HOUR(time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        WHEN HOUR(time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
    END AS time_of_day,
    COUNT(*) AS total_orders
FROM sales
GROUP BY 
    CASE 
        WHEN HOUR(time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
        WHEN HOUR(time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
        WHEN HOUR(time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        WHEN HOUR(time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
    END
ORDER BY total_orders DESC;

-- -------------------------------------------------------------------------------------------
SELECT 
	HOUR(time_of_purchase) AS Peak_time,
	COUNT(*) AS Total_orders
FROM sales
GROUP BY HOUR(time_of_purchase)
ORDER BY  Total_orders desc;

-- Business Problem Solved: Find peak sales times.

-- Business Impact: Optimize staffing, promotions, and server loads.
-- - --------------------------------------------------------------------------------------------------------

-- 4. Who are the top 5 highest spending customers?

SELECT * FROM sales;

SELECT customer_name,
	concat('Rs.',format(SUM(price*quantity),0))AS total_spend
FROM sales 
GROUP BY customer_name
ORDER BY SUM(price*quantity) DESC
limit 5;

-- Business Problem Solved: Identify VIP customers.

-- Business Impact: Personalized offers, loyalty rewards, and retention.

-----------------------------------------------------------------------------------------------------------

-- 5. Which product categories generate the highest revenue?

SELECT * FROM sales;

SELECT 
	product_category,
	FORMAT(SUM(price*quantity),0) AS Revenue
FROM sales 
GROUP BY product_category
ORDER BY SUM(price*quantity) DESC;

-- Business Problem Solved: Identify top-performing product categories.

-- Business Impact: Refine product strategy, supply chain, and promotions.
-- allowing the business to invest more in high-margin or high-demand categories.

--        ---------------------------------------------------------------------------------------------------------

-- 6. What is the return/cancellation rate per product category?

SELECT * FROM sales;
-- cancellation
SELECT product_category,
    CONCAT(FORMAT(COUNT(CASE WHEN status = 'cancelled' THEN 1 END) * 100.0 / COUNT(*), 2),' %') AS cancelled_percent
FROM sales
GROUP BY product_category
ORDER BY 
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) * 100.0 / COUNT(*) DESC;

-- Return returned
SELECT product_category,
    CONCAT(FORMAT(COUNT(CASE WHEN status = 'returned' THEN 1 END) * 100.0 / COUNT(*), 2),' %') AS returned_percent
FROM sales
GROUP BY product_category
ORDER BY 
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) * 100.0 / COUNT(*) DESC;


-- Business Problem Solved: Monitor dissatisfaction trends per category.
-- Business Impact: Reduce returns, improve product descriptions/expectations.
-- Helps identify and fix product or logistics issues.

-- ---------------------------------------------------------------------------------------------------------
-- 7. What is the most preferred payment mode?

SELECT * FROM sales;

SELECT payment_mode, COUNT(payment_mode) AS total_count
FROM sales 
GROUP BY payment_mode
ORDER BY total_count desc;


-- Business Problem Solved: Know which payment options customers prefer.

-- Business Impact: Streamline payment processing, prioritize popular modes.

-- ---------------------------------------------------------------------------------------------------------

-- 8. How does age group affect purchasing behavior?

SELECT * FROM sales;
SELECT MIN(customer_age) ,MAX(customer_age)
from sales;

SELECT 
	CASE	
		WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
		ELSE '51+'
	END AS customer_age,
	FORMAT(SUM(price*quantity),0) AS total_purchase
FROM sales 
GROUP BY CASE	
		WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
		ELSE '51+'
	END
ORDER BY SUM(price*quantity) DESC;

-- Business Problem Solved: Understand customer demographics.

-- Business Impact: Targeted marketing and product recommendations by age group.

-----------------------------------------------------------------------------------------------------------
-- 9. What’s the monthly sales trend?

SELECT * FROM sales;
-- Method 1

SELECT 
	date_format(purchase_date,'%Y-%M') AS Month_Year,
	SUM(price*quantity) AS total_sales,
	SUM(quantity) AS total_quantity
FROM sales 
GROUP BY date_format(purchase_date,'%Y-%M');
-- Method 2
SELECT * FROM sales ;
	
	SELECT 
		-- YEAR(purchase_date) AS Years,
    date_format(purchase_date,'%M') AS Months,
		SUM(price*quantity)AS total_sales,
		SUM(quantity) AS total_quantity
FROM sales
GROUP BY date_format(purchase_date,'%M')
ORDER BY Months;



-- Business Problem: Sales fluctuations go unnoticed.


-- Business Impact: Plan inventory and marketing according to seasonal trends.
