##### Analysing Amazon Sales by Category,Product and Forecasting ###
##### Created on 12/3/2024 by Vaishnave Anantha ####


install.packages("dplyr")
install.packages("readxl")
install.packages("tidyverse")
install.packages("lubridate")
install.packages("fpp2")
install.packages("stringr")

library(ggplot2)
library(dplyr)
library(tidyverse)
library(fpp2)
library(lubridate)
library(stringr)

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

###-- TOp 10 products --###
top10 <- Amazon_2_Raw%>%
  group_by(`Product Name`)%>%
  summarise(Sales=sum(Sales),Profit=sum(Profit))%>%
  arrange(desc(Sales))%>%slice_head(n =10)
#Horizontal Bar Plot#
ggplot(top10,aes(x =reorder(`Product Name`,Sales),y =Sales))+geom_bar(stat ="identity",fill ="steelblue")+labs(title="Top 10 Products by Sales",x ="Product Name",y ="Sales")+coord_flip()+theme(plot.title = element_text(hjust=-2.0))+scale_x_discrete(labels=label_wrap(width=40))  
##--Sales by State--###
library(tidyr)
# Split Geography and Group by State###
geo_analysis <-Amazon_2_Raw %>%separate(Geography,into =c("Country","City","State"),sep =",",extra ="merge")%>%group_by(State)%>%summarise(Sales =sum(Sales),Profit =sum(Profit))%>%arrange(desc(Sales))
# Map or Bar Chart
ggplot(geo_analysis,aes(x =reorder(State,Sales),y =Sales))+geom_bar(stat ="identity",fill ="orange")+labs(title ="Sales by State",x ="State",y ="Sales")+coord_flip()+theme_minimal()
  
##-- Top 10 Customers by Sales and Profit--##
top_customers <-Amazon_2_Raw %>%group_by(EmailID)%>%summarise(Sales =sum(Sales),Profit =sum(Profit))%>%arrange(desc(Sales))%>%slice_head(n =10)
CN <- sub("@.*","",top_customers$EmailID)
view(top_customers)
##-- Bar Plot of Sales vs Profit --##
ggplot(top_customers,aes(x=reorder(Sales),y=Profit,label=CN))+geom_bar(stat ="identity",fill="orange")+geom_label(aes(label=CN),vjust=-0.3,color="black")+coord_flip()
# Calculate Shippingtime#
shipping_analysis <-Amazon_2_Raw %>%mutate(Shipping_Time =as.numeric(difftime(`Ship Date`,`Order Date`,units ="days")))%>%group_by(Category)%>%summarise(Avg_Shipping_Time =mean(Shipping_Time,na.rm =TRUE),Profit =sum(Profit))%>%arrange(desc(Profit))
# Bubble Chart: Shipping Time vs Profit by Category--##
ggplot(shipping_analysis,aes(x =Avg_Shipping_Time,y =Profit,size =Profit,label =Category))+geom_point(alpha =0.6,color ="purple")+geom_text(vjust =-0.5,size =3)+labs(title ="Shipping Efficiency: Time vs Profit",x ="Average Shipping Time (Days)",y ="Total Profit",size ="Profit")+theme_minimal()

