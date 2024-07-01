library(shiny) # shiny features
library(shinydashboard) # shinydashboard functions
library(DT)  # for DT tables
library(dplyr)  # for pipe operator & data manipulations
library(plotly) # for data visualization and plots using plotly 
library(ggplot2) # for data visualization & plots using ggplot2
library(ggtext) # beautifying text on top of ggplot
library(shinycssloaders) # to add a loader while graph is populating


my_data<-read.csv("C:\\Users\\visha\\Downloads\\vgsales.csv")

c1 = my_data %>% 
  select(-"Name") %>% 
  names()

yearly_sales <- my_data %>%
  group_by(Year) %>%
  summarise(Total_Sales = sum(Global_Sales))

genre_data <- my_data %>%
  group_by(Genre) %>%
  summarise(count = n())

platform_counts <- table(my_data$Platform)

# Convert the frequency table to a data frame
platform_data <- data.frame(Platform = names(platform_counts), Count = as.numeric(platform_counts))

# Sort the data by count in descending order
platform_data <- platform_data[order(-platform_data$Count), ]

publisher_name<-unique(my_data$Publisher)
