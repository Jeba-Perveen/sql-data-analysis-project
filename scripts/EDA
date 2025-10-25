-- Explore all object in the database
select * from 
INFORMATION_SCHEMA.TABLES;

-- Explore all columns in the database
select * from 
INFORMATION_SCHEMA.COLUMNS;

-- Explore all country our customers come from.
select distinct country 
from gold.dim_customer;

-- Explore all the categories
select distinct category 
from gold.dim_products;

-- Explore all the subcategories
select distinct subcategory
from gold.dim_products;

-- Explore all the product name
select distinct product_name 
from gold.dim_products;

-- find the date of the first and last order
-- How many years of sales are available
select
	min(order_date) as first_order,
	max(order_date) as last_order,
	datediff(year, min(order_date),max(order_date)) as order_range_years
from gold.fact_sales;

-- find the youngest and the oldest customer
select
	min(birthdate) as oldest_customer,
	datediff(year,min(birthdate),getdate()) as oldest_cust_age,
	max(birthdate) as youngest_customer,
	datediff(year,max(birthdate),getdate()) as youngest_cust_age
from gold.dim_customer;

-- find the total sales
select sum(sales_amount) as total_sales 
from gold.fact_sales;

- find how many items are sold
select sum(quantity) as total_qty from gold.fact_sales

-- find average selling price
select avg(price) as avg_price 
from gold.fact_sales;

-- fing the total numbers of orders
select count( distinct order_number) as total_orders
from gold.fact_sales;

-- find the total number of products
select count(distinct product_name) as total_product from gold.dim_products;

-- find the total number of customers
select count( customer_key) as total_customer from gold.dim_customer;

-- Generate a report that shows all key metrics of the business
select  'Total Sales' as measure_name ,sum(sales_amount) as measure_value from gold.fact_sales
union all
select  'Total quantity' as measure_name ,sum(quantity) as measure_value from gold.fact_sales
union all
select  'Average Price' as measure_name ,avg(price) as measure_value from gold.fact_sales
union all
select  'Total No. orders' as measure_name ,count(distinct order_number) as measure_value from gold.fact_sales
union all
select  'Total no. products' as measure_name ,count(product_name) as measure_value from gold.dim_products
union all
select  'Total no. customers' as measure_name ,count(customer_key) as measure_value from gold.dim_customer;

-- find total customers by countries
select country,
	   count(customer_key) as total_customer 
from gold.dim_customer
group by country
order by total_customer desc;

-- find total customer by gender
select gender,
	   count(customer_key) as total_customer 
from gold.dim_customer
group by gender
order by total_customer desc;

-- find total products by category
select category,
	   count(product_key) as total_products 
from gold.dim_products 
group by category
order by total_products desc;

-- what is the average costs in each category?
select category,
	   avg(cost) as avg_cost 
from gold.dim_products 
group by category
order by avg_cost desc;

-- what is the total revenue generate for each category?
select p.category,
	   sum(f.sales_amount) as total_revenue
from gold.fact_sales f
left join gold.dim_products p
on f.product_key = p.product_key
group by p.category
order by total_revenue desc;

-- What is the distribution of sold items across countries?
select c.country,
	   sum(f.quantity) as total_sold_items
from gold.fact_sales f
left join gold.dim_customer c
on c.customer_key = f.customer_key
group by c.country
order by total_sold_items desc;

-- which 5 products generate the highest revenue?
select top 5
	p.product_name,
	sum(f.sales_amount) as total_revenue
 from gold.fact_sales f
 left join gold.dim_products p
 on f.product_key = p.product_key
 group by p.product_name
 order by total_revenue desc;

-- what are the 5 wrost-performing products in terms of sales?
select top 5
	p.product_name,
	sum(f.sales_amount) as total_revenue
 from gold.fact_sales f
 left join gold.dim_products p
 on f.product_key = p.product_key
 group by p.product_name
 order by total_revenue ;
