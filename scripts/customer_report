/*
=================================================================================
Customer Report
=================================================================================
purpose:
	- This report consolidates key customer metrics and behaviors.

Highlights:
	1.Gathers essential fields such as names,ages,and transaction details.
	2.Segments customers into VIP,regular,new and age groups.
	3.Aggregates customer level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan in months
	4.Calculate valueable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
==================================================================================
*/

create view gold.report_customers as 
/*--------------------------------------------------------------------------------
1) Base query : Retrives core columns from tables
----------------------------------------------------------------------------------*/
with base_query as (
	select f.order_number,
		   f.product_key,
		   f.order_date,
		   f.sales_amount,
		   f.quantity,
		   c.customer_key,
		   c.customer_number,
		   concat(c.first_name , ' ' , c.last_name) as customer_name,
		   datediff(year,c.birthdate,getdate()) as age
	from gold.fact_sales f
	left join gold.dim_customer c
	on f.customer_key = c.customer_key
	where f.order_date is not null
),

/*--------------------------------------------------------------------------------
2) customer aggregations : summaries key metrices at the customer level 
----------------------------------------------------------------------------------*/
customer_aggregations as (
	select customer_key,
		   customer_number,
		   customer_name,
		   age,
		   count(distinct order_number) as total_orders,
		   sum(sales_amount) as total_sales,
		   sum(quantity) as total_quantity,
		   count(distinct product_key) as total_products,
		   DATEDIFF(month,min(order_date),max(order_date)) as lifespan,
		   max(order_date) as last_order_date
	from base_query
	group by customer_key,
		   customer_number,
		   customer_name,
		   age)
select     customer_key,
		   customer_number,
		   customer_name,
		   age,
		   case when age < 20 then 'under 20'
			    when age between 20 and 29 then '20-29'
				when age between 30 and 39 then '30-39'
				when age between 40 and 49 then '40-49'
				else '50 and above'
				end as age_group,
		   case when lifespan >=12 and total_sales > 5000 then 'VIP'
				when lifespan>= 12 and total_sales <= 5000 then 'Regular'
				else 'New'
			end as cust_segment,
		   last_order_date,
		   DATEDIFF(month , last_order_date , getdate()) as recency,
		   total_orders,
		   total_sales,
		   total_quantity,		   
		   lifespan,
		   case when total_sales = 0 then 0
				else total_sales/total_orders end as AOV,
		   case when lifespan = 0 then lifespan
				else total_sales/lifespan end as avg_monthly_spend

from customer_aggregations;

