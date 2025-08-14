- SQL Project Retail Sales Analysis - P1

-- Create Table
Create Table retail_sales
			(
				transactions_id	INT Primary Key,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	INT,
				category VARCHAR(15),
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs	FLOAT,
				total_sale FLOAT
			);

-- Check First 10 rows of the Data
SELECT * FROM retail_sales
LIMIT 10;

--Check Count of Totall Rows
SELECT 
	COUNT(*)
FROM retail_sales;

--Check Null Value in Transaction ID column
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

--Check All the rows if null values are there
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or
	gender IS NULL
	or
	age IS NULL
	or
	category IS NULL
	or
	quantiy IS NULL
	or
	price_per_unit IS NULL
	or
	cogs IS NULL
	or
	total_sale IS NULL;

-- Delete NULL row
Delete FROM retail_sales
WHERE
	transactions_id IS NULL
	or
	sale_date IS NULL
	or
	sale_time IS NULL
	or
	customer_id IS NULL
	or
	gender IS NULL
	or
	age IS NULL
	or
	category IS NULL
	or
	quantiy IS NULL
	or
	price_per_unit IS NULL
	or
	cogs IS NULL
	or
	total_sale IS NULL;

-- Data Exploration 

--Total Sales
SELECT 
	COUNT(*) as Total_Number_Sales
FROM retail_sales;

--Total Customers
SELECT 
	COUNT(Distinct customer_id) as Customer_count
FROM retail_sales;

--Unique Category
SELECT 
	Distinct category
FROM retail_sales;

-- Data Analysis and Business Key Problems and Answer
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all colomns for sales made on '2022-11-05'
SELECT *
From retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov 2022
Select 
	*
From retail_sales
Where Category = 'Clothing'
	AND
	To_char(sale_date,'YYYY-MM') = '2022-11'
	AND
	Quantiy >= 4;

--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category
Select 
	sum(total_sale) as Total_Sale
From retail_sales;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT avg(age)
From retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * From retail_sales
Where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, count(transactions_id) as Transaction_count
From retail_sales
Group by gender, category
Order By 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	extract(Year from sale_date) as Year,
	extract(month from sale_date) as Month,
	AVG(total_sale) as Avg_sale,
	RANK() Over(Partition by extract(Year from sale_date) Order by avg(total_sale) Desc) as Rank
From retail_sales
Group by 1, 2;

-- Subquery for Best selling month
Select year, month, Avg_sale from
	(
	 SELECT 
		extract(Year from sale_date) as Year,
		extract(month from sale_date) as Month,
		AVG(total_sale) as Avg_sale,
		RANK() Over(Partition by extract(Year from sale_date) Order by avg(total_sale) Desc) as Rank
	 From retail_sales
	 Group by 1, 2
	 ) as T1
Where Rank = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
Select 
	customer_id,
	sum(total_sale) as total_sales
from retail_sales
Group by 1
order by 2
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
Select 
	category,
	count (distinct customer_id) as unique_customers
from retail_sales
Group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
Select *,
	 case 
	 when extract(Hour from sale_time) <= 12 then 'Morning'
	 when extract(Hour from sale_time) between 12 and 17 then 'Afternoon'
	 else 'Evening'
	 End as Shift
From retail_sales;

Answer 10:
With hourly_sale
as
	(
		Select *,
		 case 
		 when extract(Hour from sale_time) <= 12 then 'Morning'
		 when extract(Hour from sale_time) between 12 and 17 then 'Afternoon'
		 else 'Evening'
		 End as Shift
	From retail_sales
	)
Select shift, count(total_sale) as Count_order
From hourly_sale
Group By Shift 
Order By 2 desc;