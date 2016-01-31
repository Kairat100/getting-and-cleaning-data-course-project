# first download the zip file:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# and unzip it to the working directory

# path to folder UCI HAR Dataset
path_rf <- file.path("./UCI HAR Dataset")

# list of all files if needed
#list.files(path_rf, recursive=TRUE)

#
# Step 1: Merges the training and the test sets to create one data set.
#

# Read data from the files into the variables 
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

# Concatenate the data tables by rows
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

# set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

# Merge columns to get the data frame Data for all data
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#
# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
#

# Subset Name of Features by measurements on the mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

# Subset the data frame Data to extractedData by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
extractedData<-subset(Data,select=selectedNames)

#
# Step 3: Uses descriptive activity names to name the activities in the data set
#

# Read descriptive activity names from ???activity_labels.txt???
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

extractedData$activity <- as.character(extractedData$activity)
for (i in 1:6){
       extractedData$activity[extractedData$activity == i] <- as.character(activityLabels[i,2])
}
extractedData$activity <- as.factor(extractedData$activity)

#
# Step 4: Appropriately labels the data set with descriptive variable names.
#

#In the former part, variables activity and subject and names of the activities 
#have been labelled using descriptive names.In this part, Names of Feteatures will 
#labelled using descriptive variable names.

#prefix t is replaced by time
#Acc is replaced by Accelerometer
#Gyro is replaced by Gyroscope
#prefix f is replaced by frequency
#Mag is replaced by Magnitude
#BodyBody is replaced by Body

names(extractedData)<-gsub("^t", "time", names(extractedData))
names(extractedData)<-gsub("^f", "frequency", names(extractedData))
names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))

#
# Step 5: From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.
#

library(plyr)
extractedData2<-aggregate(. ~subject + activity, extractedData, mean)
extractedData2<-extractedData2[order(extractedData2$subject,extractedData2$activity),]
write.table(extractedData2, file = "tidyextractedData.txt",row.name=FALSE)



# Prouduce Codebook

library(knitr)
knit2html("CodeBook.md")
