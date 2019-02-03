library(reshape2)
## Included this line during testing. 
##setwd("/Users/nithyashetty/Documents/Career_Advancement/Course_3_Getting_Cleaning_Data/Peer_Graded_Assignment")
fname <- "getdata_dataset.zip"

## Step 1 : Get source data
## Step 1.1 Download the file
## Step 1.2 Unzip the file
if (!file.exists(fname)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, fname, method="curl")
  unzip(fname) 
  }  

## Step 2:Initialize the metadata
actLbl <- read.table("UCI HAR Dataset/activity_labels.txt")
actLbl[,2] <- as.character(actLbl[,2])
ftr <- read.table("UCI HAR Dataset/features.txt")
ftr[,2] <- as.character(ftr[,2])

## Step 3:Extract Relevant data only
ftrW <- grep(".*mean.*|.*std.*", ftr[,2])
ftrW.names <- ftr[ftrW,2]
ftrW.names = gsub('-mean', 'Mean', ftrW.names)
ftrW.names = gsub('-std', 'Std', ftrW.names)
ftrW.names <- gsub('[-()]', '', ftrW.names)


## Step 4: Load the data
tData <- read.table("UCI HAR Dataset/train/X_train.txt")[ftrW]
tAct <- read.table("UCI HAR Dataset/train/Y_train.txt")
tSub <- read.table("UCI HAR Dataset/train/subject_train.txt")
tData <- cbind(tSub, tAct, tData)

tstData <- read.table("UCI HAR Dataset/test/X_test.txt")[ftrW]
tstAct <- read.table("UCI HAR Dataset/test/Y_test.txt")
tstSub <- read.table("UCI HAR Dataset/test/subject_test.txt")
tstData <- cbind(tstSub, tstAct, tstData)

## Step 5: merging
FullData <- rbind(tData, tstData)
colnames(FullData) <- c("subject", "activity", ftrW.names)

# Step 6: convert to factors
FullData$activity <- factor(FullData$activity, levels = actLbl[,1], labels = actLbl[,2])
FullData$subject <- as.factor(FullData$subject)

FullData.melted <- melt(FullData, id = c("subject", "activity"))
FullData.mean <- dcast(FullData.melted, subject + activity ~ variable, mean)

write.table(FullData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
