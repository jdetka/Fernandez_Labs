#### Aggregating data observations ####


#### Makes a pretend dataset of fog bucket tips. 
set.seed(42)
date = seq(as.POSIXct("2017-09-01 12:00:00:00"), as.POSIXct("2017-09-03 12:00:00:00"), by = "123 mins")
data = sample(c(0,1), length(date), replace = TRUE)
df = data.frame(as.POSIXct(date), data)
df.tips.only = df[df$data == 1,]
colnames(df.tips.only) = c("date", "data")
df.tips.only

str(df.tips.only$date)

# Aggregating data

df.tips.daily <- aggregate(df.tips.only$data, list(hour=cut(df.tips.only$date, "24 hour")), sum)
colnames(df.tips.daily) = c("date", "tot.tips")

df.tips.daily


# Now with real fog data! 
install.packages("readxl", dependencies = TRUE); library("readxl")  # Install packages to import xlsx into R
bucket.82.twingates <- read_excel("C:/Users/jdetk/Desktop/Twin Gates_20190701_20200617.xlsx",skip=1)  # Import, skip first line 

# Aggregate data hourly as sum of events. 
bucket.82.twingates <- aggregate(bucket.82.twingates$'Events (State)', list(hour=cut(bucket.82.twingates$Date, "1 hour")), sum)

# Rename the columns 
colnames(bucket.82.twingates) <- c("Date", "Total_Hourly_Events")

# Optional export the data as a csv. 
write.csv(bucket.82.twingates,"C:/Users/jdetk/Desktop/bucket.82.twingates.hourly.csv", row.names = FALSE)

# Optional: View data 
View(bucket.82.twingates)








