# plot6.R

# 6. Compare emissions from motor vehicle sources in Baltimore City with emissions from 
# motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has # seen greater changes over time in motor vehicle emissions?

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
png("plot6.png", width=number.add.width, height=number.add.height)

require(dplyr)
baltcitymary.emissions<-summarise(group_by(filter(NEI, fips == "24510"& type == 'ON-ROAD'), year), Emissions=sum(Emissions))
losangelscal.emissions<-summarise(group_by(filter(NEI, fips == "06037"& type == 'ON-ROAD'), year), Emissions=sum(Emissions))

baltcitymary.emissions$County <- "Baltimore City, MD"
losangelscal.emissions$County <- "Los Angeles County, CA"
both.emissions <- rbind(baltcitymary.emissions, losangelscal.emissions)

require(ggplot2)
ggplot(both.emissions, aes(x=factor(year), y=Emissions, fill=County,label = round(Emissions,2))) +
        geom_bar(stat="identity") + 
        facet_grid(County~., scales="free") +
        ylab(expression("total PM"[2.5]*" emissions in tons")) + 
        xlab("year") +
        ggtitle(expression("Motor vehicle emission variation in Baltimore and Los Angeles in tons"))+
        geom_label(aes(fill = County),colour = "white", fontface = "bold")

dev.off()
