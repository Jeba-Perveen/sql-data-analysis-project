
/*
=================================================================================
Product Report
=================================================================================
purpose:
	- This report consolidates key product metrics and behaviors.

Highlights:
	1.Gathers essential fields such as product names,category,subcategory and cost.
	2.Segments products by revenue to identify high performers,mid-range or low-performers.
	3.Aggregates product level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers
		- lifespan in months
	4.Calculate valueable KPIs:
		- recency (months since last sales)
		- average order revenue
		- average monthly revenue
==================================================================================
*/
create view gold.report_products as
with base_query as (
	select f.order_number,
		   f.order_date,
		   f.customer_key,
		   f.sales_amount,
		   f.quantity,
		   p.product_key,
		   p.product_name,
		   p.category,
		   p.subcategory,
		   p.cost
	from gold.fact_sales f
	left join gold.dim_products p
	on p.product_key = f.product_key
	where f.order_date is not null),

product_aggregations as (
	select product_key,
		   product_name,
		   category,
		   subcategory,
		   cost,
		   count(distinct order_number) as total_orders,
		   sum(sales_amount) as total_sales,
		   sum(quantity) as total_quantity,
		   count(distinct customer_key) as total_customer,
		   max(order_date) as last_order_date,
		   datediff(month , min(order_date),max(order_date)) as lifespan,
		   round(avg(cast(sales_amount as float)/nullif(quantity,0)),2) as avg_selling_price
	from base_query
	group by product_key,
		   product_name,
		   category,
		   subcategory,
		   cost)

select product_key,
	   product_name,
	   category,
	   subcategory,
	   cost,
	   last_order_date,
	   DATEDIFF(month , last_order_date,GETDATE()) as recency,
	   case when total_sales > 50000 then 'High performers'
		    when total_sales >= 10000 then 'mid range'
			else 'low performers'
			end as product_segment,
	   lifespan,
	   total_orders,
	   total_sales,
	   total_quantity,
	   total_customer,   
	   avg_selling_price,
	   case when total_orders = 0 then 0
	        else total_sales/total_orders end as average_order_revenue,
	   case when lifespan = 0 then total_sales
			else total_sales/lifespan end as avg_monthly_spend
from product_aggregations
