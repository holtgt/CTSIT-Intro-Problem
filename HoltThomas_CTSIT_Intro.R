library(lubridate)
library(flextable)

sheet1 <- read.csv("C:/Users/holtg/Desktop/sheet1.csv")

#Make dates into better format
sheet1$BIRTH.DATE <- mdy(sheet1$BIRTH.DATE)
sheet1$DEATH.DATE <- mdy(sheet1$DEATH.DATE)

#Add birth year column
sheet1$year_of_birth <- year(sheet1$BIRTH.DATE)

#Add lived years column
sheet1$lived_years<- as.numeric(interval(sheet1$BIRTH.DATE, sheet1$DEATH.DATE), "years")

#add lived Months Column
sheet1$lived_months<- as.numeric(interval(sheet1$BIRTH.DATE, sheet1$DEATH.DATE), "months")

#add lived days Column
sheet1$lived_days<- as.numeric(interval(sheet1$BIRTH.DATE, sheet1$DEATH.DATE), "days")


#output tables of longest & shortest lived
time_lived <- sheet1[order(sheet1$lived_days),c("PRESIDENT","lived_days")]
time_lived <- na.omit(time_lived)

time_lived_desc <- sheet1[order(-sheet1$lived_days),c("PRESIDENT","lived_days")]
time_lived_desc <- na.omit(time_lived_desc)

longest <- as.data.frame(time_lived_desc[1:10,])

youngest <- as.data.frame(time_lived[1:10,])


#find other metrics
meanDays <- mean(time_lived$lived_days)

medianDays <- median(time_lived$lived_days)

modeDays <- mode(time_lived$lived_days)

maxDays <- max(time_lived$lived_days)

minDays <- min(time_lived$lived_days)

sdDays <- sd(time_lived$lived_days)

#output tables
metric<- data.frame(Name=c("Mean","Median", "Maximum","Minimum","St. Deviation"),"Days Lived"=c(meanDays,medianDays,maxDays,minDays, sdDays))
metrics<- flextable(metric)
set_header_labels(metrics, A="Name", B="Days Lived")
save_as_image(metrics, path="metrics.png")

long <- flextable(longest)
long <- set_caption(long, "Longest Lived Presidents")
save_as_image(long, path="long.png")



young <- flextable(youngest)
young <- set_caption(young, "Shortest Lived Presidents")
save_as_image(young, path="young.png")


dev.off()

#output plot
png("plot.png")
hist(time_lived$lived_days, main= "Lifespans of Deceased Presidents", xlab = 'Days Lived')
dev.off()
