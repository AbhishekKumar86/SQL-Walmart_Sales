use walmart;
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
select * from sales;
describe sales;
-- Feeaturing Enginnerring--

select time, case when time between "00:00:00" and "12:00:00" then "Morning" 
				when time between "12:01:00" and "16:00:00" then "Afternoon"
                else "Evening" end as time_of_day from sales;
                
alter table sales add column time_of_day varchar(255);
update sales
set time_of_day = (case when time between "00:00:00" and "12:00:00" then "Morning" 
				when time between "12:01:00" and "16:00:00" then "Afternoon"
                else "Evening" end);
select *, dayname(date) from sales;

alter table sales
add column day_name varchar(255);

update sales
set day_name = dayname(date);

select *, monthname(date) from sales;
alter table sales
add column month_name varchar(255);
update sales
set month_name = monthname(date);

--  How many unique cities does the data have?

select distinct(city) from sales;

-- In which city is each branch?

select distinct(branch) from sales
;

-- How many unique product lines does the data have?

select count(distinct(product_line)) as "Unique_Product_Line" from sales;

-- How many unique customer types does the data have?

select distinct(customer_type) from sales;

-- How many unique payment methods does the data have?

select distinct(payment) from sales;

-- What is the most selling product line?

select product_line, count(total) as "most _sel-pdt_li" from sales
group by product_line
order by count(total) desc limit 1;

-- What is the average rating of each product line?

select product_line, round(avg(rating),2) as "avg_prd_li" from sales
group by product_line order by round(avg(rating),2) desc;

-- what is the total revenue by month?

select month_name as month, round(sum(total),2) as "total_revenue" from sales
group by month_name order by month_name;

 -- what month had the largest cogs?
 select month_name as month, round(sum(cogs),2) as lar_cog from sales
 group by month_name order by round(sum(cogs),2) desc limit 1;
 
 --  What product line had the largest revenue?
 
 select product_line, round(sum(total),2) as "tot_rev" from sales
 group by product_line order by round(sum(total),2) desc;
 
 -- What is the city with the largest revenue?
  select city, round(sum(total),2) as "tot_rev" from sales
 group by city order by round(sum(total),2) desc;
 
 -- What product line had the largest VAT?
  select product_line, round(avg(tax_pct),2) as avg_tax from sales
 group by product_line order by round(avg(tax_pct),2) desc limit 1;
 
-- What is the average rating of each product line?
 select product_line, avg(rating) as "avg_rating" from sales
 group by product_line order by avg_rating desc;
 
 -- Number of sales made in each time of the day per weekday

select time_of_day, product_line, count(*) as "tot_qty" from sales
where day_name = "Monday"
group by time_of_day, product_line;

-- Which of the customer types brings the most revenue?
select customer_type, round(sum(total),2) as "tot_rev"  from sales
group by customer_type order by tot_rev desc;
-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city, avg(tax_pct) as "VAT" from sales
group by city order by VAT desc limit 1;

-- What is the gender distribution per branch?

select gender, count(*) as "gn_cnt" from sales 
where branch = "A"
group by gender;

-- Which time of the day do customers give most ratings?

select time_of_day, avg(rating) as "avg_rating", count(*)  as "avg_count"
from sales
group by time_of_day
order by avg_rating, avg_count;

-- Which day of the week has the best avg ratings?
select day_name, avg(rating) as "avg_rating"
from sales
group by day_name
order by avg_rating desc;

-- Which day of the week has the best average ratings per branch?
select day_name, avg(rating) as "avg_rating"
from sales
where branch = "a"
group by day_name
order by avg_rating desc;

-- Which branch had the highest total sales for each product line?
select branch, product_line, sum(total) as "tot_rev" from sales
group by branch, product_line;

-- Find the Total Number of Transactions and the Average Rating for Transactions Above $500
select count(*), avg(rating) as avg_rating from sales
where total > 500;

-- Calculate the Gross Margin Percentage for Each City and Product Line Combination:

select city, product_line, round(avg(gross_margin_pct),2) as  Average_Gross_Margin_Percentage from sales
group by city,  product_line;

-- Identify the Top 3 Best-Selling Product Lines in Each Branch::
with t1 as (
select product_line, branch,  sum(quantity) as  "total_quantity", 
dense_rank() over(partition by branch order by sum(quantity) desc) as rnk  from sales s
group by product_line, branch)
select t1.product_line, t1.branch, t1.total_quantity from t1
where t1.rnk <=3
order by t1.branch, t1.total_quantity desc ;

-- Calculate the Average Rating by Customer Type and Payment Method:

select customer_type, payment, avg(rating) as "avg_ratig"  from sales
group by customer_type,  payment
order by customer_type,  payment desc;

-- Identify the Most Popular Time of Day for Sales in Each Branch

select hour(time) as hour, branch, count(*) as sales_count  from sales
group by hour, branch
order by
    branch, sales_count desc;



