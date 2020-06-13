## Made up dates and random data. 
date = seq(as.POSIXct("2017-09-01 12:00:00:00"), as.POSIXct("2017-09-03 12:00:00:00"), by = "mins")
data = rnorm(length(date))  

df = data.frame(as.POSIXct(date), data)

## Make swiss cheese out of your data. Remove 150 data points randomly.
## Note different lengths of start and end points. 
swiss_cheese_data <- df[sort(sample(nrow(df), 150)), ]
colnames(swiss_cheese_data) = c("date", "data")

head(swiss_cheese_data)


all_dates <- seq(as.POSIXct(min(swiss_cheese_data$date)), 
                 as.POSIXct(max(swiss_cheese_data$date)), 
                 by = "mins")
all_dates <- data.frame(date = all_dates)


## Use merge function to combine all_dates with incomplete spans in swiss_cheese_data. 
data_w_mayoNAs <- merge(all_dates, swiss_cheese_data, by = "date",  all.x = TRUE)
