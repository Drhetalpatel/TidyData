install.packages("dplyr")
library(dplyr)
filename <- "Coursera_upload.zip"
# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  
# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)
TD<- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
TD$code <- activities[TD$code, 2]
names(TD)[2] = "activity"
names(TD)<-gsub("Acc", "Accelerometer", names(TD))
names(TD)<-gsub("Gyro", "Gyroscope", names(TD))
names(TD)<-gsub("BodyBody", "Body", names(TD))
names(TD)<-gsub("Mag", "Magnitude", names(TD))
names(TD)<-gsub("^t", "Time", names(TD))
names(TD)<-gsub("^f", "Frequency", names(TD))
names(TD)<-gsub("tBody", "TimeBody", names(TD))
names(TD)<-gsub("-mean()", "Mean", names(TD), ignore.case = TRUE)
names(TD)<-gsub("-std()", "STD", names(TD), ignore.case = TRUE)
names(TD)<-gsub("-freq()", "Frequency", names(TD), ignore.case = TRUE)
names(TD)<-gsub("angle", "Angle", names(TD))
names(TD)<-gsub("gravity", "Gravity", names(TD))
FinalData <- TD %>%
  group_by(subject, activity) %>%
  summarise_all(function(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
str(FinalData)
FinalData
