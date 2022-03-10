# Cyclistic: case study of a bike sharing project
#
## Installation of the packages
#
install.packages("tidyverse") # Wrangle data
install.packages("ggplot2") # plot graphs and vizs
install.packages("tibble") # new version of the usual dataframe()
install.packages("tidyr") # Organize data
install.packages("readr") # import csv files
install.packages("purr") # Enhances R Function Programmming
install.pacakges("stringr") # Detext pattern of strings
install.packages("forcats") # handle categorical variables
install.packages("lubridate") # Wranle data attributes
install.packages("skimr") # Get Summary Data
install.packages("janitor") # Cleaning dirty data
install.packages("dplyr") # to use the function mutate in the cleaning process
library(tidyverse)
library(ggplot2)
library(tibble)
library(tidyr)
library(readr)
library(purr)
library(stringr)
library(forcats)
library(lubridate)
library(skimr)
library(janitor)
library(dplyr)

# Step 1: Collect the Data
## To know which is the destination file to upload the files
getwd()

Trips_Mar21 <- read_csv("202102-divvy-tripdata.csv", TRUE)
Trips_Apr21 <- read_csv("202103-divvy-tripdata.csv", TRUE)
Trips_May21 <- read_csv("202104-divvy-tripdata.csv", TRUE)
Trips_Jun21 <- read_csv("202105-divvy-tripdata.csv", TRUE)
Trips_Jul21 <- read_csv("202106-divvy-tripdata.csv", TRUE)
Trips_Aug21 <- read_csv("202107-divvy-tripdata.csv", TRUE)
Trips_Sep21 <- read_csv("202108-divvy-tripdata.csv", TRUE)
Trips_Oct21 <- read_csv("202109-divvy-tripdata.csv", TRUE)
Trips_Nov21 <- read_csv("202110-divvy-tripdata.csv", TRUE)
Trips_Dec21 <- read_csv("202111-divvy-tripdata.csv", TRUE)
Trips_Jan22 <- read_csv("202112-divvy-tripdata.csv", TRUE)
Trips_Feb22 <- read_csv("202201-divvy-tripdata.csv", TRUE)

### We have now uploaded the files and created them as a data frame

# Step 2: Wrangle Data and Combine into a Single File

## Combine all dataframes into one single dataframe name bike_rides
### Before you must be sure that each file has the same columns structure and name
colnames(Trips_Apr21)
colnames(Trips_Mar21)
colnames(Trips_May21)
colnames(Trips_Jun21)
colnames(Trips_Jul21)
colnames(Trips_Aug21)
colnames(Trips_Sep21)
colnames(Trips_Oct21)
colnames(Trips_Nov21)
colnames(Trips_Dec21)
colnames(Trips_Jan22)
colnames(Trips_Feb22)
### It looks like they are all the structure

ride_bikes <- list(Trips_Mar21,Trips_Apr21, Trips_May21, Trips_Jun21, Trips_Jul21, Trips_Aug21, Trips_Sep21, Trips_Oct21, Trips_Nov21, Trips_Dec21, Trips_Jan22, Trips_Feb22)

## check the Incongruous Characteristics in the data frame

str(Trips_Apr21)

## We can compare column datatype across the data frames by using compare_df-cols

compare_df_cols(Trips_Mar21,Trips_Apr21, Trips_May21, Trips_Jun21, Trips_Jul21, Trips_Aug21, Trips_Sep21, Trips_Oct21, Trips_Nov21, Trips_Dec21, Trips_Jan22, Trips_Feb22, return = "mismatch")

### First Problem: start and end_station_id to be modified to characters so they can stack correctly
Trips_Apr21 <- mutate(Trips_Apr21, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
### check if it worked by using str(Trips_Apr21)
str(Trips_Apr21)
### Let's do the same with all data frames
Trips_May21 <- mutate(Trips_May21, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
Trips_Jun21 <- mutate(Trips_Jun21, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
Trips_Jul21 <- mutate(Trips_Jul21, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
Trips_Aug21 <- mutate(Trips_Aug21, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
Trips_Sep21 <- mutate(Trips_Sep21, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
Trips_Oct21 <- mutate(Trips_Oct21, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
Trips_Nov21 <- mutate(Trips_Nov21, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
Trips_Dec21 <- mutate(Trips_Dec21, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
Trips_Jan22 <- mutate(Trips_Jan22, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))
Trips_Feb22 <- mutate(Trips_Feb22, end_station_id = as.character(end_station_id), start_station_id = as.character(start_station_id))

### Let's Bind all the data frames into a single one that will be active
all_trips <- bind_rows(Trips_Mar21, Trips_Apr21, Trips_May21, Trips_Jun21, Trips_Jul21, Trips_Aug21, Trips_Sep21, Trips_Oct21, Trips_Nov21, Trips_Dec21, Trips_Jan22, Trips_Feb22)

# Step 3: Clean Up and Add Data to Prepare for the Analysis
## Let's have some insights
### List of Column Names
colnames(all_trips)

### Dimensions of the data frame
dim(all_trips)

### See the first 6 rows of the data frame
head(all_trips)

### See the last 6 rows of the data frame (we can see there are some NA's)
tail(all_trips)

### See list of Columns and data types (num, character, etc)
str(all_trips)

### Let's have a Statistical Summary of the data.
summary(all_trips)

### Get Summary of data, check missing data
skim(all_trips)

### Add Column Date, Year, Month, Day of Week
### Before we need to rename some columns
all_trips <- all_trips %>% rename(
         trip_id= ride_id, 
         ride_type= rideable_type, 
         start_time= started_at, 
         end_time= ended_at,
         from_station_name= start_station_name,
         from_station_id= start_station_id,
         to_station_name= end_station_name,
         to_station_id= end_station_id,
         user_type= member_casual)

### So now we can add a new column for month, day, year, and day of the week
all_trips$date <- as.Date(all_trips$start_time)  # The default format is yyyy-mm-dd
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

### we will add a "ride_length" calculation to all_trips (in seconds)
all_trips$ride_length <- difftime(all_trips$end_time, all_trips$start_time)

### Convert "ride_length" from Factor to Numeric so we can run calculations on the data
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)


## Now we can remove the dirty data
skim(all_trips$ride_length)
### Create a sub data frame v2 where we have the cleaned data
all_trips_v2 <- all_trips[!(all_trips$ride_length<0),]
skim(all_trips_v2)


# Step 4: Conduct Descriptive Analysis
summary(all_trips_v2$ride_length)

## Export the CSV file for further analysis in Tableau
write.csv(all_trips_v2, "data.csv")


# Some plots for fun

ggplot(data=all_trips_v2) +
  geom_bar(mapping=aes(x=day_of_week, color=day_of_week))

ggplot(data=all_trips_v2) +
  geom_bar(mapping=aes(x=month, color=month))

ggplot(data=all_trips_v2) +
  geom_bar(mapping=aes(x=user_type, color=user_type))

ggplot(data=all_trips_v2) +
  geom_bar(mapping=aes(x=ride_type, color=ride_type))

