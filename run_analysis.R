## Getting and Cleaning Data
## Final Project
## Huiyu Zhang

rm(list=ls())
setwd("~/Desktop/UCI HAR Dataset")
# read training data
trainSubject<- read.table('./train/subject_train.txt',header = FALSE)
trainX<- read.table('./train/X_train.txt',header = FALSE)
trainY<- read.table('./train/y_train.txt',header=FALSE)
# read testing data
testSubject<- read.table('./test/subject_test.txt',header = FALSE)
testX<- read.table('./test/X_test.txt',header = FALSE)
testY<- read.table('./test/y_test.txt',header = FALSE)

features<- read.table('features.txt',as.is = TRUE)
activities<- read.table('activity_labels.txt')
colnames(activities)<- c("activityID","activityLabel")

# Merge the training and test sets to create one data set
trainData<- cbind(trainSubject,trainX,trainY)
testData<- cbind(testSubject,testX,testY)
allData<- rbind(trainData,testData)
colnames(allData)<- c("subject",features[,2],"activity")

# Extracts only the measurements on the mean and standard deviation for each measurement
columnID<- grepl("subject|activity|mean|std",colnames(allData))
allData<- allData[, columnID]

# Uses descriptive activity names to name the activities in the data set
allData$activity<- factor(allData$activity,levels = activities[,1], labels = activities[,2])

# Appropriately labels the data set with descriptive variable names
colName<- colnames(allData)
colName<- gsub("[\\(\\)-]", "", colName)
colName <- gsub("^f", "frequencyDomain", colName)
colName <- gsub("^t", "timeDomain", colName)
colName <- gsub("Acc", "Accelerometer", colName)
colName <- gsub("Gyro", "Gyroscope", colName)
colName <- gsub("Mag", "Magnitude", colName)
colName <- gsub("Freq", "Frequency", colName)
colName <- gsub("mean", "Mean", colName)
colName <- gsub("std", "StandardDeviation", colName)
colName<- gsub("BodyBody","Body",colName)
colnames(allData)<- colName

# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
library(plyr)
tidyData<- ddply(allData,c("subject","activity"),numcolwise(mean))
write.table(tidyData,file = "tidydata.txt",row.names = FALSE )
