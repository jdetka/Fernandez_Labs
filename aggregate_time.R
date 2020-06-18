#### Makes a pretend dataset of fog bucket tips in a few days. 
set.seed(42)
date = seq(as.POSIXct("2017-09-01 12:00:00:00"), as.POSIXct("2017-09-03 12:00:00:00"), by = "123 mins") # Date sequence
data = sample(c(0,1), length(date), replace = TRUE) # Assign a random 1 or 0. 1 = a tip. 
df = data.frame(as.POSIXct(date), data)             # make a dataframe
df.tips.only = df[df$data == 1,]                    # Extract only the tips. This is what the data looks like from real buckets. 
colnames(df.tips.only) = c("date", "data"); df.tips.only # Rename the columns. 

# Aggregating irregular data with missing date times. 

df.tips.daily <- aggregate(df.tips.only$data, list(hour=cut(df.tips.only$date, "24 hour")), sum)
colnames(df.tips.daily) = c("date", "tot.tips")
df.tips.daily

