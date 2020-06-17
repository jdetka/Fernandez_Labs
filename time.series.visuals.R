#### Visualizing Time Series Data ####

#### Install necessary packages #### 
install.packages('zoo', 'xts', dependencies = TRUE)
library(zoo); library(xts)

#### Import the data. ####
# File path needs to change or use read.csv(file.choose()) and navigate to the file. 
fonr_10min <- read.csv("C:/Users/jdetk/Desktop/UC-FONR-10min-Fog_Met_190718-190914.csv") #Example PC path
fonr_10min <- read.csv("/Users/JD/Desktop/UC-FONR-10min-Fog_Met_190718-190914.csv")      #Example Mac path

# Convert date time to a more useful format for more info on date times read http://biostat.mc.vanderbilt.edu/wiki/pub/Main/ColeBeck/datestimes.pdf
fonr_10min$date <- as.POSIXct(as.factor(fonr_10min$Date_Time), format="%m/%d/%Y %H:%M")

fonr_10min <- fonr_10min[,-c(1)] # Delete old time format from dataframe fonr_10min

#### Fill missing observations ####
# Fills with missing data values as NA's and missing dates by first making a vector sequence of dates. 
date.span = seq(as.POSIXct(min(fonr_10min$date)), as.POSIXct(max(fonr_10min$date)), by = "10 mins")
all_dates <- data.frame(date = date.span) # make it a data.frame 
## Use the merge function to combine date.span with incomplete spans in fonr_10min$Date_Time_Coor 
fonr_10min_NAs <- merge(all_dates, fonr_10min, by = "date",  all.x = TRUE)

#### Visualizing time series #### 

# Convert to a zoo object. Two ways to order by date. 
fonr.zoo<- zoo(fonr_10min_NAs[,2:26], order.by=fonr_10min_NAs[,1])
fonr.zoo<- zoo(fonr_10min_NAs[,2:26], as.POSIXct(date.span))
# Plot zoo object. Limited. 
plot.zoo(fonr.zoo[,2], xlab = "Time", ylab = "Fog", col = "mediumblue", lwd = 2) 
# Convert to xts object. Lots more options. 
fonr.xts <- as.xts(fonr.zoo); head(fonr.xts); dim(fonr.xts)

fonr.sub.xts <- fonr.xts["2019-08-01 00:00 /2019-08-04 00:00"] # Subsetting a range of dates

par(mfrow = c(1,1)) 

plot(fonr.sub.xts[,1], 
     main = 'Fog Bucket #87', 
     xlab = 'Date',
     ylab = 'Fog Water', 
     yaxis.right = FALSE,
     plot.type = 's',
     col=rainbow(n=1, alpha = .5),
     grid.ticks.on = 'hours', 
     major.ticks = 'hours', 
     grid.col = 'lightgrey',
     at = 'pretty')

## Add legend to graph using same color schema
addLegend("topright", 
          legend.names=c("Bucket #87"),
          col=rainbow(n=1, alpha = .5), 
          lty=c(1), lwd=c(2),
          ncol=1, bg="white", bty="o")

title(main = 'Title', xlab = 'Date', ylab = 'Fog') #Add Axes labels - buggy still. 

#### Can you plot average air temperature? #### 
### Can you plot fog bucket #87 and average air temperature in split graphic layout? ####


#### Multiple Time Series in a single plot####
par(mfrow = c(1,1))

plot(fonr.sub.xts[,1:8], 
     main = 'Fog', 
     xlab = 'Date',
     ylab = 'Fog Water', 
     yaxis.right = FALSE,
     plot.type = 's',
     col=rainbow(n=6, alpha = .5),
     grid.ticks.on = 'hours', 
     major.ticks = 'hours', 
     grid.col = 'lightgrey',
     at = 'pretty'); 

## Add legend to graph using same color schema
addLegend("topright", 
          legend.names=c("87", "88", "89", "90", "91", "92", "93", "94"),
          col=rainbow(n=6, alpha = .5), 
          lty=c(1,1,1,1,1,1,1), lwd=c(2,2,2,2,2,2,2),
          ncol=1, bg="white", bty="o")

title(main = 'Title', xlab = 'Date', ylab = 'Fog') # Add Title




#### Numeric summaries - Aggregating data with xts #### 

apply.daily(fonr.sub.xts[,1], sum) 

apply.daily(fonr.sub.xts[,14], mean); apply.daily(fonr.sub.xts[,14], sd)

