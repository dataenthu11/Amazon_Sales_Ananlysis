**Overview**
This R script performs a comprehensive analysis of Amazon sales data, providing insights into sales and profit trends, category performance, top-performing products, customer analysis, shipping efficiency, and sales forecasting. The script uses various visualization techniques and statistical methods to uncover patterns and trends.

**Author**
Name: Vaishnave Anantha
Created On: December 3, 2024

**Features**
**Category Analysis:**
Maximum profit by category visualized using a bar chart.

**Time Series Analysis and Forecasting:**
Time series decomposition and visualization of sales trends from 2011 to 2015.
Seasonal analysis and forecasting using Seasonal Naïve, ETS, and ARIMA methods.

**Top Products Analysis:**
Horizontal bar chart showcasing the top 10 products by sales.

**Geographical Analysis:**
Sales and profit summarized by state using a bar chart.

**Customer Analysis:**
Top 10 customers by sales and profit visualized using a bar chart.

**Shipping Efficiency:**
Analysis of average shipping time versus profit by category, visualized with a bubble chart.

Future Enhancements
Include automated report generation in PDF/HTML using R Markdown.
Perform more granular analysis, such as trends by city or customer demographics.


Load the dataset (named Amazon_Sales in the script).
Execute each section sequentially to generate visualizations and forecasts.
Dataset Requirements:
Columns: Order ID, Order Date, Ship Date, EmailID, Geography, Category, Product Name, Sales, Quantity, Profit.
Output:


**File Structure**
Script Name: amazon_sales_analysis.R

##### Analysing Amazon Sales by Category,Product and Forecasting ###
##### Created on 12/3/2024 by Vaishnave Anantha ####

**#Category Sales and Profit** 
The below plot shows the most profitable categories are in PAPER and BINDER categories

![Maximum Profit by Category](https://github.com/user-attachments/assets/4af362e8-6966-461f-9ba6-2e2f49447f29)
   
 ****###-- TIme Series Analysis and forecast --###****

Create a time series on Sales with table name Sales_P and creating timeplot to check trend & seasonality
Data has trend, taking first difference to remove trend 
Series appear to have trend stationary use to investigate seasonality 
****Forecast with various methods 1.Seasonal Naive 2.ETS 3.ARIMA Comparing****
Seasonal Naive produced a SD of 7655 extremely high,however ACF lies in range.
Residual sd: 7655 in Snaive method ACF has few outliers

![ACF- Snaive](https://github.com/user-attachments/assets/375ed7ca-1c4b-4a52-b5e7-0ce49186a2b9)

ETS method produced a SD of 4308,however ACF lies in range.
Residual sd: 4308  in ETS method ACF lies in range
![ACF_ets](https://github.com/user-attachments/assets/30cd2a8e-2893-4082-8c53-df77a4faa029)

AIRMA method produced a SD of 4780 which is higher than ETS method and ACF lies in range.
![ACF_ARIMA](https://github.com/user-attachments/assets/18092614-6dfe-4901-b7a2-2a96c976e16d)

AS ETS has better SD compared to other methods using ETS method to forecast sales of 2016,2017

 
![Forecast using ETS](https://github.com/user-attachments/assets/fc3c216b-dc49-49d3-9cc4-d3cd68aff39c)


****###-- TOp 10 products --###****

![Top 10](https://github.com/user-attachments/assets/696d0f4c-fe50-4b3d-bb29-16dfc19c1a26)


**##--Sales by State--###**

 ![Sales by State](https://github.com/user-attachments/assets/2861ad81-00dc-42e2-90cb-dd696a3e3134)


**##-- Top 10 Customers by Sales and Profit--##**

![Top10Customer](https://github.com/user-attachments/assets/97661644-c2a1-459c-8e50-029277be0ade)


# Calculate Shippingtime#

# Bubble Chart: Shipping Time vs Profit by Category--##

![Shipping Efficiency](https://github.com/user-attachments/assets/e670750b-9d1c-4349-94f2-f8e88a4c1690)

