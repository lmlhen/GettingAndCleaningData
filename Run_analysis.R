
# folder and filenames as constants to avoid typing problems ####
baseFolder <- 'UCI HAR Dataset'
trainFolder <- 'train'
testFolder <- 'test'
activityFilename <- 'activity_labels.txt'
featuresFilename <- 'features.txt'
trainSubjectFilename <- 'subject_train.txt'
trainLabelsFilename <- 'y_train.txt'
trainDataFilename <- 'X_train.txt'
testSubjectFilename <- 'subject_test.txt'
testLabelsFilename <- 'y_test.txt'
testDataFilename <- 'X_test.txt'

# path to read files ####
activityFilename <- file.path(baseFolder, activityFilename)
featuresFilename <- file.path(baseFolder, featuresFilename)
trainLabelsFilename <- file.path(baseFolder, trainFolder, trainLabelsFilename)
trainSubjectFilename <- file.path(baseFolder, trainFolder, trainSubjectFilename)
trainDataFilename <- file.path(baseFolder,  trainFolder, trainDataFilename)
testLabelsFilename <- file.path(baseFolder, testFolder, testLabelsFilename)
testSubjectFilename <- file.path(baseFolder, testFolder, testSubjectFilename)
testDataFilename <- file.path(baseFolder, testFolder, testDataFilename)

# Read files with proper names
activity <- read.table(activityFilename, col.names=c('Number', 'Activity'))
features <- read.table(featuresFilename, col.names=c('Number', 'Feature'))
testSubject <- read.table(testSubjectFilename, col.names=c('Subject'))
testLabels <- read.table(testLabelsFilename, col.names=c('Number'))
testData <- read.table(testDataFilename)
trainSubject <- read.table(trainSubjectFilename, col.names=c('Subject'))
trainLabels <- read.table(trainLabelsFilename, col.names=c('Number'))
trainData <- read.table(trainDataFilename)

# process feature names to be used later as column names####
features$Feature <- gsub('\\(|\\)', '', features$Feature)
features$Feature <- gsub('-|,', '.', features$Feature)
features$Feature <- gsub('BodyBody', 'Body', features$Feature)
features$Feature <- gsub('^f', 'Frequency.', features$Feature)
features$Feature <- gsub('^t', 'Time.', features$Feature)
features$Feature <- gsub('^angle', 'Angle.', features$Feature)
features$Feature <- gsub('mean', 'Mean', features$Feature)
features$Feature <- gsub('tBody', 'TimeBody', features$Feature)


# use nice names
colnames(testData) <- features$Feature
colnames(trainData) <- features$Feature

# Replace train and test labels by the names in the activity file
labels <- activity$Activity
testFactors <- factor(testLabels$Number)
trainFactors <- factor(trainLabels$Number)
testActivity <- data.frame(Activity=as.character(factor(testFactors, labels=labels)))
trainActivity <- data.frame(Activity=as.character(factor(trainFactors, labels=labels)))


# Merge data 
testMergedData <- cbind(testSubject, testActivity, testData)
trainMergedData <- cbind(trainSubject, trainActivity, trainData)

# Merges the training and the test 
mergedData <- rbind(testMergedData, trainMergedData)


# Select columns that do not contain Angle or MeanFreq 
# This columns are not considered as mean or std meassurements
cols <- c()
colNames <- colnames(mergedData)
for (i in seq_along(colNames)){
  name <- colNames[i]
  check1 <- grep('Angle', x=name)
  check2 <- grep('MeanFreq', x=name)
  if (!(any(check1) | any(check2))){
    cols <- c(cols, i)
    
  }
  
} 



# Extract only the measurements on the mean and standard deviation
mergedData <- mergedData[,cols]
mergedDataSubset <- mergedData[,grep('Subject|Activity|Mean|std',x=colnames(mergedData))]
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject ####
library(data.table)
tidyData <- data.table(mergedDataSubset)
tidyData <- tidyData[,lapply(.SD, mean), by=c('Subject', 'Activity')]
tidyData <- tidyData[order(tidyData$Subject, tidyData$Activity),]

# Write the output into a file ####
tidyFileName <- 'tidy.txt'
write.table(tidyData, file=tidyFileName, row.names=FALSE)

# For CodeBook.md creation write column names of data set ####
write.table(colnames(mergedDataSubset), 'dataset-column-names.txt', row.names=FALSE)

