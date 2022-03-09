# My Data Analytics Portofolio 2022



### Table of contents
1. Introduction
2. Ask
3. Prepare
4. Process and Clean 
5. Analyze
6. Share
7. Act




# Introduction

This case study is my capstone project for the Google Data Analytics Certificate.
It involves analysis of historical data for a fictional company, cyclistic, a bike sharing company located in Chicago, to make recommendations for an upcoming marketing campaign. Although the company and scenario are fictitious, the data used for this project are real data collected between August 2020 and March 2022 from a bike share program in Chicago. In this project, I am assuming the role of the junior analyst.
Cyclistic is a fictional bike sharing company located in Chicago. It operates a fleet of more than 5,800 bicycles which can be accessed from over 600 docking stations across the city. Bikes can be borrowed from on docking station, ridden, then returned to any docking station in the system. Over the years, marketing campagins have been broad and targeted a cross-section of potential users. Data analysis has shown that riders with an annual membership are more profitable than casual riders. The marketing team are interested in creating a campaign to encourage casual riders to convert to members.
The marketing analyst team would like to know how annual members and casual riders differ, why casual riders would buy a membership, and how Cyclistic can use digital media to influence caual riders to become members. The team is interested in analyzing the Cyclistic historical bike trip data to identify trends in the usage of bikes by casual and member riders.



# 1. Ask

## Business Objective 

To increase profitability by converting casual riders to annual members via a targeted marketing campaign

## Business Task 

The analyst has been tasked with answering this question: 
How do annual members and casual riders use Cyclistic bikes differently ? 

## Stakeholders

The stakeholders in this project include:

Lily Moreno, Director of Marketing at cyclistic, who is responsible for the marketing campaings at Cyclistic

The Cyclistic marketing analytics team. This team is responsible for collecting, analyzing and reporting data to be used in marketing campaigns. I am the analyst on this team.

The Cyclistic executive team. This team makes the final decision on the recommended marketing plan. They are notoriously detail-oriented.

# 2. Prepare

### Where is the Data located ?

The data is available at this location:
http://divvy-tripdata.s3.amazonaws.com/index.html

https://github.com/JcB1971/Portfolio_2022/blob/0dd581819f59eea4ba0101148e2ad6682319b24d/Screenshot%20from%202022-03-08%2016-17-00.png

Just click and download the last 12 months.

### How is the data organized ?

The data is organized in monhtly csv files. The most recent twelve months of data (March 2021 - March 2022) were used for this project. 
The files consist of 13 columns containing information related :
* ride_type
* start_time
* end_time
* from_station_name
* from_station_id
* to_station_name
* to_station_id
* start_lat
* start_lng
* end_lat
* end_lng
* user_type
* date

### Credibility of the Data
The data is collected directly by Motivate, Inc., the company that runs the Cyclistic Bike Share program for the city of Chicago. The data is comprehensive in that it consists of data for all the rides taken on the sytem and is not just a sample of the data. The data is current. It is released monthly and, as of March 2022, was current to February 2022. The city of Chicago makes the data availale to the public.

### Licencing, Privacy, Security and Accessibility
This data is anonymzed as it has been stripped of all identifying information. This ensures privacy, but it limits the extent of the analysis possible. There is not enough data to determine if casual riders are repeat riders or if casual riders are residents of the Chicago area. The data is released under this licence:
http://www.divvybikes.com/data-licence-agreement

### Ability of data to be used to answer Business Question
One of the fields in the  data records the type of rider; casual riders pay for individual or daily rides and member riders purchase annual subscription. This information is crucial to be able to determine differences between how the two groups use the bike share program.

### Problems with the data
Ther are some problems with the data. Most of the problems (duplicate records, missing fields, etc.) can be dealt with by data cleaning, but a couple of issues require futher explanation.

### Rideable_type Field
The rideable_type field contains one of three values:
- Electric bike
- Classic bike
- Docked bike

Electic and Classic seem self-explanatory, but what exactly a Docked bike is, is unclear. From a review of the data it  seems that electric bikes were available to both types of users for the entire 12 months period; Classic bikes were available to both groups of users but only from December 2, 2020 to Jly 31, 2021; and Docked bikes were available to members from August 1, 2020 to January 13, 2021 and to casual riders for the entire 12 months. For the purpose of this analysis these rideable types will not be used to segment the data or draw any conclusions about the bike preferences as data collection for this variable is not consistent across the time period analyzed.

### Latitude and Longitude
There are also a challenge with the latitude and longitude coordinates for the stations. 
Each station is represented by a range of lat/long coordinates. The start/end latitude and longitude seem to indicate the location of a particular bike. Creating a list of popular stations is not difficult, but mapping the stations is more problematic. 
This was remedied by averaging the lat and long values for the stations before mapping. This resulted in the rides counts for a station matching the ride count for one set of lat/long coordinates.

# 3. Process and Clean

### What tools are we choosing and why ?
For this project I have chosen to use RStudio Desktop to prepare, clean, and analyze the data. 
I later on used Tableau to create the visualizations. The data set was too large to be processed in spreadsheets and Rstudio Cloud.

### Review of the Data
Data was reviewd to get an overall understanding of content of fields, data formats, and to ensure its integrity. The review of the data involved, checking column names across the 12 original files and checking for missing values, trailing white spaces, duplicate records, and other data anomalies.

The review of the data revealed several problems:
- Duplicate record ID numbers
- Records with missing start and end stations
- Records with very short or very long ride durations
- Records for trips starting or ending at an administrative station (repair or teseting station)

Once the initial review was completed, all 12 files were loaded into one data frame calle all_rides. The resulting amalgamated file consisted of 
- Rows 5,601,999
- Col 13
- Character 7
- Numeric 4
- POSIXct 2

https://github.com/JcB1971/Portfolio_2022/blob/main/Screenshot%20from%202022-03-08%2016-17-00.png

### Extraction of Data from Existing Fields
To allow for more granular analysis of the data  and more insights, several new columns were created and populated with data from the started_at column of date and time. These new columns were day, month, year, time and day of the week.
Another column was created to contain the trip duration (length of each trip). The data for this column was created by calculating the difference in time between the start and end time of the ride. Another version of this column was then created to contain the trip duration in minutes.
Rename Columns:
https://github.com/JcB1971/Portfolio_2022/blob/main/Screenshot%20from%202022-03-08%2011-12-02.png

Create Columns:
https://github.com/JcB1971/Portfolio_2022/blob/main/Screenshot%20from%202022-03-08%2014-52-36.png


### Data Cleaning
Duplicate records (based on the RIDE ID field) were removed.
Code: 

all_trips_v2 <- distinct(all_trips, ride_id, .keep_all=TRUE)

Records for trips less than 60 seconds (false starts) or longer than 24 hours were removed. Bikes out longer than 24 hours are considered stolen and the rider is charged for a replacement.
Code:
<font color="green">  </font>

all_trips_v2 <- all_trips_v2[!
(all_trips_v2$ride_length<60 | 
all_trips_v2$ride_length>86400),] </font>

Records with missing fields start_station, end_station, start/end lat/long fields were removed.
Code:
all_trips_v2 <- all_trips_v2[!
(is.na(all_trips_v2$start_station_id) |
is.na(all_trips_v2$end_station_id) |
is.na(all_trips_v2$ride_id) |
is.na(all_trips_v2$rideable_type) |
is.na(all_trips_v2$started_at) |
is.na(all_trips_v2$ended_at) |
is.na(all_trips_v2$end_lat) |
is.na(all_trips_v2$end_lng)),]

Records for trips that started or ended at DIVVY CASSETTE REPAIR MOBILE STATION orHUBBARD ST BIKE CHECKING (LBS-WH-TEST) were removed as these are administrative stations.
