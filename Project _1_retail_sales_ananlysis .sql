CREATE DATABASE retail_sales_project_01;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
   (
      transactions_id INT PRIMARY KEY,	
      sale_date DATE,
      sale_time	TIME,
      customer_id INT,
      gender VARCHAR(15),
      age INT,
      category VARCHAR(15),	
      quantiy INT,
      price_per_unit FLOAT,	
      cogs FLOAT,
      total_sale FLOAT
   );

---
   SELECT*FROM
   retail_sales;

   ---
     SELECT*FROM
	 retail_sales
	 LIMIT 10;

---COUNT ROWS--
  SELECT
  COUNT(*)FROM
	 retail_sales;

----DATA CLEANING---

---CHECKING NULL VALUES ALL COLUMN---WAY -01 STEP BY STEP COLUMN WISE--

SELECT*FROM retail_sales 
WHERE transactions_id IS NULL;

SELECT*FROM retail_sales 
WHERE sale_date IS NULL;

SELECT*FROM retail_sales 
WHERE age IS NULL;

--CHECKING NULL VALUES in whole Table using OR Function --

SELECT*FROM retail_sales 
  WHERE 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

	 --DELETING NULL ROWS--
	 
	 DELETE FROM retail_sales 
  WHERE 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 customer_id IS NULL
	 OR
	 gender IS NULL
	 OR
	 age IS NULL
	 OR
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 price_per_unit IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

-----DATA EXPLORATION -----

--01.How many sales/transaction we have?--
SELECT
      COUNT(*) AS total_sale 
      FROM retail_sales;

--02.How many unique customers we have?--
SELECT
      COUNT(DISTINCT customer_id) AS total_customer
      FROM retail_sales;

--03.How many( in Number) category we have?--
SELECT
      COUNT(DISTINCT category) AS total_category
      FROM retail_sales;
	  
--How many( in Name) category we have?--	  
SELECT
      DISTINCT category AS total_category
      FROM retail_sales;

-----DATA ANALYSIS & BUSINESS KEY PROBLEMS------

--Q-1: Write a SQL query to retrieve all columns for sales made on '2022-11-05'--
SELECT*FROM retail_sales
   WHERE 
         sale_date = '2022-11-05';

--Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--WAY-01
SELECT
*FROM 
retail_sales
        WHERE 
              category = 'Clothing'
        AND 
		       sale_date>='2022-11-01'
        AND 
		       sale_date<='2022-11-30'
        AND 
		       quantiy >= 4;
			   
----WAY-02--
SELECT
*FROM 
retail_sales
        WHERE 
              category = 'Clothing'
			  AND
			  TO_CHAR (sale_date, 'YYYY-MM') ='2022-11'
			  AND
			      quantiy >= 4;

--Q3.Write a SQL query to calculate the total sales (total_sale) for each category.

 SELECT 
  category, 
  SUM(total_sale) AS net_sale,
  COUNT(*) AS total_order
  FROM retail_sales
  GROUP BY category;

  --N.B-COUNT(*) AS total_order: This counts the number of rows (or orders) for each category. It uses COUNT(*) to count all rows in each group and is labeled total_order.

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
    ROUND(AVG(age),2)  AS average_age
FROM retail_sales
WHERE category = 'Beauty';

--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT*
FROM retail_sales
WHERE total_sale>1000;

--Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
	  category,
	  gender,
      COUNT(transactions_id) AS total_number_of_transaction
	  FROM retail_sales
	  GROUP BY 	gender,category
ORDER BY 
       category;

--Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.

SELECT
      year,
	  month,
	  avg_sale
FROM
 (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
	    AVG(total_sale) AS avg_sale,
        RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)  ORDER BY AVG(total_sale) DESC ) AS rank  --In window functuin do not use alias--
   FROM retail_sales   
   GROUP BY 1,2 
) AS ranked_sales
   WHERE rank=1 ;
   
--Q8. Write a SQL query to find the top 10 customers based on the highest total sales.
SELECT
   customer_id,
   SUM(total_sale) AS total_sale
FROM retail_sales
     GROUP BY customer_id
     ORDER BY total_sale DESC 
LIMIT 10;

--Q.9.Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
   category,
   COUNT(DISTINCT customer_id ) AS unique_customers
FROM retail_sales
	GROUP BY 1;	
		
--Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale     -- Using CTE --temporary new dataset/ table -name hourly_sale --
AS (

SELECT*,       -- (*,)This retrieves all columns from the table,a comma(,) is used to separate columns
  CASE 
      WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
	  WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	  ELSE 'Evening' 
	  END  AS shift   --This adds an additional column called 'shift' 
  FROM retail_sales
)

SELECT
    shift,
	COUNT(transactions_id) AS total_number_of_orders
	FROM hourly_sale
	GROUP BY shift;
	
	
