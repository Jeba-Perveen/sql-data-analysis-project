# sql-data-analysis-project

This SQL project provides comprehensive sales analytics through dimensional modeling, focusing on customer behavior, product performance, and time-based sales trends. The analysis uses a star schema with fact and dimension tables to deliver actionable business insights.
Database Schema
Tables Used

- gold.dim_customer - Customer dimension table
- gold.dim_products - Product dimension table
- gold.fact_sales - Sales fact table

**Analysis Components**
1. Time-Based Sales Analysis
   Yearly Sales Performance

- Annual sales revenue trends
Customer count by year
Total quantity sold per year

- Monthly Sales Patterns

Month-over-month sales comparison
Sales aggregation by calendar month
Formatted monthly sales reports (yyyy-MMM)

- Advanced Time Series Analysis

Running Total: Cumulative sales over time
Moving Average: Price trend analysis
Helps identify seasonal patterns and growth trajectories

**2. Product Performance Analysis**
Year-over-Year Product Comparison
Analyzes each product's performance by:

Comparing current year sales to historical average
Calculating year-over-year growth/decline
Categorizing products as "above average," "below average," or "average"
Tracking previous year performance using LAG functions

Category Contribution Analysis

Identifies top-performing product categories
Calculates percentage contribution to total sales
Provides insights for inventory and marketing decisions

Product Segmentation by Cost
Products are grouped into cost ranges:

Below $100
$100 - $500
$500 - $1,000
Above $1,000

Useful for pricing strategy and portfolio management.
**3. Customer Segmentation**
Three-Tier Customer Segmentation
Customers are classified based on spending behavior and tenure:

VIP: 12+ months history AND spending > $5,000
Regular: 12+ months history AND spending ≤ $5,000
New: Less than 12 months history

This segmentation enables targeted marketing and retention strategies.
**4. Comprehensive Reports (Views)**
Customer Report (gold.report_customers)
A consolidated view providing:
Customer Demographics:

Customer identification (key, number, name)
Age and age group segmentation (Under 20, 20-29, 30-39, 40-49, 50+)

Behavioral Metrics:

- Total orders and sales
- Total quantity purchased
- Number of unique products bought
- Customer lifespan (in months)

Key Performance Indicators:

Recency: Months since last order
AOV (Average Order Value): Total sales / total orders
Average Monthly Spend: Total sales / lifespan

Use Cases:

Customer lifetime value analysis
Churn risk identification
Personalized marketing campaigns

Product Report (gold.report_products)
A consolidated view providing:
Product Information:

- Product identification and classification
- Category and subcategory
- Cost structure

Performance Metrics:

- Total orders and revenue
- Total quantity sold
- Customer reach (unique customers)
- Product lifespan (in months)

Product Segmentation:

- High Performers: Sales > $50,000
- Mid Range: Sales between $10,000 - $50,000
- Low Performers: Sales < $10,000

Key Performance Indicators:

- Recency: Months since last sale
- Average Selling Price: Calculated from sales/quantity
- Average Order Revenue: Revenue per order
- Average Monthly Revenue: Sales velocity over product lifetime

Use Cases:

- Product portfolio optimization
- Inventory planning
- Pricing strategy development

SQL Techniques Demonstrated

- Window Functions: LAG, AVG OVER, SUM OVER for trend analysis
- CTEs (Common Table Expressions): For modular, readable queries
- Date Functions: YEAR, MONTH, DATETRUNC, DATEDIFF, FORMAT
- Conditional Logic: CASE statements for segmentation
- Aggregations: SUM, COUNT, AVG with GROUP BY
- Joins: LEFT JOIN for dimension-fact relationships
- Views: Creating reusable reporting layers

**Key Business Insights Enabled**

- Sales Trends: Identify growth patterns and seasonality
- Customer Value: Segment customers for targeted strategies
- Product Performance: Optimize inventory and marketing focus
- Revenue Attribution: Understand category contributions
- Lifecycle Analysis: Track customer and product lifespans
- Pricing Intelligence: Analyze price points and revenue generation

**Requirements**

SQL Server (uses GETDATE(), DATETRUNC, and DATEDIFF functions)
Access to gold layer tables (dim_customer, dim_products, fact_sales)

**Usage**

Execute queries sequentially or select specific analyses as needed
Create views for ongoing reporting requirements
Modify segmentation thresholds based on business rules
Integrate views with BI tools for visualization

**Future Enhancements**

- RFM (Recency, Frequency, Monetary) analysis
- Customer churn prediction models
- Product affinity and basket analysis
- Geographic sales distribution
- Seasonal demand forecasting


Author : Jeba perveen

