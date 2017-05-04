# plot1.R
# 1.Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.

# set working directory
setwd("D:/Data Science John Hopkins/Exploratory Data Analysis/Project2")

# Source and Load data sets for independent run of the code
# activity monitoring data
get.data.project <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(get.data.project, destfile="exdata_data_NEI_data.zip", method="auto")

# make sure the site is live, if it is not live stop function terminate the program
check.url <- file(get.data.project,"r")
if (!isOpen(check.url)) {
        stop(paste("There's a problem with the data:",geterrmessage()))
}

# zipfile.data is the variable to keep the *.zip file
zipfile.data = "exdata_data_NEI_data.zip"

# make sure the data in the working directory if not download the zip file into the to zipfile.data and unzip the zipfile.data
if(!file.exists(zipfile.data)) {        
        unzip(zipfile="exdata_data_NEI_data.zip")
} 
path_rf <- file.path("D:/Data Science John Hopkins/Exploratory Data Analysis/Project2" , "exdata_data_NEI_data")
files<-list.files(path_rf, recursive=TRUE)
files

# Read data files
# read national emissions data
NEI <- readRDS("summarySCC_PM25.rds")
#read source code classification data
SCC <- readRDS("Source_Classification_Code.rds")

# Store plot as .PNG file
png("plot1.png", width=number.add.width, height=number.add.height)

# Group total NEI emissions per year:
total.emissions <- summarise(group_by(NEI, year), Emissions=sum(Emissions))
clrs <- c("red", "green", "blue", "yellow")
x1<-barplot(height=total.emissions$Emissions/1000, names.arg=total.emissions$year,
            xlab="years", ylab=expression('total PM'[2.5]*' emission in kilotons'),ylim=c(0,8000),
            main=expression('Total PM'[2.5]*' emissions at various years in kilotons'),col=clrs)

## Add text at top of bars
text(x = x1, y = round(total.emissions$Emissions/1000,2), label = round(total.emissions$Emissions/1000,2), pos = 3, cex = 0.8, col = "black")

dev.off()
