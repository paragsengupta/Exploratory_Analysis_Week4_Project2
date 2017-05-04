# plot4.R
#4. Across the United States, how have emissions from coal combustion-related sources  
# changed from 1999-2008?

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
png("plot4.png", width=number.add.width, height=number.add.height)

combustion.coal <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)
combustion.coal.sources <- SCC[combustion.coal,]

# Find emissions from coal combustion-related sources
emissions.coal.combustion <- NEI[(NEI$SCC %in% combustion.coal.sources$SCC), ]
require(dplyr)
emissions.coal.related <- summarise(group_by(emissions.coal.combustion, year), Emissions=sum(Emissions))
require(ggplot2)
ggplot(emissions.coal.related, aes(x=factor(year), y=Emissions/1000,fill=year, label = round(Emissions/1000,2))) +
        geom_bar(stat="identity") +
        #geom_bar(position = 'dodge')+
        # facet_grid(. ~ year) +
        xlab("year") +
        ylab(expression("total PM"[2.5]*" emissions in kilotons")) +
        ggtitle("Emissions from coal combustion-related sources in kilotons")+
        geom_label(aes(fill = year),colour = "white", fontface = "bold")

dev.off()
