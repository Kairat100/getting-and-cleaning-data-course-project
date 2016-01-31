# Getting and cleaning data course project #

Describtion of run_analysis.R script.

Download the zip file: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzip it to the working directory where run_analysis.R is located

Script is diveded into five part, one for each step in assignment:
 1. Merges the training and the test sets to create one data set.
 2. Extracts only the measurements on the mean and standard deviation for each measurement.
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive activity names.
 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## how to run the analysis

In your R enviroment (in the same folder where the data files are), load the script:

```
source('run_analysis.R')
```

The end result will be a file called `tidyextractedData.txt'` in the working directory.
