select count(*) from pizza_sales;

select count(distinct pizza_id)
from pizza_sales;

select distinct(datepart(year, order_date))
from pizza_sales;

select distinct(datepart(month, order_date))
from pizza_sales
order by 1;

--KPI
--Total Revenue
select cast(sum(total_price) as decimal(10,2)) as total_revenue
from pizza_sales;

--Average Order Value
select cast((sum(total_price) / count(distinct order_id)) as decimal(10,2)) as avg_order_value
from pizza_sales;

--Total Pizzas Sold
select sum(quantity) as total_pizza_sold
from pizza_sales;

--Total Orders
select count(distinct order_id) as total_orders
from pizza_sales;

--Average Pizzas per Order 
select cast(sum(quantity) / cast(count(distinct order_id) as decimal(10,2)) as decimal(10,2)) as avg_pizza_per_order
from pizza_sales;

--CHART REQUIREMENTS
--Daily trends for Total Order
select datename(dw, order_date) as order_day, sum(quantity) as no_of_orders
from pizza_sales
group by datename(dw, order_date)
order by 1;

--Hourly trends for Total Order
select datepart(hour, order_time) as hour, sum(quantity) as no_of_orders 
from pizza_sales
group by datepart(hour, order_time)
order by 1;

--Percentage sales per Pizza Category
select pizza_category, cast(sum(total_price) as decimal(10,2)) as total_sales,
cast((sum(total_price)/(select sum(total_price) from pizza_sales)) * 100 as decimal(10,2)) as percentage_sales
from pizza_sales
group by pizza_category;

--Percentage sales per Pizza Size
select pizza_size, cast(sum(total_price) as decimal(10,2)) as total_sales,
cast((sum(total_price)/(select sum(total_price) from pizza_sales)) * 100 as decimal(10,2)) as percentage_sales
from pizza_sales
group by pizza_size
order by 3;

--Percentage sales per Pizza Size per quarter
select pizza_size, cast(sum(total_price) as decimal(10,2)) as total_sales, 
cast((sum(total_price)/(
	select sum(total_price) 
	from pizza_sales 
	where datepart(quarter, order_date) = 3
)) * 100 as decimal(10,2)) as percentage_sales
from pizza_sales
where datepart(quarter, order_date) = 3
group by pizza_size
order by 3;

--Total Pizza sold by Category
select pizza_category, sum(quantity) as total_pizza_sold
from pizza_sales
group by pizza_category;

--Top best sellers by Pizzas sold
select top 5
pizza_name, sum(quantity) as total_sold
from pizza_sales
group by pizza_name
order by 2 desc;

--Bottom worst sellers by Pizzas sold
select top 5
pizza_name, sum(quantity) as total_sold
from pizza_sales
group by pizza_name
order by 2;

