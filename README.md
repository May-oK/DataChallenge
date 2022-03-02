# DataChallenge
DALI Data Challenge
May Khine, '23


##**Part A**: 
Part A is based on the World Income Inequality Dataset(wiid) and 4 visualizations were created to describe the data. 

###_**Visual 1: Interactive choropleth map of Mean Gini Index by country (2010)**_ 
	Although the dataset recorded values starting from as late as the 1800s until 2017, many values were missing from both ends. From exploring the data, I found out that the year 2010 had the most number of available records (97) of countries’ reported Gini Index, hence why I chose to create a visualization of global Gini Index from 2010 data. As 2010 is more than 10 years ago, it would definitely be more practical to have more updated records but this was the limitation of the dataset. The pop up labels include country name, Gini Index, GDP, and population (by millions), variables which the dataset also included. 


###_**Visual 2: Mean Gini Index by UN Regions (1957-2017)**_ 
	The dataset included categories for UN regions, subregions, and sub-sub-regions which I found very useful. These line charts show each UN region’s mean Gini Index over a period of 60 years. I chose to start from 1957 as that was the earliest year where ALL UN regions had data for and that seemed like a practical approach given the abundance of missing values and small time frame. As some countries had multiple records for the same year, I went with summarizing Gini Index reported to obtain the mean. This was my reasoning behind working with the mean Gini index for other visualizations as well. 


###_**Visual 3: Mean Gini Index of Countries by UN Subregion**_ 
	This visualization focuses on the mean Gini Index of countries in each subregion, faceted into different UN regions. While the previous visualization focused on breaking down Gini Index by UN regions, this one digs deeper into the make up by subregion. The dotted lines in each circular barchart represents the regional average Gini Index Value and as it is plotted with the bins, it would be helpful to compare each country’s Gini Index with that of the others in the UN subregion. It is still important to note, however, that as this dataset has a lot of missing data for countries’ Gini Index, there were cases where only a handful of yearly records were available for some countries while others had more data throughout the years. 


###_**Visual 4: Mean Gini Index of each UN Region, by Income Group**_
	Another useful variable in the dataset was Income Group, although it is not exactly known how countries were categorized respectively. This visualization represents the mean Gini Index value of each UN Region and income group, comparing them against one another overtime. The colored points stand for countries in each region and the gray points stand for all other countries outside of the specific income group. 



##**Part B:** Part B is based on the Assitance Association for Political Prisoner(Burma)'s data on Myanmar's Spring Revolution. After less than a decade of fragile democracy, the military junta staged a coup on February 1, 2021 after detaining the country's president, State Counsellor of Myanmar and Minister of Foreign Affairs, Aung San Suu Kyi, and other political leaders and activists. Since then, numerous protests and civil movements have rose throughout the country and this visualization is based on the death toll so far. As of 2 March, 2022, at lesat 1590 people are confirmed to have been killed by the junta, and at least 9443 detained. 

   This data is incredibly difficult to collect and navigate through due to the dangerous conditions on-ground, lack of access to and infrastructure of data resources, and protection and privacy rights of those who have fallen, as well as of their families. I find it very humbling and important to recognize that these records, however incomplete they may be, are not just statistics but actual lives. For this part, I attempted to conduct a predictive model on the death toll of Myanmar’s coup based on data from Feb 2021 to Dec 2021. After some data cleaning, I made a time series object, tallying up deaths by date, to visualize the death toll across the span of 10 months. Then, I used Arima modeling in R to predict the death toll for approximately the next month based on the documented pattern. The mean absolute percentage error(MAPE) of the Arima model was 137.0761 which indicated that it was not a good fit. However, this outcome is not very surprising as I realistically did not expect much predictability due to the 1) the unpredictable nature of the political situation and of death and 2) multivariate time series input. 

