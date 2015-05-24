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

x_train<- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

x_test<- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)


# Both training and test data sets are split up into subject, activity and features.
## Merge the respective datasets in training and test sets to create one data set corresponding to training, activity and features.

Features <- rbind(x_train,x_test) #values for the variable 'features' come from the datasets x_train and x_test.
Activity <- rbind(y_train,y_test)  #values for the variable 'activity' come from the datasets y_train and y_test.
Subject <- rbind(subject_train,subject_test)  #values for the variable 'subject' come the datasets subject_train and subject_test.



# STEP 2: Extract only the measurements on the mean and standard deviation for each measurement.
## Names for the elements variable 'features' come from the file 'feature.txt'

featureNames <- read.table("UCI HAR Dataset/features.txt") #load the features.txt file into R. 

## subset out only columns with measurements mean() and std() featuredata end name columns accordingly.

Col_MeanStd <- grep("mean\\(\\)|std\\(\\)", featureNames[, 2])
Features <- Features[, Col_MeanStd]
names(Features) <- featureNames[Col_MeanStd, 2]
str(Features)


# STEP 3: Use descriptive activity names to name the activities in the data set.
## activities IN the activity dataset have been coded with numbers but their actual labels are found in the 'activity.txt' file
## load the file and and replace the code numbers with actual activity labels.

activityNames <- read.table("UCI HAR Dataset/activity_labels.txt") #Names for the variable 'activity' come from the file 'activity_labels.txt'
Activity<- activityNames[Activity[,1],2]
str(Activity)

names(Subject) <-"Subject"  ###Assign correct column name for 'Subject'

## Combine all three data sets
wholedata <- cbind(Subject,Activity,Features)
str(wholedata)


# STEP 4:Appropriately label the data set with descriptive variable names.
## examine the variable names in wholedata to see where to effect changes.

names(wholedata)

## assign decsriptive variable names to the data by replacing:
## 't' with Time; 'Acc' with Accelerometer; 'Gyro' with Gyroscope; 'Mag' with Magnitude;
## 'BodyBody' with Body; '-mean()' with Mean; '-std()' with STD; 'f' with Frequency.

names(wholedata)<-gsub("^t", "Time", names(wholedata))
names(wholedata)<-gsub("^f", "Frequency", names(wholedata))
names(wholedata)<-gsub("Acc", "Accelerometer", names(wholedata))
names(wholedata)<-gsub("Gyro", "Gyroscope", names(wholedata))
names(wholedata)<-gsub("Mag", "Magnitude", names(wholedata))
names(wholedata)<-gsub("BodyBody", "Body", names(wholedata))
names(wholedata)<-gsub("-mean()", "Mean", names(wholedata), ignore.case = TRUE)
names(wholedata)<-gsub("-std()", "STD", names(wholedata), ignore.case = TRUE)

#examine the updated data
names(wholedata)


#STEP 5:From the data set in step 4, create a second, independent tidy data set with 
#the average of each variable for each activity and each subject.

library(dplyr)
tidy <- group_by(wholedata,Subject, Activity)
tidydata<- summarise_each(tidy, funs(mean))
View(tidydata)
write.table(tidydata, file = "Tidydata.txt",row.name=FALSE)




##OR (personal learnings)
#tidy <- aggregate(. ~Subject + Activity, wholedata, mean)
#tidydata <- tidy[order(tidy$Subject,tidy$Activity),]
#write.table(tidydata, file = "Tidydata.txt", row.names = FALSE)



