create table if not exists walmart_sales(
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
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
select dense_rank() over( order by round(sum(total)) desc),product_line,round(sum(total)) from walmart_sales group by product_line;

--------------- Feature engineering ------------------
select time,
case
when `time` between "00:00:00" and "12:00:00" then 'Morning'
when `time` between "12:01:00" and "18:00:00" then 'Evening'
else 'Night'
end as time_of_date from walmart_sales;

alter table walmart_sales add column time_of_date varchar(20);
update walmart_sales set time_of_date=
(case 
when `time` between "00:00:00" and "12:00:00" then 'Morning'
when `time` between "12:01:00" and "18:00:00" then 'Evening'
else 'Night'
end);
--------- dayname -----------
select * from walmart_sales;
alter table walmart_sales add column day_name varchar(20);
update walmart_sales set day_name=dayname(date);
select * from walmart_sales;

------------------------ Month Name ----------
alter table walmart_sales add column month_name varchar(20);
update walmart_sales set month_name=monthname(date);
select * from walmart_sales;
------------------------ Exploratory Data analysis -----------------------------
-- 1) no of distinct city

select count(distinct(city)) as distinct_city from walmart_sales;

select * from walmart_sales;
-- 2) showing count of different branches under 3 cities. 
select branch,count(branch), city from walmart_sales group by city;
----------------- Sales evaluation ---------------
-- 1)Number of sales made in each time of the day per weekday

select * from walmart_sales;
select count(invoice_id), time_of_date, day_name from walmart_sales group by time_of_date,day_name order by count(invoice_id) desc limit 10;

-- 2) Which of the customer types brings the most revenue?

select round(sum(total)) as total_sum, customer_type from walmart_sales group by customer_type order by round(sum(total)) desc;

--- displaying cogs and VAT according to city which has the largest tax percent/ VAT (Value Added Tax)
select city, unit_price*quantity as cogs,cogs*0.05 as VAT from walmart_sales group by city order by VAT desc;

--------- 3) which month had the largest cogs? ---------------------
select month_name, sum(cogs) from walmart_sales group by month_name order by sum(cogs) desc;

----------- 4) which product line had the largest revenue ? ---------------
select * from walmart_sales;
select product_line, round(sum(total)) from walmart_sales group by product_line order by round(sum(total)) desc limit 1;




 