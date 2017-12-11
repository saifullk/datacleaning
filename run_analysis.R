
# Install package reshape2 if not installed already
# download and unzip the exercise data in current directory
library(reshape2)


# Load activity labels + features
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activitylabels[,2] <- as.character(activitylabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
requiredFeatures <- grep(".*mean.*|.*std.*", features[,2])
requiredFeatures.names <- features[requiredFeatures,2]
requiredFeatures.names = gsub('-mean', 'Mean', requiredFeatures.names)
requiredFeatures.names = gsub('-std', 'Std', requiredFeatures.names)
requiredFeatures.names <- gsub('[-()]', '', requiredFeatures.names)


# Load the datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[requiredFeatures]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[requiredFeatures]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
combdata <- rbind(train, test)
colnames(combdata) <- c("subject", "activity", requiredFeatures.names)

# turn activities & subjects into factors
combdata$activity <- factor(combdata$activity, levels = activitylabels[,1], labels = activitylabels[,2])
combdata$subject <- as.factor(combdata$subject)

combdata.melted <- melt(combdata, id = c("subject", "activity"))
combdata.mean <- dcast(combdata.melted, subject + activity ~ variable, mean)

write.table(combdata.mean, "tidy.txt", row.names = FALSE, quote = FALSE)