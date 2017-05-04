# plot3.R
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen decreases in emissions from 1999-2008 for 
# Baltimore City? Which have seen increases in emissions from 1999-2008? Use the ggplot2 
# plotting system to make a plot answer this question.

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
png("plot3.png", width=number.add.width, height=number.add.height)

require(ggplot2)
require(dplyr)

# Group total NEI emissions per year:
baltcitymary.emissions.byyear<-summarise(group_by(filter(NEI, fips == "24510"), year,type), Emissions=sum(Emissions))

# clrs <- c("red", "green", "blue", "yellow")
ggplot(baltcitymary.emissions.byyear, aes(x=factor(year), y=Emissions, fill=type,label = round(Emissions,2))) +
        geom_bar(stat="identity") +
        #geom_bar(position = 'dodge')+
        facet_grid(. ~ type) +
        xlab("year") +
        ylab(expression("total PM"[2.5]*" emission in tons")) +
        ggtitle(expression("PM"[2.5]*paste(" emissions in Baltimore ",
                                           "City by various source types", sep="")))+
        geom_label(aes(fill = type), colour = "white", fontface = "bold")

dev.off()
