## DALI Data Challenge
##
## Name: May Oo Khine
## Date: March 2, 2022

## Visual 2: Mean Gini Index by UN Regions, 1957-2017


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


## Global Mean Gini Index by year (for comparison with regions)
compareYear <- wiid%>%
  filter(year>="1957")%>%
  group_by(year)%>%
  summarize(meanWorldGini = mean(gini_reported, na.rm=TRUE))%>%
  arrange(year)

## Mean Gini Index of UN Regions,  by year
compareRegion <- wiid%>%
  filter(year>="1957")%>%
  group_by(year, region_un)%>%
  summarize(meanGini = mean(gini_reported, na.rm=TRUE))%>%
  arrange(year, -meanGini)

## Combined for final dataframe
combinedRegionYear <- left_join(compareRegion, compareYear, by="year")

## Create new column to store region names for faceted maps
faceted <- combinedRegionYear%>%
  mutate(region2 = region_un)

## Final visualization
faceted %>%
  ggplot( aes(x=year, y=meanGini)) +
  geom_line( data=faceted %>% 
               select(-region_un), aes(group=region2), color="grey", size=0.6, alpha=0.5) +
  geom_line( aes(color=region_un), size=1.2 )+
  scale_color_viridis(discrete = TRUE) +
  theme_ipsum() +
  theme(
    axis.title.y= element_text(color = "grey20", size = 12),
    axis.title.x= element_text(color = "grey20", size = 12),
    legend.position="none",
    plot.title = element_text(size=28),
    panel.grid = element_blank()) +
  ggtitle("Mean Gini Index by UN Regions, 1957-2017") +
  labs(x="Year", y="Mean Gini Index") +
  facet_wrap(~region_un)



