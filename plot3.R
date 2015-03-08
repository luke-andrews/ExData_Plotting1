## Date: 7-Mar-2015 ##
# Objective: Exploratory Data Analysis on sample data from UCI ML Repository
# Steps Taken
# 1. Download File & Unzip
# 2. Read in raw data
# 3. Format date so we can subset to just the data we need
# 4. Format remaining columns within subset
# 5. Produce Plot

## 1. DOWNLOAD FILE AN UNZIP ##
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","power_consumption.zip")
unzip("power_consumption.zip")

## 2. READ IN RAW DATA AND PREPARE FOR PROCESSING ##
library(data.table) # load library to use fread
raw_data <- fread("household_power_consumption.txt",na.strings = "?")

## 3. FORMAT DATE AND THEN SUBSET TO JUST WHAT DATA WE NEED, REMOVE OLD DATA
raw_data$Date <- as.Date(raw_data$Date,format = "%d/%m/%Y")
data1 <- subset(raw_data, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
rm(raw_data)

## 4. FORMAT OTHER COLUMNS NOW DATASET IS NICE & SMALL

# 4.1 Firstly, easier to work with date/timestamp so data is continous.
#     Easy way is to concatenate the two columns together with paste
data1$Datetime <- paste(as.Date(data1$Date), data1$Time)
data1$Datetime <- as.POSIXct(data1$Datetime)

# 4.2 Convert rest of data to numeric
data1$Global_active_power <- as.numeric(data1$Global_active_power)
data1$Global_reactive_power <- as.numeric(data1$Global_reactive_power)
data1$Voltage <- as.numeric(data1$Voltage)
data1$Global_intensity <- as.numeric(data1$Global_intensity)
data1$Sub_metering_1 <- as.numeric(data1$Sub_metering_1)
data1$Sub_metering_2 <- as.numeric(data1$Sub_metering_2)
data1$Sub_metering_3 <- as.numeric(data1$Sub_metering_3)


## 5. MAKE THE PLOT
png(file = "plot3.png",width = 480,height = 480) 

#5.1 Create plot one line at a time
with(data1, {
        plot(Sub_metering_1~Datetime, type = "l",
             ylab = "Energy sub metering", xlab = "")
        lines(Sub_metering_2~Datetime, col = 'Red')
        lines(Sub_metering_3~Datetime, col = 'Blue')
})

# 5.2 Create legend in top right of plot
legend("topright", col=c("black", "red", "blue"), lty = 1,
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()

