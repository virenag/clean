# Getting and Cleaning Data Course Project R script to do following:
# Merge the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

activity_labels <- read.table("./proj/activity_labels.txt")[,2]

features <- read.table("./proj/features.txt")[,2]

extract_features <- grepl("mean|std", features)

X_test <- read.table("./proj/test/X_test.txt")
y_test <- read.table("./proj/test/y_test.txt")
subject_test <- read.table("./proj/test/subject_test.txt")

names(X_test) = features

X_test = X_test[,extract_features]

y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

test_data <- cbind(as.data.table(subject_test), y_test, X_test)

X_train <- read.table("./proj/train/X_train.txt")
y_train <- read.table("./proj/train/y_train.txt")

subject_train <- read.table("./proj/train/subject_train.txt")

names(X_train) = features

X_train = X_train[,extract_features]

y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

train_data <- cbind(as.data.table(subject_train), y_train, X_train)

data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "./tidy_data.txt")
