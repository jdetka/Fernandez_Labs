rm(list=ls()); graphics.off(); options("stringsAsFactors" = FALSE)
setwd("E:/PSM")
library(zoo); library(xts); library(readxl)
bucket.82.twingates <- read_excel("E:/PSM/Twin Gates_20190701_20200617.xlsx",skip=1)
bucket.82.twingates.hrly <- aggregate(bucket.82.twingates$'Events (State)', list(hour=cut(bucket.82.twingates$Date, "1 hour")), sum)
bucket.82.twingates.daily <- aggregate(bucket.82.twingates$'Events (State)', list(hour=cut(bucket.82.twingates$Date, "24 hour")), sum)
colnames(bucket.82.twingates.hrly) <- c("Date", "Total_Hourly_Events")
bucket.82.twingates.hrly$Date = as.POSIXct(as.factor(bucket.82.twingates.hrly$Date))
date.span = seq(as.POSIXct(min(bucket.82.twingates.hrly$Date)), 
            as.POSIXct(max(bucket.82.twingates.hrly$Date)),
            by = "1 hour")
all_dates = data.frame(Date = date.span)
merged.bucket.82.hourly = merge(all_dates, bucket.82.twingates.hrly, by = "Date", all.x = TRUE)
merged.bucket.82.hourly[is.na(merged.bucket.82.hourly)] <- 0
summary(merged.bucket.82.hourly$Total_Hourly_Events)
View(merged.bucket.82.hourly)