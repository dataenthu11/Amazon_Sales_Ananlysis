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


Usage
Prerequisites:

Install the following packages: dplyr, readxl, tidyverse, lubridate, fpp2.
Run the Script:

Load the dataset (named Amazon_2_Raw in the script).
Execute each section sequentially to generate visualizations and forecasts.
Dataset Requirements:
Columns: Order ID, Order Date, Ship Date, EmailID, Geography, Category, Product Name, Sales, Quantity, Profit.
Output:


File Structure
Script Name: amazon_sales_analysis.R
Folders:
##### Analysing Amazon Sales by Category,Product and Forecasting ###
##### Created on 12/3/2024 by Vaishnave Anantha ####


install.packages("dplyr")
install.packages("readxl")
install.packages("tidyverse")
install.packages("lubridate")
install.packages("fpp2")

library(ggplot2)
library(dplyr)
library(tidyverse)
library(fpp2)
library(lubridate)

glimpse(Amazon_2_Raw)
range(Amazon_2_Raw$Profit,na.rm = TRUE)
p.products <- filter(Amazon_2_Raw,Profit>1)
range(Amazon_2_Raw$`Order Date`,na.rm = TRUE)
max.profit <- max(Amazon_2_Raw$Profit)
p.products %>% 
  group_by(Category) %>% 
  summarize(max(Profit))

install.packages("tidyverse")

#Category Sales and Profit 

ggplot(p.products, aes(x = Category, y = max.profit, fill = Category))
      + geom_bar(stat = "identity")+labs( title = "Maximum Profit by Category",x = "Category",  y = "Maximum Profit" ) 
    +theme_minimal() +theme(axis.text.x = element_text(angle = 45, hjust = 1))
    ![Maximum Profit by Category](https://github.com/user-attachments/assets/c3b71e68-ec6e-4a99-a2cc-9d8163831fa7)

 
###-- TIme Series Analysis and forecast --###
library(ggplot2)
library(dplyr)
library(tidyverse)
library(fpp2)
library(lubridate)
view(monthly_summary)
###--Creating a time series on Sales with table name --###
Sales_P <- ts(monthly_summary[,2],start = c(2011,1),frequency=12)

###-- Creating timeplot to check trend & seasonality-- ###
autoplot(Sales_P)+ggtitle("Sales from 2011 - 2015")

###-- Data has trend, taking first difference to remove trend --###
Sales_DP <- diff(Sales_P)
autoplot(Sales_DP)+ggtitle("Sales removing trend")

###-- Series appear to have trend stationary use to investigate seasonality --###
ggseasonplot(Sales_DP)+ggtitle("Sales seasonality")
ggsubseriesplot(Sales_DP)+ggtitle("Sales sub-seasonality")

###-- Forecast with various methods 1.Seasonal Naive 2.ETS 3.ARIMA COmparing
###-- SD and ACF to forecast based on the best SD using ETS --###
sn_salesP <-snaive(Sales_DP)
print(summary(sn_salesP))
checkresiduals(sn_salesP)

ws <- ets(Sales_P)
print(summary(ws))
checkresiduals(ws)
lm <-auto.arima(Sales_P,d=1,D=1,stepwise = FALSE,approximation = FALSE,trace = TRUE)
print(summary(lm))
checkresiduals(lm)
frcst_sales <- forecast(ws,h=24)
autoplot(frcst_sales)
print(summary(frcst_sales))

![Forecast using ETS](https://github.com/user-attachments/assets/fc3c216b-dc49-49d3-9cc4-d3cd68aff39c)


###-- TOp 10 products --###
top10 <- Amazon_2_Raw%>%
  group_by(`Product Name`)%>%
  summarise(Sales=sum(Sales),Profit=sum(Profit))%>%
  arrange(desc(Sales))%>%slice_head(n =10)
#Horizontal Bar Plot#
ggplot(top10,aes(x =reorder(`Product Name`,Sales),y =Sales))+geom_bar(stat ="identity",fill ="steelblue")+labs(title ="Top 10 Products by Sales",x ="Product Name",y ="Sales")+coord_flip()+theme_minimal()
 
  ![Top 10 Products](https://github.com/user-attachments/assets/a4c0f16f-141b-485c-ad79-9ebd76f78563)

##--Sales by State--###
library(tidyr)
# Split Geography and Group by State###
geo_analysis <-Amazon_2_Raw %>%separate(Geography,into =c("Country","City","State"),sep =",",extra ="merge")%>%group_by(State)%>%summarise(Sales =sum(Sales),Profit =sum(Profit))%>%arrange(desc(Sales))
# Map or Bar Chart
ggplot(geo_analysis,aes(x =reorder(State,Sales),y =Sales))+geom_bar(stat ="identity",fill ="orange")+labs(title ="Sales by State",x ="State",y ="Sales")+coord_flip()+theme_minimal()

 ![Sales by State](https://github.com/user-attachments/assets/2861ad81-00dc-42e2-90cb-dd696a3e3134)


##-- Top 10 Customers by Sales and Profit--##
top_customers <-Amazon_2_Raw %>%group_by(EmailID)%>%summarise(Sales =sum(Sales),Profit =sum(Profit))%>%arrange(desc(Sales))%>%slice_head(n =10)
##-- Bar Plot of Sales vs Profit --##
ggplot(top_customers,aes(x =Sales,y =Profit,label =EmailID))+geom_bar(stat="identity",fill="darkgreen")+labs(title ="Top Customers: Sales vs Profit",x ="Total Sales",y ="Total Profit")+theme_minimal()
 
  ![Top Customer](https://github.com/user-attachments/assets/acbf0070-704e-44d2-9b9a-72297a713398)

# Calculate Shippingtime#
shipping_analysis <-Amazon_2_Raw %>%mutate(Shipping_Time =as.numeric(difftime(`Ship Date`,`Order Date`,units ="days")))%>%group_by(Category)%>%summarise(Avg_Shipping_Time =mean(Shipping_Time,na.rm =TRUE),Profit =sum(Profit))%>%arrange(desc(Profit))
# Bubble Chart: Shipping Time vs Profit by Category--##
ggplot(shipping_analysis,aes(x =Avg_Shipping_Time,y =Profit,size =Profit,label =Category))+geom_point(alpha =0.6,color ="purple")+geom_text(vjust =-0.5,size =3)+labs(title ="Shipping Efficiency: Time vs Profit",x ="Average Shipping Time (Days)",y ="Total Profit",size ="Profit")+theme_minimal()

![Shipping Efficiency](https://github.com/user-attachments/assets/e670750b-9d1c-4349-94f2-f8e88a4c1690)

