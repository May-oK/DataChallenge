## DALI Data Challenge
##
## Name: May Oo Khine
## Date: March 2, 2022

## Part 2: Predictive accuracy 

##Install packages for whole project 
install.packages("readr")
install.packages("tibble")
install.packages("tidyr")
install.packages("dplyr")
install.packages("gglot2")
install.packages("scales")
install.packages("ggtern")
install.packages("rgdal")
install.packages("leaflet")
install.packages("RColorBrewer")
install.packages("htmlwidgets")
install.packages("htmltools")
install.packages("hrbrthemes")
install.packages("viridis")
install.packages("stringr")
install.packages("forecast")
install.packages("zoo")
install.packages("xts")
install.packages("ggrepel")


## Load packages
library(readr)
library(tibble)
library(tidyr)
library(dplyr)
library(ggplot2)
library(scales)
library(ggtern)
library(rgdal)
library(leaflet)
library(RColorBrewer)
library(htmlwidgets)
library(htmltools)
library(hrbrthemes)
library(viridis)
library(stringr)
library(forecast)
library(zoo)
library(xts)

## Load datasets
death <- read_csv("Myanmar Spring Revolution (mmspring.tech)_AAPP Fatality_Table.csv")
jobs <- read_csv("Myanmar Spring Revolution (mmspring.tech)_AAPP Fatality_Bar chart.csv")

str(death)
str(jobs)



## Basic data cleaning
names(death) <- make.names( names(death))
death$Age <- as.numeric(death$Age, na.rm=TRUE)
colnames(death)[which(names(death) == "Deceased.Date")] <- "Date"


##-----------Describe data quantitatively-----------
## Get all unique causes of death
unique(death$Reason_of_death)


death$Reason_of_death<-replace(death$Reason_of_death, death$Reason_of_death=="Shot", "Gunshot")
death$Reason_of_death<-replace(death$Reason_of_death, death$Reason_of_death=="Gunfire", "Gunshot")
death$Reason_of_death<-replace(death$Reason_of_death, death$Reason_of_death=="Detained", "In detainment")
death$Reason_of_death<-replace(death$Reason_of_death, death$Reason_of_death=="Artillery", "Artillery Shell")
death$Reason_of_death<-replace(death$Reason_of_death, death$Reason_of_death=="Hit", "Injury (Miscellaneous)")
death$Reason_of_death<-replace(death$Reason_of_death, death$Reason_of_death=="Beaten", "Injury (Miscellaneous)")
death$Reason_of_death<-replace(death$Reason_of_death, death$Reason_of_death=="Injured", "Injury (Miscellaneous)")


## Check again
unique(death$Reason_of_death)

reasonDeath <- death %>%
  group_by(Reason_of_death)%>%
  mutate(count = n())%>%
  select(c("Reason_of_death", "count"))


## Delete duplicates to get cases by type of death
reasonDeath = reasonDeath[!duplicated(reasonDeath$Reason_of_death), ]

# Get positions
reasonDeath2 <- reasonDeath %>% 
  mutate(csum = rev(cumsum(rev(count))), 
         pos = count/2 + lead(csum, 1),
         pos = if_else(is.na(pos), count/2, pos))

## Make piechart
ggplot(reasonDeath, aes(x="", y=count, fill=Reason_of_death)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  scale_fill_manual(values=alpha(c("#D56327", "#2470AE", "#B645E3", "#C63B34", "#4DCC33", "#44C0B0", "#B17588", "#FFCB5B", "#CFC9BE", "#8AAB8E" ))) +
  theme_void() +
  guides(fill=guide_legend(title="Cause of Death")) +
  theme(plot.title=element_text(size=25, face="bold"),
        legend.text=element_text(size=11),
        legend.title = element_text(size=15))+
  ggtitle("Documented causes of death related to Myanmar's 2021 Coup d'etat (Feb 2021-Feb 2022)", 
          subtitle="Data: Assistance Association for Political Prisoners(Burma)")


##-----------Describe data quantitatively-----------


timeline <- death %>%
  group_by(Date)%>%
  mutate(count = n())%>%
  select(c("Date", "count"))


## Delete duplicates to get death count per date
timeline = timeline[!duplicated(timeline$Date), ]

## Only focus on 2021 data
timeline <- timeline[!grepl("2022", timeline$Date),]

# Change dates into Date Object
timeline$Date2 <- as.Date(timeline$Date, "%B %d, %Y")

str(timeline)

## Check Scatter plot 
timeline%>%
  ggplot(aes(x=Date2, y=count, group=1)) + 
  geom_jitter() + geom_smooth()


## Convert to timeseries
class(timeline)
timeline$Date2 <- as.Date(timeline$Date2) 

timeline_ts <- timeline
timeline_ts <- na.omit(timeline)

class(timeline_ts)


##---------------TRAIL---------------------------------
data_xts <- xts(timeline_ts, order.by = as.Date(timeline_ts$Date2))

#Forecasting with Arima 
##Train/Validation Split
##Train from deadliest months
train <- data_xts[index(data_xts) <= "2021-04-01"]
validation <- data_xts[index(data_xts) > "2021-04-01"]

train_ts <- ts(train)
validation_ts <- ts(validation)

model <- auto.arima(train_ts)
class(train_ts)
str(train_ts)
head(train_ts)
plot(train_ts)

##---------------TRAIL---------------------------------


## First convert to Zoo type and then convert to Time Series
ZOO <- zoo(timeline_ts$count, order.by=as.Date(timeline_ts$Date2))
class(ZOO)


as.numeric(as.Date("2021-02-08") - as.Date("2021-01-01"))
as.numeric(as.Date("2021-12-31") - as.Date("2021-01-01"))

ZOO_ts <- ts(ZOO, frequency=7)

class(ZOO_ts)

plot(ZOO_ts)
model <- auto.arima(ZOO_ts, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
forecast_arima = forecast(model, h=30)
print(forecast_arima)



autoplot(ZOO_ts, series = " Data") +
  autolayer(forecast_arima, series = "Forecast") +
  ggtitle(" Forecasting with ARIMA: Predicting future casualities under Myanmar's junta based on data from Feb to Dec 2021",
          subtitle = "Based on data from Assistance Association for Political Prisoners (Burma)") +
  theme_minimal() +
  theme(plot.title = element_text(size=17, face="bold"),
        axis.title = element_text(size=13),
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks = element_blank()) + 
  labs(x="Month", y="Death Toll") +
  annotate(geom="text", x=2, y=-20, label="Feb 2021",
           color="black",
           size=3.6) +
  annotate(geom="text", x=18, y=-20, label="July 2021",
           color="black",
           size=3.6) +
  annotate(geom="text", x=36, y=-20, label="Dec 2021",
           color="black",
           size=3.6)

accuracy(model)
