## DALI Data Challenge
##
## Name: May Oo Khine
## Date: March 2, 2022

## Visual 3: Mean Gini Index by country, by UN Subregions
## Inspired from: https://www.r-graph-gallery.com/circular-barplot.html


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


## Read in WIDD data
wiid <- read_csv("wiid.csv")
View(wiid)
head(wiid)
tail(wiid)


unique(sort(wiid$region_un))

## Africa
Africa <- wiid%>%
  filter(region_un=="Africa")%>%
  group_by(region_un_sub, country)%>%
  summarize(meanGini = mean(gini_reported, na.rm=TRUE))

## Create ID column for data
Africa$id <- 1:nrow(Africa) 

# Get Labels
label_data <- Africa
number_of_bar <- nrow(label_data)
angle <- 90 - 360 * (label_data$id-0.5) /number_of_bar    
label_data$hjust <- ifelse( angle < -90, 1, 0)
label_data$angle <- ifelse(angle < -90, angle+180, angle)

# Get continental average
Africa_average <- wiid%>%
  filter(region_un=="Africa")%>%
  summarize(meanGini = mean(gini_reported, na.rm=TRUE))
Africa_average <- Africa_average$meanGini
  
Africa_c <- ggplot(Africa, aes(x=as.factor(id), y=meanGini, fill=region_un_sub)) +    
  geom_hline(yintercept=Africa_average, color="gray", alpha = 0.7, linetype="dashed", size=0.5) +
  geom_bar(stat="identity", alpha=0.7) +
  ylim(-50,100) +
  theme_void() +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=20),
    legend.position=c(1,0.95),
    legend.direction="horizontal",
    legend.justification="right",
    plot.margin = unit(rep(3,10), "cm")) +
  coord_polar(start = 0) + 
  annotate("text", label = "-- Regional Average GI = 47.3775", x = 1, y = -42, size=3) +
  ggtitle("Africa") +
  scale_fill_manual("Subregions", values = c("#F27960", "#D79FFF", "#AEE990", "#F2BE68", "#9BCAEF"))+
  geom_text(data=label_data, aes(x=id, y=meanGini+10, label=country, hjust=hjust), 
            color="black", fontface="bold",alpha=0.6, size=3, angle= label_data$angle, inherit.aes = FALSE ) 

Africa_c 


#Americas
Americas <- wiid%>%
  filter(region_un=="Americas")%>%
  group_by(region_un_sub, country)%>%
  summarize(meanGini = mean(gini_reported, na.rm=TRUE))

## Create ID column for data
Americas$id <- 1:nrow(Americas) 

# Get labels
label_data2 <- Americas
number_of_bar2 <- nrow(label_data2)
angle2 <- 90 - 360 * (label_data2$id-0.5) /number_of_bar2     
label_data2$hjust <- ifelse( angle2 < -90, 1, 0)
label_data2$angle <- ifelse(angle2 < -90, angle2+180, angle2)

# Get continental average
Americas_average <- wiid%>%
  filter(region_un=="Americas")%>%
  summarize(meanGini = mean(gini_reported, na.rm=TRUE))
Americas_average <- Americas_average$meanGini

Americas_c <- ggplot(Americas, aes(x=as.factor(id), y=meanGini, fill=region_un_sub)) +    
  geom_hline(yintercept=Americas_average, color="gray", alpha = 0.7, linetype="dashed", size=0.5) +
  geom_bar(stat="identity", alpha=0.7) +
  ylim(-50,100) +
  theme_void() +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=20),
    legend.position=c(1,0.95),
    legend.direction="horizontal",
    legend.justification="right",
    plot.margin = unit(rep(3,10), "cm")) +
  coord_polar(start = 0) + 
  annotate("text", label = "-- Regional Average GI = 47.1280", x = 1, y = -42, size=3) +
  ggtitle("Americas") +
  scale_fill_manual("Subregions", values = c("#F27960", "#D79FFF", "#F2BE68", "#9BCAEF"))+
  geom_text(data=label_data2, aes(x=id, y=meanGini+10, label=country, hjust=hjust), 
            color="black", fontface="bold",alpha=0.6, size=3, angle= label_data2$angle, inherit.aes = FALSE ) 


Americas_c



#Asia
Asia <- wiid%>%
  filter(region_un=="Asia")%>%
  group_by(region_un_sub, country)%>%
  summarize(meanGini = mean(gini_reported, na.rm=TRUE))

## Create ID column for data
Asia$id <- 1:nrow(Asia) 


# Get labels
label_data3 <- Asia
number_of_bar3 <- nrow(label_data3)
angle3 <- 90 - 360 * (label_data3$id-0.5) /number_of_bar3   
label_data3$hjust <- ifelse( angle3 < -90, 1, 0)
label_data3$angle <- ifelse(angle3 < -90, angle3+180, angle3)


# Get continental average
Asia_average <- wiid%>%
  filter(region_un=="Asia")%>%
  summarize(meanGini = mean(gini_reported, na.rm=TRUE))
Asia_average <- Asia_average$meanGini

Asia_c <- ggplot(Asia, aes(x=as.factor(id), y=meanGini, fill=region_un_sub)) +    
  geom_hline(yintercept=Asia_average, color="gray", alpha = 0.7, linetype="dashed", size=0.5) +
  geom_bar(stat="identity", alpha=0.7) +
  ylim(-50,100) +
  theme_void() +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=20),
    legend.position=c(1,0.95),
    legend.direction="horizontal",
    legend.justification="right",
    plot.margin = unit(rep(3,10), "cm")) +
  coord_polar(start = 0) + 
  annotate("text", label = "-- Regional Average GI = 36.5028", x = 1, y = -42, size=3) +
  ggtitle("Asia") +
  scale_fill_manual("Subregions", values = c("#F27960", "#D79FFF", "#AEE990", "#F2BE68", "#9BCAEF"))+
  geom_text(data=label_data3, aes(x=id, y=meanGini+10, label=country, hjust=hjust), 
            color="black", fontface="bold",alpha=0.6, size=3, angle= label_data3$angle, inherit.aes = FALSE ) 


Asia_c


#Europe
Europe <- wiid%>%
  filter(region_un=="Europe")%>%
  group_by(region_un_sub, country)%>%
  summarize(meanGini = mean(gini_reported, na.rm=TRUE))

## Create ID column for data
Europe$id <- 1:nrow(Europe) 

# Get labels
label_data4 <- Europe
number_of_bar4 <- nrow(label_data4)
angle4 <- 90 - 360 * (label_data4$id-0.5) /number_of_bar4    
label_data4$hjust <- ifelse( angle4 < -90, 1, 0)
label_data4$angle <- ifelse(angle4 < -90, angle4+180, angle4)


# Get continental average
Europe_average <- wiid%>%
  filter(region_un=="Europe")%>%
  summarize(meanGini = mean(gini_reported, na.rm=TRUE))
Europe_average <- Europe_average$meanGini

Europe_c <- ggplot(Europe, aes(x=as.factor(id), y=meanGini, fill=region_un_sub)) +    
  geom_hline(yintercept=Europe_average, color="gray", alpha = 0.7, linetype="dashed", size=0.5) +
  geom_bar(stat="identity", alpha=0.7) +
  ylim(-50,100) +
  theme_void() +
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size=20),
    legend.position=c(1,0.95),
    legend.direction="horizontal",
    legend.justification="right",
    plot.margin = unit(rep(3,10), "cm")) +
  coord_polar(start = 0) + 
  annotate("text", label = "-- Regional Average GI = 31.9107", x = 1, y = -42, size=3) +
  ggtitle("Europe") +
  scale_fill_manual("Subregions", values = c("#F27960", "#D79FFF", "#AEE990", "#F2BE68"))+
  geom_text(data=label_data4, aes(x=id, y=meanGini+10, label=country, hjust=hjust), 
            color="black", fontface="bold",alpha=0.6, size=3, angle= label_data4$angle, inherit.aes = FALSE ) 

Europe_c
