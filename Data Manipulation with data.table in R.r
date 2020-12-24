# Chapter 1: Introduction to data.table
# Chapter 2: Selecting and Computing on Columns
# Chapter 3: Groupwise Operations
# Chapter 4: Reference Semantics
# Chapter 5: Importing and exporting data

# Chapter 1: Introduction to data.table
# Lecture 1.1
# DT[i,j,by]
# Create a data.table
data.table()
as.data.table()
fread()
library(data.table)
x_df <- data.frame(id = 1:2, name = c('a','b')
x_df
x_dt <- data.table(id = 1:2, name= c('a','b')
x_dt
y <- list(id = 1:2, name = c('a', 'b')
y
x <- as.data.table(y)
x <- data.table(id = 1:2, name= c('a','b'))
x
class (x) # 'data.table' 'data.frame'
nrow(x)
ncol(x)
dim(x)
# Features:
# 1. 'data.table' 'data.frame'
# 2. Function works on df also works on dt
# 3. DT never converts charactor to factors
# 4. DT never sets, needs or uses row names

# EX: Introducing bikes data
# Print the first 8 rows
head(batrips, 8)
# Print the last 8 rows
tail(batrips, 8)
# Print the structure of batrips
str(batrips)

#Lecture 1.2 Filter rows in a data.table
batrips[3:4] # the same as batrips[3:4,]
batrips[-(1:5)] # exclude first 5 rows, the same as batrips[!(1:5)]
# .N is an integer value that contains the number of rows in the data.table
nrow(batrips)
batrips[.N] # last row
# logical expressions
batrips[subscription_type == "Subscriber"] # select rows where

#EX:Filtering rows using positive integers
# Filter third row
row_3 <- batrips[3]
row_3
# Filter rows 10 through 20
rows_10_20 <- batrips[10:20]
rows_10_20
# Filter the 1st, 6th and 10th rows
rows_1_6_10 <- batrips[c(1,6,10)]
rows_1_6_10

#EX: Filtering rows using negative integers
# Select all rows except the first two
not_first_two <- batrips[-(1:2)]
not_first_two
# Select all rows except 1 through 5 and 10 through 15
exclude_some <- batrips[-c((1:5),(10:15))]
exclude_some
# Select all rows except the first and last
not_first_last <- batrips[2:(.N-1)]
not_first_last

#EX:  Filtering rows using logical vectors
# Filter all rows where start_station is "MLK Library"
trips_mlk <- batrips[start_station == "MLK Library"]
trips_mlk
# Filter all rows where start_station is "MLK Library" AND duration > 1600
trips_mlk_1600 <- batrips[start_station == "MLK Library" & duration> 1600]
trips_mlk_1600
# Filter all rows where `subscription_type` is not `"Subscriber"`
customers <- batrips[subscription_type != "Subscriber"]
customers
# Filter all rows where start_station is "Ryland Park" AND subscription_type is not "Customer"
ryland_park_subscribers <- batrips[start_station == "Ryland Park" & subscription_type != "Customer"]
ryland_park_subscribers

#Lecture 1.3 Helpers for filtering
batrips[start_station %like% "^San Francisco"]
batrips[duration %between% c(2000,3000)]
batrips[start_station %chin% c('Japantown','Mezes Park', 'MLK Library')] # much faster than %in%
batrips[start_station %in% c('Japantown','Mezes Park', 'MLK Library')]

#EX: I %like% data.tables
# Filter all rows where end_station contains "Market"
any_markets <- batrips[end_station %like% "Market"]
any_markets
# Filter all rows where end_station ends with "Market"
end_markets <- batrips[end_station %like% "Market$"]
end_markets

#EX: Filtering with %in%
# Filter all rows where trip_id is 588841, 139560, or 139562
filter_trip_ids <- batrips[trip_id %in% c(588841, 139560, 139562)]
filter_trip_ids

#EX: Filtering with %between% and %chin%
# Filter all rows where duration is between [5000, 6000]
duration_5k_6k <- batrips[duration %between% c(5000,6000)]
duration_5k_6k
# Filter all rows with specific start stations
two_stations <- batrips[start_station %chin% c("San Francisco City Hall", "Embarcadero at Sansome")]
two_stations

# Chapter 2 Selecting columns from a data.table
# Lecture 2.1
ans <- batrips[,c('trip_id','duration')] # j argument accepts a charactor vector of column names
head(ans,2)
# if select like this in df, will return a vector, but in dt it will return a dt
ans <- batrips[,c(2,4)] # not recomend due to easy to change
head(ans,2)
# exclude
ans <- batrips[,-c('trip_id','duration')] or use !
# Selecting using dt way
batrips[duration > 3600]
ans <- batrips[,list(trip_id, dur = duration)]
head(ans, 2)
ans <- batrips[,.(trip_id, dur = duration)]
head(ans, 2)
# will return a dt
ans <- batrips[,list(trip_id)]
head(ans, 2)
# will return a vector
ans <- batrips[,trip_id]

# To sum up:
# j argument accepts a charactor vector of column names / list of colume names
# c('trip_id','duration') - return a dt
# 'duration' - return a dt
# list(trip_id, dur = duration) - return a dt
# trip_id - return a vector

# EX: Selecting columns by name
# Select bike_id and trip_id using a character vector
df_way <- batrips[,c('bike_id','trip_id')]
df_way
# Select start_station and end_station cols without a character vector
dt_way <- batrips[, .(start_station,end_station)]
dt_way

# EX: Deselecting specific columns
# Deselect start_terminal and end_terminal columns
drop_terminal_cols <- batrips[,-c('start_terminal','end_terminal')]
drop_terminal_cols

# Lecture 2.2 Computing on columns the data.table way
# Since columns can be refered to as variables, we can compute directly on them in j
ans <- batrips[,mean(duration)] # return a vector
# combine i and j
batrips[start_station == 'japantown', mean(duration)]
# special symbol: .N
batrips[start_station == 'japantown', .N] # return a vector of how many rows meet the i condition

# EX: Computing in j (I)
# Calculate median duration using the j argument
median_duration <- batrips[,median(duration)]
median_duration
# Get median duration after filtering
median_duration_filter <- batrips[end_station=='Market at 10th' & subscription_type == 'Subscriber', median(duration)]
median_duration_filter

# EX: Computing in j (II)
# Compute duration of all trips
trip_duration <- batrips[, difftime(end_date,start_date)]
head(trip_duration)

# Lecture 2.3 Advanced computations in j
batrips[,.(mn_dur = mean(duration),med_dur = median(duration))]
batrips[start_station == 'japantown', .(mn_dur = mean(duration),med_dur = median(duration))]

# EX: Computing in j (III)
# Calculate the average duration as mean_durn
mean_duration <- batrips[, .(mean_durn = mean(duration))] # = can only be used in list form
mean_duration
# Get the min and max duration values
min_max_duration <- batrips[, .(min(duration),max(duration))]
min_max_duration
# Calculate the average duration and the date of the last ride
other_stats <- batrips[, .(mean_duration = mean(duration),last_ride = max(end_date))]
other_stats

# EX: Combining i and j
duration_stats <- batrips[start_station == "Townsend at 7th" & duration < 500,
                          .(min_dur = min(duration),
                            max_dur = max(duration))]
duration_stats
# Plot the histogram of duration based on conditions
batrips[start_station == "Townsend at 7th" & duration < 500, hist(duration)]

# Chapter 3 Groupwise Operation
# Lecture 3.1 Computation by groups
# By argument accepts both charactor vectors of column names as well as a list of variables/ expressions
ans <- batrips[,.N,by= "start_station"]
ans <- batrips[,.N,by= .(start_station)]
head(ans,3)
# By allows renaming
ans <- batrips[,.(no_trip = .N),by= .(start = start_station)]
ans <- batrips[,.N,by= .(start_station, mon = month(start_date))]
head(ans,3)

# EX: Computing stats by groups (I)
# Compute the mean duration for every start_station
mean_start_stn <- batrips[,.(mean_duration = mean(duration)), by = start_station ]
mean_start_stn

# EX: Computing stats by groups (II)
# Compute the mean duration for every start and end station
mean_station <- batrips[, .(mean_duration = mean(duration)), by = .(start_station, end_station)]
mean_station
# Compute the mean duration grouped by start_station and month
mean_start_station <- batrips[,.(mean_duration = mean(duration)), by = .(start_station, month(start_date))]
mean_start_station

# EX:Computing multiple stats
# Compute mean of duration and total trips grouped by start and end stations
aggregate_mean_trips <- batrips[, .(mean_duration = mean(duration),total_trips = .N) , by = .(start_station, end_station)]
aggregate_mean_trips
# Compute min and max duration grouped by start station, end station, and month
aggregate_min_max <- batrips[,.( min_duration = min(duration), max_duration = max(duration)), by = .(start_station, end_station, month(start_date))]
aggregate_min_max

# Lecture 3.2 Chaining data.table expressions
batrips[, .(mn_dur = mean(duration)), by = 'start_station'][order(mn_dur)][1:3]
# uniqueN() returns an integer value containing number of unique values
id <- c(1,2,2,1)
x <- data.table(id, val = 1:4)
uniqueN(x) # 4
uniqueN(x, by = 'id') # 2, return unique group rows
ans <- batrips[, uniqueN(bike_id), by = month(start_date)] # unique rows by each group

#EX: Ordering rows
# Compute the total trips grouped by start_station and end_station
trips_dec <- batrips[, .N, by = .(start_station,
                                  end_station)]
trips_dec
# Arrange the total trips grouped by start_station and end_station in decreasing order
trips_dec <- batrips[, .N, by = .(start_station,
                                  end_station)][order(-N)]
trips_dec

#EX: What are the top 5 destinations?
# Top five most popular destinations
top_5 <- batrips[, .N, by = end_station][order(-N)][1:5]
top_5

#EX: What is the most popular destination from each start station?
# Compute most popular end station for every start station
popular_end_station <- trips_dec[, .(end_station = end_station[1]),
                                 by = start_station]
popular_end_station
#trips_dec

# EX: Combining i, j, and by (I)
# Find the first and last ride for each start_station
first_last <- batrips[,
                      .(start_date = start_date[order(start_date)][c(1,.N)]),
                      by = start_station]
first_last

# Lecture 3.3 Computations in j using .SD
# subset of data, .sd
x <- data.table(id = c(1,1,2,2,1,1), val1 = 1:6, val2 = letter[6:1])
x[,print(.sd),by = id]
x[,.SD[1], by = id] # extract the first row of each group
x[,.SD[.N], by = id] # extract the last row of each group
# .SDcols holds the columns that should be included in .SD
batrips[, .SD[1], by = start_station, .SDcols = c("trip_id", "duration")] # or - c("trip_id", "duration")

relevant_cols <- c("start_station", "end_station",
                   "start_date", "end_date", "duration")

# EX: Using .SD (I)
# Find the row corresponding to the shortest trip per month
shortest <- batrips[, .SD[order(duration)][1],
                    by = month(start_date),
                    .SDcols = relevant_cols]
shortest

# EX: Using .SD (II)
# Find the total number of unique start stations and zip codes per month
unique_station_month <- batrips[,lapply(.SD, uniqueN),
                                by = month(start_date),
                                .SDcols = c("start_station", "zip_code")]
unique_station_month

# Find the total number of unique start stations and zip codes per month
unique_station_month <- batrips[, uniqueN(.SD["start_station"], .SD["zip_code"]),
                                by = month(start_date),
                                .SDcols = c("start_station", "zip_code")]
unique_station_month

# Chapter 4: Reference Semantics
# Lecture 4.1 Adding and Updating columns by reference
batrips[,c("is_dur_gt_1hour","week_day") := list(duration > 3600, wday(start_date))]
batrips[,is_dur_gt_1hour := duration > 3600] # adding a single column quote are necessary
batrips[,':='(is_dur_gt_1hour = NULL, start_station = toupper(start_station))]

# EX: Adding a new column
# Add a new column, duration_hour
batrips[, duration_hour := duration/3600]

# EX: Updating an existing column (I)
# Fix spelling in the second row of start_station using the LHS := RHS form
untidy[,start_station:= "San Francisco City Hall"]

# EX: Updating an existing column (II)
# Replace negative duration values with NA
untidy[duration < 0,  duration  := 'NA'  ]

# Lecture 4.2 Grouped Aggregations
batrips[,n_zip_code := .N, by = zip_code] # add a column to sum the total trips of each zipcode
batrips[,n_zip_code := .N, by = zip_code][]
zip_1000 <- batrips[n_zip_code > 1000][,n_zip_code := NULL]
zip_1000 <- batrips[,n_zip_code := .N, by = zip_code][n_zip_code > 1000][,n_zip_code := NULL]

# EX: Adding columns by group
# Add a new column equal to total trips for every start station
batrips[, trips_N := .N, by = start_station]
# Add new column for every start_station and end_station
batrips[, duration_mean := mean(duration), by = .(start_station, end_station)]

# EX: Updating columns by group
# Calculate the mean duration for each month
batrips_new[, mean_dur := mean(duration, na.rm = TRUE),
            by = month(start_date)]
# batrips_new[,duration == '']
# Replace NA values in duration with the mean value of duration for that month
batrips_new[, mean_dur := mean(duration, na.rm = TRUE),
            by = month(start_date)][is.na(duration),
                                    duration := mean_dur]

# Delete the mean_dur column by reference
batrips_new[, mean_dur := mean(duration, na.rm = TRUE),
            by = month(start_date)][is.na(duration),
                                    duration := mean_dur][, mean_dur := NULL ]

# Lecture 4.3 Advanced aggregations
batrips[,c('end_dur_first', 'end_dur_last') := list(duration[1], duration[.N]), by = end_station]
# Binning values
batrips[, trip_category := { med_dur = median(duration, na.rm = TRUE)
                             if (med_dur < 600)"short",
                             else if (med_dur >= 600 & med_dur <= 1800) "medium"
                             else "long"
                             },
                             by = .(start_station, end_station)]

bin_median_duration <- function(dur) {med_dur = median(dur, na.rm = TRUE)
                             if (med_dur < 600)"short",
                             else if (med_dur >= 600 & med_dur <= 1800) "medium"
                             else "long" }
batrips[, trip_category :=  bin_median_duration (duration),  by = .(start_station, end_station)]

batrips[duration > 500, min_dur_gt_500 := min(duration), by = .(start_station, end_station)]

# EX: Adding multiple columns (I)
# Add columns using the LHS := RHS form
batrips[, c('mean_duration', 'median_duration') := .(mean(duration),median(duration)), by = start_station]

# EX: Adding multiple columns (II)
# Add columns using the functional form
batrips[, ':='(mean_duration = mean(duration),median_duration = median(duration)),
        by = start_station]
        # Add columns using the functional form
batrips[, `:=`(mean_duration = mean(duration),
               median_duration = median(duration)),
        by = start_station]


# Add the mean_duration column
batrips[duration > 600, mean_duration := mean(duration), by = .(start_station,end_station)]

# Chapter 5: Importing and Exporting Data
# Lecture 5.1 Fast data reading with fread()
# File from URL
DT1 <- fread("https://bit.ly/2RkBXhv") # can read file from URL
DT2 <- fread("data.csv") # can read local csv file
DT3 <- fread("a,b\n1,2\n3,4") # can read string
fread("a,b\n1,2\n3,4", nrows = 1)
str <- '# metadata\nTimesstamp: 2018-05-01 19:44:28 GMT\na,b\n1,2\n3,4'
fread(str,skip = 2)
fread(str,skip = "a,b") # parse from the string line
fread(str,skip = "a,b", nrows =1 )
str <- 'a,b,c\n1,2,x\n3,4,y'
fread(str,select = c("a","c")
fread(str,drop = "b")
str <- '1,2,x\n3,4,y'
fread(str,select = c(1,3)
fread(str,drop = 2)

#EX:Fast reading from disk
# Use read.csv() to import batrips
system.time(read.csv("batrips.csv"))
# Use fread() to import batrips
system.time(fread("batrips.csv"))

#EX:Importing a CSV file
# Import using read.csv()
csv_file <- read.csv('sample.csv', fill = NA, quote = "",
                     stringsAsFactors = FALSE, strip.white = TRUE,
                     header = TRUE)
csv_file
# Import using fread()
csv_file <- fread('sample.csv')
csv_file

#EX: Importing selected columns
# Select "id" and "val" columns
select_columns <- fread("sample.csv", select = c('id','val'))
select_columns
# Drop the "val" column
drop_column <- fread("sample.csv", drop = 'val')
drop_column

#EX: Importing selected rows
# Import the file
entire_file <- fread('sample.csv',skip=2)
entire_file
# Import the file while avoiding the warning
only_data <- fread("sample.csv", nrows = 3)
only_data
# Import only the metadata
only_metadata <- fread("sample.csv", skip = "attr;value" )
only_metadata

#Lecture 5.2 Advanced file reading
str <- 'x1,x2,x3,x4,x5\n1,2,1.5, true,cc\n3,4,2.5,false,ff'
ans <- fread(str, colClasses = c(x5 = "factor")
str(ans)
ans <- fread(str, colClasses = c("integer","integer", "numeric","logical","factor")
str(ans)
ans <- fread(str, colClasses = list(numeric = 1:4, factor = c("x5","x6")))
str(ans)
fread(str, fill = TRUE)
# missing values are commonly encoded as: "999" or "##NA" of "N/A"
str <- "x,y,z\n1, ###, 3\n2,4,###\n#N/A,7,9"
ans <- fread(str,na.strings = c("###", "#N/A"))

#EX: Reading large integers
# Import the file using fread
fread_import <- fread("sample.csv")

# Import the file using read.csv
base_import <- read.csv("sample.csv")

# Check the class of id column
class(fread_import$id) #"integer64"
class(base_import$id) #"numeric"

#EX: Specifying column classes
# Import using read.csv with defaults
base_r_defaults <- read.csv("sample.csv")
str(base_r_defaults)
# Import using read.csv
base_r <- read.csv("sample.csv",
                   colClasses = c(rep("factor",4),
                                  "character", "integer",
                                  rep("numeric",4)))
str(base_r)
# Import using fread
import_fread <- fread("sample.csv",
                      colClasses = list(factor = 1:4, numeric = 7:10))
str(import_fread)

#EX: Dealing with empty and incomplete lines
# Import the file correctly
correct <- fread("sample.csv", fill = TRUE)
correct

#EX: Dealing with missing values
# Import the file using na.strings
missing_values <- fread("sample.csv", na.strings = c("##"))
missing_values

#Lecture 5.3 Fast data writting with fwrite()
dt <- data.table(id = c('x','y','z'), val = list(1:2,3:4,5:6)) # ability to write list columns using seconddary separator (|)
fwrite(dt,"fwrite.csv")
fread("fwrite.csv")
now <- Sys.time()
dt <- data.table(date = as.IDate(now), #2018-12-17
                 time = as.ITime(now), #19:54:51
                 datetime = now) #2018-12-17 19:54:51
dt
fwrite(dt, "datetime.csv", dateTimeAs = "ISO")
fread("datetime.csv")

#Squash
fwrite(dt, "datetime.csv", dateTimeAs = "squash") # date was imported as integers
fread("datetime.csv")
20181217 %/% 10000 # 2018

#Epoch
fwrite(dt, "datetime.csv", dateTimeAs = "epoch") # date since 1970-01-01, 00:00:00
fread("datetime.csv")

#EX: Writing files to disk
# Write dt to fwrite.txt
fwrite(dt, "fwrite.txt")

# Import the file using readLines()
readLines("fwrite.txt")

# Import the file using fread()
fread("fwrite.txt")

#EX: Writing date and time columns
# Write batrips_dates to file using "ISO" format
fwrite(batrips_dates,"iso.txt", dateTimeAs = "ISO")

# Import the file back
iso <- fread("iso.txt")
iso

# Write batrips_dates to file using "squash" format
fwrite(batrips_dates, "squash.txt", dateTimeAs = "squash")

# Import the file back
squash <- fread("squash.txt")
squash

# Write batrips_dates to file using "epoch" format
fwrite(batrips_dates, "epoch.txt", dateTimeAs = "epoch")

# Import the file back
epoch <- fread("epoch.txt")
epoch

#EX: Fast writing to disk
# Use write.table() to write batrips
system.time(write.table(batrips, "base-r.txt"))
# Use fwrite() to write batrips
system.time(fwrite(batrips, "data-table.txt"))