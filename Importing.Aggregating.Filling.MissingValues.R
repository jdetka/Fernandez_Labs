
# Install necessary packages
install.packages(c("zoo", "xts", "tidyverse"), dependencies = TRUE)
library(tidyverse); library(zoo); library(xts)

# Sets the working directory to where my files are. 
setwd("C:/Users/jdetk/Desktop/FONR_FOG_Example"); getwd()

# Makes a list of the files inside the working directory. 
file.names <- list.files(pattern = "*.csv"); file.names

# uses the lapply function from tidyverse package to apply the function
# read.csv to all files in the list 'file.names'.
ldf <- lapply(file.names, read.csv, skip = 10); ldf # Data in files extracted into a list by collector
hdf <- lapply(file.names, read.csv, nrows = 10); hdf # metadata headers of files extracted

# Rename the list 
names(ldf)[1:8] <- c("FONR_1","FONR_2","FONR_3","FONR_4","FONR_5","FONR_6","FONR_7","FONR_8")

# Example workflow for processing fog data to hourly observations

# Convert DateTime to POSIXct time from character using striptime function
ldf$FONR_1$DateTime = strptime(ldf$FONR_1$DateTime, format = "%m/%d/%y %H:%M:%S")

# make dataframe of just FONR_1 first two columns
df.FONR_1 <- data.frame(ldf$FONR_1[1:2]); str(df.FONR_1)

# Aggregate data hourly as sum of events. 
FONR_1.hrly <- aggregate(df.FONR_1$Liters, list(hour=cut(df.FONR_1$DateTime, "1 hour")), sum)

# Rename the columns back to DateTime and Liters. Aggregate renames them in process. 
colnames(FONR_1.hrly) <- c("DateTime", "Liters")

# Convert DateTime back to POSIXct again. Aggregate function treats as a factor in the output produced
FONR_1.hrly$DateTime = as.POSIXct(as.factor(FONR_1.hrly$DateTime))

# Create a new dataframe containing the span of dates for the dataset in hourly interval.   
date_span.FONR_1.hrly <- data.frame(DateTime = seq(as.POSIXct(min(FONR_1.hrly$DateTime)), 
                                        as.POSIXct(max(FONR_1.hrly$DateTime)), 
                                        by = "1 hour")) 

# Merge the span of dates at hourly interval with the event data. 
merged.FONR_1.hrly = merge(date_span.FONR_1.hrly, FONR_1.hrly, by = "DateTime", all.x = TRUE)

#Replace NA's in Liters with 0 values to represent no events recorded that hour.  
merged.FONR_1.hrly$Liters[is.na(merged.FONR_1.hrly$Liters)] <- 0

#Optional: Export revised aggregated data with zero event observations to a new CSV. 
write.csv(merged.FONR_1.hrly,"C:/Users/jdetk/Desktop/merged.FONR_1.hrly.csv", row.names = FALSE)

#### Example Plotting aggregated hourly data. 

# Convert to a zoo object. Two ways to order by date. 
merged.FONR_1.hrly.zoo<- zoo(merged.FONR_1.hrly$Liters, order.by=merged.FONR_1.hrly[,1])

# Plot zoo object. Limited format but will allow for time series analysis and plotting using xts format
plot.zoo(merged.FONR_1.hrly.zoo[,2], xlab = "Time", ylab = "Fog", col = "mediumblue", lwd = 2) 

merged.FONR_1.hrly.xts <- as.xts(merged.FONR_1.hrly.zoo)

par(mfrow = c(1,1)) 

plot(merged.FONR_1.hrly.xts[,1], 
     main = 'Fog Bucket #1', 
     xlab = 'Date',
     ylab = 'Fog Water',  
     yaxis.right = FALSE,
     plot.type = 's',
     col=rainbow(n=1, alpha = .5),
     grid.ticks.on = 'hours', 
     major.ticks = 'hours', 
     grid.col = 'lightgrey',
     at = 'pretty')

# Plotting a subset of observations

merged.FONR_1.hrly.subset.xts <- merged.FONR_1.hrly.xts["2020-04-04 00:00 /2020-04-07 00:00"] # Subsetting a range of dates

par(mfrow = c(1,1)) 

plot(merged.FONR_1.hrly.subset.xts[,1], 
     main = 'Fog Bucket #1', 
     xlab = 'Date',
     ylab = 'Fog Water (Liters)', 
     yaxis.right = FALSE,
     plot.type = 's',
     col=rainbow(n=1, alpha = .5),
     grid.ticks.on = 'hours', 
     major.ticks = 'hours', 
     grid.col = 'lightgrey',
     at = 'pretty')











