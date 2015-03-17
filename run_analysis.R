# set working directory
workFolder <- "~/Documents/Courses/Getting_and_Cleaning_Data_JHU"
setwd(workFolder)

# create a data folder
if (!file.exists("data")) {
    dir.create("data")
}

# download the dataset.zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/Dataset.zip", method="curl")
list.files("./data")

# record the date for downloading
dateDownloaded <- date()
dateDownloaded

# unzip zipped data in the same directory
unzip("./data/Dataset.zip", exdir="./data")

# list all files in dataset folder with absolute file path
files <- list.files("./data/UCI HAR Dataset/", recursive=TRUE)
files.p <- file.path(workFolder, "data/UCI HAR Dataset", files)

# read in train and test data sets
# idx is the index for X_test/train, y_test/train, 
# and subjects_test/train txt files
idx <- c(14:16,26:28)
file.list <- list()
for (i in idx) {
    file.list[[files[i]]] <- read.table(files.p[[i]])
}
# checking files imported into R
names(file.list)
summary(file.list)
sapply(file.list, dim)

# combine subject, y, X for test and train data sets
train <- do.call(cbind, file.list[c(4,6,5)])
test <- do.call(cbind, file.list[c(1,3,2)])
str(train)
str(test)

# get feature names from files
names <- read.table(files.p[[3]])

# change colnames for train and test
colnames(train) <- c("subject", "activity", as.character(names[,2]))
colnames(test) <- c("subject", "activity", as.character(names[,2]))

# merge test and train data set, and introduce a new variable
# called datasource, with levels of train or test
total <- rbind(train, test)
total$datasource <- rep(c("train","test"), c(nrow(train),nrow(test)))
str(total)

# extract variables are mean or std
colname <- colnames(total)
idx2 <- grep("mean[(]|std[(]", colname)
total2 <- total[,c(1,2,idx2,564)]
str(total2)
dim(total2)

# melt total to have various measurements in one column called value
# different measurements names are in another column called variable
total.m <- melt(total2, id=c(1,2,69))
str(total.m)

# separate variable into 3 columns to have infos about measurement names
# , summary statistics and coordinates
require(tidyr)
total.m2 <- total.m %>% separate(variable, c("measure","summaryStat","coordinate"))
str(total.m2)

# put activity labels
activityName <- read.table(files.p[[1]])
activityName <- activityName[,2]
total.m2$activity <- factor(total.m2$activity, labels=activityName)

# summarizing data 
require(dplyr)
str(total.m2)
total.summarized <- total.m2 %>% group_by(subject,activity,measure,summaryStat, coordinate) %>% summarise(mean=mean(value))
total.summarized$coordinate
write.table(total.summarized,"summarized.txt",row.names=FALSE)

# plotting
require(ggplot2)
p <- ggplot(total.summarized, aes(x=subject, y=mean))
p + geom_point(aes(colour=coordinate)) + facet_wrap(summaryStat ~ activity,nrow=6)
ggsave("plot.pdf", width=12, height=8, units="in")
