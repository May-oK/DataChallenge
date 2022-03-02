## DALI Data Challenge
##
## Name: May Oo Khine
## Date: March 2, 2022

## Visual 4: Gini Index by Income Group and UN Regions


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


final <- wiid%>%
  filter(year>=1940)%>%
  group_by(year, country)%>%
  ggplot(., aes(x=year, y=gini_reported, color=region_un)) +
  geom_point(data=select(wiid, -region_un), color="grey") +
  geom_point(aes(fill=region_un)) +
  facet_grid(region_un~factor(incomegroup, ordered=TRUE, levels=c("High income", "Upper middle income", "Lower middle income", "Low income"))) + 
  theme_light() + 
  theme(plot.title = element_text(size=20)) + 
  labs(title="Gini Index Values of UN Regions by income group, 1940 - 2017", x="Year", y="Mean Gini Index Value", color="UN Region", fill="All other countries") +
  scale_color_manual(values=c("#FFD700", "#F08080", "#008000", "#66CDAA", "#DA70D6"))

final
