##
##  Plot 3: Create a stacked time series plot of Energy Sub Metering 1,2, and 3.
##

##
##  If the data file is not present in the local directory, download the source file and unzip it.
##
rd.http  <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
rd.zip   <- "./household_power_consumption.zip"
rd.file  <- "./household_power_consumption.txt"
if (!file.exists(rd.file)) {
    download.file(rd.http,dest=rd.zip,method="curl")
    unzip(rd.zip)
}

##
##  Load the relevant data.  The grep function is used to extract only data for the specified
##  dates.  That data is then read into the variable household.data.  A second read is performed
##  of the first row of the file to extract the column names.
##
##  Windows users can replace "grep ^[12]/2/2007" with "findstr /B /R ^[1-2]/2/2007"
##
rd.pipe.cmd     <- paste("grep ^[12]/2/2007",rd.file)
household.data  <- read.table(pipe(rd.pipe.cmd),header=FALSE,sep=';',na.strings="?")
household.names <- names(read.table(rd.file,header=TRUE,sep=";",nrows=1))
colnames(household.data) <- household.names

##
## The date and time character strings are converted to an R date object.  Date and time are first
## concatenated into a single string.  The string is then converted to a date object and added
## to the household.data table.
##
date.time.string <- paste(household.data$Date,household.data$Time)
date.time        <- strptime(date.time.string,"%d/%m/%Y %H:%M:%S")
household.data   <- cbind(household.data,date.time)

##
## Plot the line graph on a PNG device 480x480 pixels. Suppress printing of the main title and
## x-axis label.  
##
png("plot3.png",width=480,height=480,units="px")
p.main <- NA
p.xlab <- NA
p.ylab <- "Energy sub metering"
p.type <- "l"

with(household.data,plot(date.time,Sub_metering_1,main=p.main,xlab=p.xlab,ylab=p.ylab,type=p.type))
with(household.data,lines(date.time,Sub_metering_2,col="red"))
with(household.data,lines(date.time,Sub_metering_3,col="blue"))
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),col=c("black","red","blue"))

dev.off()