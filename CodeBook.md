---
title: "CodeBook"
output: pdf_document
---

## GETTING AND CLEANING DATA COURSE PROJECT######
     
# Download and unzip file 

if (!file.exists("samsungdata.zip")) {
  
  zipUrl <-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file (zipUrl, destfile= "./samsungdata.zip", mode="wb")
  downloaddate <- date()
  unzip("samsungdata.zip")
}



## Libararies used: "data.table" and "dplyr"

library(data.table)


# STEP 1: Merge the training and the test sets to create one data set.

## load the test and train datasets into R
#The set of variables that were created from these sets are: 
x_train : contains the x_train set
y_train : contains the y_train set
subject_train : contains the subject_train set

x_test : contains the x_test set
y_test : contains the y_test set
subject_test : contains the subject_test set


# Both training and test data sets are split up into subject, activity and features.
## Merge the respective datasets in training and test sets to create one data set corresponding to training, activity and features.

Features : contains the x_test and x_train sets 
Activity : contains the y_test and y_train sets 
Subject  : contains the subject_test and subject_train sets 



# STEP 2: Extract only the measurements on the mean and standard deviation for each measurement.
## Names for the elements variable 'features' come from the file 'feature.txt'
## subset out only columns with measurements mean() and std() featuredata end name columns accordingly, using rbind().

featureNames: contains data from the features.txt.d.table("UCI HAR Dataset/features.txt") #load the features.txt file into R.
 
- Col_MeanStd: contains only the columns with mean() and std() measurements.
- The variable 'Features' is renamed using the appropriate names gotten from the features.txt file, stored in the variable 'featureNames'
- The variable 'Activity' is renamed using the appropriate names gotten from the activity.txt file, stored in the variable 'activityNames'
- The variable 'wholedata' stores the merge of all three datasets 'Subject', 'Activity' and 'Features'.

#The following column names in the variable 'wholedata' were modified:
-'t' with Time
-'Acc' with Accelerometer
-'Gyro' with Gyroscope
-'Mag' with Magnitude
-'BodyBody' with Body
-'-mean()' with Mean
-'-std()' with STD
-'f' with Frequency.

#The average of each variable for each activity and each subject was computed using dplyr and stored in the variable 'tidydata'.
- The final output data was stored in a text file called "Tidydata.txt" using write.table() using row.name=FALSE.

