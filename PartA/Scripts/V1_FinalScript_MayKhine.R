## DALI Data Challenge
##
## Name: May Oo Khine
## Date: March 2, 2022

## Visual 1: 2010 Interactive Global Choropleth Map of Mean Gini Index 


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


## Download world base map and unzip
download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="world_shape_file.zip")

world_map <- readOGR("/Users/sudikofflabimac/Desktop/May_DaliData/world_shape_file", "TM_WORLD_BORDERS_SIMPL-0.3")

## Make copy of wiid dataset
wiid_copy <- data.frame(wiid)

## Subset to columns we want
wiid_copy <- wiid_copy[c("id","country","c3", "year", "gini_reported", "population", "gdp_ppp_pc_usd2011", "median_usd")]

unique(sort(wiid_copy$year))
## Checked 2017 data --> only 26 values
## Year with most data available = 2010

## Filter to 2010
wiid_2010_2 <- wiid_copy%>%
  filter(year=="2010")%>%
  group_by(country)%>%
  mutate(meanGini = mean(gini_reported, na.rm=TRUE))%>%
  mutate(meanPop = mean(population, na.rm=TRUE))%>%
  mutate(meanGDP = mean(gdp_ppp_pc_usd2011, na.rm=TRUE))%>%
  mutate(meanIncome = mean(median_usd, na.rm=TRUE))%>%
  select(id, country, c3, meanGini, meanPop, meanGDP, meanIncome)%>%
  rename(NAME = country)

## Store population as millions
wiid_2010_2$meanPop <- (wiid_2010_2$meanPop) / 1000000

## Remove duplicate values
wiid_2010_2 <- distinct(wiid_2010_2, NAME, .keep_all = TRUE)

## Omit NaN values from Gini Index
wiid_2010_2 <- wiid_2010_2[!is.na(wiid_2010_2$meanGini),]
## Data has 97 countries 

## Renaming 9 countries
wiid_2010_2$NAME <- recode(wiid_2010_2$NAME, 
                           "West Bank and Gaza" = "Palestine",
                           "Vietnam" = "Viet Nam",
                           "Taiwan (China)" = "Taiwan",
                           "Moldova" = "Republic of Moldova",
                           "Macedonia, former Yugoslav Republic of" = "The former Yugoslav Republic of Macedonia",
                           "Kosovo" = "Albania",
                           "Gambia, The" = "Gambia",
                           "Eswatini" = "Swaziland",
                           "Czechia" = "Czech Republic")


## Check classes in data
str(wiid_2010_2)  

##----------TEST------------------------------
##map_data <- world_map@data

## Test if names match 
##trial1 <- full_join(map_data, wiid_2010_2, by = "NAME")

## Found 158 null values in meanGini column --> meaning 88 non-null
## Must have 97 non-null values 
## This means 9 country names are unmatched 
## Go back to recode country names 
##sum(is.na(trial1$meanGini))

## After renaming, all 97 countries have found matches! 

## Now, let's do the actual thing on the dataframe in the SPDF

##---------TEST FINISHED--------------------


## Add column to the dataframe (data) in SPDF
world_map@data <- full_join(world_map@data, wiid_2010_2, by = "NAME")

may_palette <- colorNumeric( palette="viridis", domain=world_map@data$meanGini, na.color="transparent")
may_palette(c(45,43))

# Create a color palette with handmade bins.
mybins <- c(20,25,30,35,40,45,50, 55, 60, 65, 70, Inf)
may_palette <- colorBin( palette="YlOrRd", domain=world_map@data$meanGini, na.color="transparent", bins=mybins)

# Prepare the text for tooltips:
popUp <- paste(
  "Country: ", world_map@data$NAME,"<br/>",
  "Population (Millions): ", round(world_map@data$meanPop, 2), "<br/>",
  "Gini Index: ", world_map@data$meanGini, "<br/>",
  "GDP(2011): ", world_map@data$meanGDP, "<br/>",
  sep="") %>%
  lapply(htmltools::HTML)


## Title
title <- tags$style(HTML("
    .leaflet-control.map-title { 
    transform: translate(-50%,20%);
    position: fixed !important;
    left: 50%;
    text-align: center;
    padding-left: 13px; 
    padding-right: 20px; 
    background: rgba(255,255,255,0.75);
    font-weight: bold;
    font-size: 35px;
  }
"))

titleMap <- tags$div(
  title, HTML("Interactive map of Worldwide Gini Index by countries (2010)")
)  

# Final Map
leaflet(world_map) %>% 
  addTiles()  %>% 
  addControl(titleMap, position = "topleft", className="map-title")%>%
  setView( lat=10, lng=0 , zoom=3) %>%
  addPolygons( 
    fillColor = ~may_palette(meanGini), 
    stroke=TRUE, 
    fillOpacity =0.7, 
    color="grey", 
    weight=0.2,
    label = popUp,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px", 
                   "color" = "black",
                   "font-family" = "sans-serif",
                   "box-shadow" = "3px 3px rgba(0,0,0,0.25)",
                   "border-color" = "rgba(0,0,0,0.5)"), 
      textsize = "13px",
      direction = "auto"
    )
  ) %>%
  addLegend( pal=may_palette, values=~meanGini, opacity=0.8, title = "Mean Gini Index in 2010", position = "bottomleft" )
