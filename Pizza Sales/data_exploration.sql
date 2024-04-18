select * 
from pizzas;

select count(*) from order_details;

select count(distinct order_details_id) 
from order_details;

select count(*) from orders;

select * 
from pizza_types;

select * 
from pizzas;

select distinct datepart(year, date)
from orders;

select distinct datepart(month, date)
from orders
order by 1;


-- KPI
-- Total Revenue
select cast(sum(d.quantity * p.price) as decimal(10,2)) as total_revenue
from order_details d, pizzas p
where d.pizza_id = p.pizza_id

-- Average Order Value
select count(*)
from orders;

select cast(
	cast(sum(p.price * d.quantity) as float)/count(distinct o.order_id) as decimal(10,2)
) as avg_order_value
from orders o, pizzas p, order_details d
where d.order_id = o.order_id
and d.pizza_id = p.pizza_id;

-- Total Pizzas Sold
select sum(quantity) as total_pizza_sold
from order_details;

-- Total Orders
select count(order_id) as total_orders
from orders;

-- Average Pizzas per Order
select d.order_id, count(d.pizza_id)
from pizzas p, order_details d 
where d.pizza_id = p.pizza_id
group by d.order_id

select cast(
	cast(sum(quantity) as float)/count(distinct order_id) as decimal(10,2)
) as avg_pizza_per_order
from order_details;

-- Requirement
-- Daily trends for Total Order
select datename(dw, date) as order_day, 
sum(d.quantity) as no_of_orders
from orders o, order_details d
where d.order_id = o.order_id
group by datename(dw, date)
order by 1;


-- Hourly trends for Total Order
select datepart(hour, o.time) as order_hour, 
sum(d.quantity) as no_of_orders
from orders o, order_details d
where d.order_id = o.order_id
group by datepart(hour, time)
order by 1;

-- Percentage sales per Pizza Category
with total_sales as (
	select sum(p.price * d.quantity) as total
	from pizzas p, order_details d
	where p.pizza_id = d.pizza_id
)
select y.category as pizza_category, cast(sum(p.price * d.quantity) as decimal(10,2)) as total_sales,
cast(
	cast(
		sum(p.price * d.quantity) as float
	)/(select total from total_sales) * 100 as decimal(10,2)
) as percentage_sales
from pizzas p, pizza_types y, order_details d
where p.pizza_id = d.pizza_id
and p.pizza_type_id = y.pizza_type_id
group by y.category;

-- Percentage sales per Pizza Size
with total_sales as (
	select sum(p.price * d.quantity) as total
	from pizzas p, order_details d
	where p.pizza_id = d.pizza_id
)
select p.size as pizza_size, cast(sum(p.price * d.quantity) as decimal(10,2)) as total_sales,
cast(
	cast(
		sum(p.price * d.quantity) as float
	)/(select total from total_sales) * 100 as decimal(10,2)
)  as percentage_sales
from pizzas p, order_details d
where p.pizza_id = d.pizza_id
group by p.size
order by 2;

-- Percentage sales per size in the 3rd quarter
with total_sales as (
	select sum(p.price * d.quantity) as total
	from pizzas p, order_details d, orders o
	where p.pizza_id = d.pizza_id
	and d.order_id = o.order_id
	and datepart(quarter, o.date) = 3
)
select p.size, cast(sum(p.price * d.quantity) as decimal(10,2)) as total_sales,
cast(
	cast(
		sum(p.price * d.quantity) as float
	)/(select total from total_sales) * 100 as decimal(10,2)
)  as percentage_sales
from pizzas p, order_details d, orders o
where d.pizza_id = p.pizza_id
and d.order_id = o.order_id
and datepart(quarter, o.date) = 3
group by p.size
order by 3;

-- Total pizzas per category
select y.category as pizza_category, sum(d.quantity) as total_pizza_sold
from pizza_types y, pizzas p, order_details d
where d.pizza_id = p.pizza_id
and p.pizza_type_id = y.pizza_type_id
group by y.category

-- Top best sellers by Pizzas sold
select top 5 y.name as pizza_name, 
sum(d.quantity) as total_sales
from pizzas p, pizza_types y, order_details d
where p.pizza_id = d.pizza_id
and p.pizza_type_id = y.pizza_type_id  
group by y.name
order by 2 desc;

-- Bottom worst sellers by Pizzas sold
select top 5 y.name as pizza_name, 
sum(d.quantity) as total_sales
from pizzas p, pizza_types y, order_details d
where p.pizza_id = d.pizza_id
and p.pizza_type_id = y.pizza_type_id  
group by y.name
order by 2;


-- Data to be exported for further analysis
select d.order_details_id as pizza_id, o.order_id, p.pizza_id as pizza_name_id, 
d.quantity, o.date as order_date, convert(varchar, o.time, 24) as order_time, p.price as unit_price, 
(p.price * d.quantity) as total_price, p.size as pizza_size, y.category as pizza_category, 
y.ingredients as pizza_ingredients, y.name as pizza_name
from pizzas p, pizza_types y, order_details d, orders o
where p.pizza_type_id = y.pizza_type_id
and d.order_id = o.order_id
and d.pizza_id = p.pizza_id
order by d.order_details_id;