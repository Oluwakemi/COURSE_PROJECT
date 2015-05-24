GETTING AND CLEANING DATA COURSE PROJECT

GOAL

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . 
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on 
a series of yes/no questions related to the project. 

TASK TO BE COMPLETED
You will be required to submit:
1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  
4) create one R script called run_analysis.R that does the following. 
   a)Merges the training and the test sets to create one data set.
   b)Extracts only the measurements on the mean and standard deviation for each measurement. 
   c)Uses descriptive activity names to name the activities in the data set
   d)Appropriately labels the data set with descriptive variable names. 
   e)From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

DATA FOR PROJECT:
the Data for the project can be found at: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


DATA CLEANING PROCESS
the following documents are outputed from the datacleaning process:
1)run_analysis.R which contains the rcode for the data cleaning process. this file assumes the data for the project was downloaded from 
"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" and unzipped in the working directory (unziped folder =UCI HAR Dataset).
2)CodeBook.md which contains details on the data and the respective variables produced as well as giving information on the transformations
 perfomed in producing the tidy data.
3)Tidydata.txt which contains the final tidy data produced.
4)README.md which gives a step by step procedure to produce the tidy data.


STEP BY STEP

LIBRARIES USED

library(data.table)
library(dplyr)


STEP 1
- download and unzip data into working directory.

if (!file.exists("samsungdata.zip")) {
  
  zipUrl <-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file (zipUrl, destfile= "./samsungdata.zip", mode="wb")
  downloaddate <- date()
  unzip("samsungdata.zip")
}

# Both training and test data sets are split up into subject, activity and features.

- load the train datasets into R (x_train,y_train,subject_train)
- load the test datasets into R (x_test,y_test,subject_test)
- merge the tests and train sets using rbin() to merge files having the same number of columns and referring to the same entities.

Features <- rbind(x_train,x_test) 
Activity <- rbind(y_train,y_test)  
Subject <- rbind(subject_train,subject_test)



STEP 2
-Extract only the measurements on the mean and standard deviation for each measurement.
## Names for the elements variable 'features' come from the file 'feature.txt'

featureNames <- read.table("UCI HAR Dataset/features.txt") #load the features.txt file into R. 
Col_MeanStd <- grep("mean\\(\\)|std\\(\\)", featureNames[, 2])
Features <- Features[, Col_MeanStd]
names(Features) <- featureNames[Col_MeanStd, 2]
dim(Features)
[1] 10299    66

##Excluded are the variables meanFreq(), gravityMean, tBodyAccMean, tBodyAccJerkMean, tBodyGyroMean, tBodyGyroJerkMean as these represent derivations of angle data 
and do not have corresponding standard deviation measurements.



STEP 3
Use descriptive activity names to name the activities in the data set.
# activities in the activity dataset have been coded with numbers but their actual labels are found in the 'activity.txt' file
# load the file and and replace the code numbers with actual activity labels.

activityNames <- read.table("UCI HAR Dataset/activity_labels.txt") 
Activity<- activityNames[Activity[,1],2]
str(Activity)


# Combine all three data sets using cbind()

wholedata <- cbind(Subject,Activity,Features)
dim(wholedata)
[1] 10299    68



STEP 4
Appropriately label the data set with descriptive variable names.
# examine the variable names in wholedata to see where to effect changes.

names(wholedata)

# assign decsriptive variable names to the data by replacing:
# 't' with Time; 'Acc' with Accelerometer; 'Gyro' with Gyroscope; 'Mag' with Magnitude;
# 'BodyBody' with Body; '-mean()' with Mean; '-std()' with STD; 'f' with Frequency.



STEP 5
From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
tidy <- group_by(wholedata,Subject, Activity)
tidydata<- summarise_each(tidy, funs(mean))
View(tidydata)
write.table(Data2, file = "Tidydata.txt",row.name=FALSE)


###CodeBook.md was autogenerated from RStudio using the R Markdown icon under File (Knit PDF was specified).
