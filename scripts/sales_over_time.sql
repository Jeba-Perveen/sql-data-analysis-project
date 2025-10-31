-- calculate sales over time
select year(order_date) as order_year,
	   sum(sales_amount) as total_sales,
	   count(distinct customer_key) as total_customers,
	   sum(quantity) as total_quantity
from gold.fact_sales 
where order_date is not null
group by year(order_date)
order by year(order_date)


select month(order_date) as order_month,
	   sum(sales_amount) as total_sales
from gold.fact_sales 
where order_date is not null
group by month(order_date)
order by month(order_date)


select datetrunc(month ,order_date) as order_month,
	   sum(sales_amount) as total_sales
from gold.fact_sales 
where order_date is not null
group by datetrunc(month ,order_date)
order by datetrunc(month ,order_date)

select format(order_date,'yyyy-MMM') as order_date,
	   sum(sales_amount) as total_sales,
	   count(distinct customer_key) as total_customers,
	   sum(quantity) as total_quantity
from gold.fact_sales 
where order_date is not null
group by format(order_date,'yyyy-MMM')
order by format(order_date,'yyyy-MMM')

-- calculate total sales per month
-- and the running total of sales over time and moving average

select order_month,
	   total_sales,
	   avg_price,
	   sum(total_sales) over (partition by order_month order by order_month) as running_total,
	   avg(avg_price) over(order by order_month) as moving_average
from(
	select datetrunc(month ,order_date) as order_month,
		   sum(sales_amount) as total_sales,
		   avg(price) as avg_price
	from gold.fact_sales 
	where order_date is not null
	group by datetrunc(month ,order_date)
)t

/*
Analyze the yearly performance of products by comparing each product's sales
to both the average sales performance and the previous year's sales.
*/
with yearly_product_sales as (
	select year(f.order_date) as order_year,
		   p.product_name,
		   sum(f.sales_amount) as current_sales
	from gold.fact_sales f
	left join gold.dim_products p
	on p.product_key = f.product_key
	where order_date is not null
	group by year(f.order_date) , p.product_name
)
select order_year,
	   product_name,
	   current_sales,
	   avg(current_sales) over(partition by product_name) as avg_sales,
	   current_sales - avg(current_sales) over(partition by product_name) as avg_diff,
	   case when current_sales - avg(current_sales) over(partition by product_name)>0 then 'above average'
	        when current_sales - avg(current_sales) over(partition by product_name)<0 then 'below average'
			else 'avg'
	   end as avg_change,
	   lag(current_sales) over(partition by product_name order by order_year) as py_sales,
	   current_sales - lag(current_sales) over(partition by product_name order by order_year) as py_diff,
	   case when current_sales - lag(current_sales) over(partition by product_name order by order_year)>0 then 'Increase'
	        when current_sales-lag(current_sales) over(partition by product_name order by order_year)<0 then 'Decrease'
			else 'no change'
	   end as py_change

from yearly_product_sales
order by product_name,order_year

-- which categories contribute the most to overall sales
with category_sales as(
	select p.category,
		   sum(f.sales_amount) as total_sales
	from gold.fact_sales f
	left join gold.dim_products p
	on p.product_key = f.product_key
	group by p.category
	)
select category,
	   total_sales,
	   sum(total_sales) over() as overall_sales,
	  concat(round ((cast(total_sales as float)/sum(total_sales) over() )*100,2) ,' %')as percent_of_total
from category_sales;

/* 
segment products into cost range and
count how many products fall into each category
*/
with product_segment as (
	select product_key,
		   product_name,
		   cost,
		   case when cost < 100 then 'below 100'
				when cost between 100 and 500 then '100-500'
				when cost between 500 and 1000 then '500-1000'
				else 'above 1000'
			end as cost_range
	from gold.dim_products
) 
select cost_range,
	   count(product_key) as total_products
from product_segment
group by cost_range;

/*
Group customers into three segments based on their spending behavior.
  - VIP : At least 12 months of history and spending more than 5000
  - Regular : At least 12 month of history but spending 5000 or less.
  - New : lifespan less than 12 months.
And final the total number of customers by each group.
*/
with customer_spending as (
	select c.customer_key,
		   sum(f.sales_amount) as total_spending,
		   min(f.order_date) as first_order,
		   max(f.order_date) as last_order,
		   DATEDIFF(month,min(f.order_date),max(f.order_date)) as lifespan
	from gold.fact_sales f
	left join gold.dim_customer c
	on c.customer_key = f.customer_key
	group by c.customer_key
)
select cust_segment,
	   count(customer_key) as total_customer
from(
	select customer_key,
		   total_spending,
		   lifespan,
		   case when lifespan >=12 and total_spending > 5000 then 'VIP'
				when lifespan>= 12 and total_spending <= 5000 then 'Regular'
				else 'New'
			end as cust_segment
	from customer_spending)t
group by cust_segment;


