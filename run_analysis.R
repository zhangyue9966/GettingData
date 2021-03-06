#    You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
X_test <- read.table("~/Desktop/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
Y_test <- read.table("~/Desktop/UCI HAR Dataset/test/Y_test.txt", quote="\"", comment.char="")
X_train <- read.table("~/Desktop/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
Y_train <- read.table("~/Desktop/UCI HAR Dataset/train/Y_train.txt", quote="\"", comment.char="")
subject_train <- read.table("~/Desktop/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
subject_test <- read.table("~/Desktop/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
activity_labels <- read.table("~/Desktop/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
features <- read.table("~/Desktop/UCI HAR Dataset/features.txt", quote="\"", comment.char="")

dim(X_test)  #2947  561
dim(Y_test)  #2947    1
dim(X_train) #7352  561
dim(Y_train) #7352    1


test_data <- cbind(X_test,Y_test,subject_test)
names(test_data)[562] <- "Y"
names(test_data)[563] <- "subject"
train_data <- cbind(X_train,Y_train,subject_train)
names(train_data)[562] <- "Y"
names(train_data)[563] <- "subject"
ttl_data <- rbind(test_data,train_data)
names(ttl_data)[562] <- "Y"
names(ttl_data)[563] <- "subject"
names(ttl_data)[1:561] <- as.character(features[,2])

mean_va <- ttl_data[,grep("mean",names(ttl_data))]
sd_va <- ttl_data[,grep("std",names(ttl_data))]

cc <- ttl_data[,"Y"]
for(i in activity_labels[,1]) 
  cc <- gsub(activity_labels[i,1], activity_labels[i,2], cc, fixed = TRUE)
ttl_data[,"Y"] <- cc
unique(ttl_data[,"Y"]) #Check the answers 

names(ttl_data)[1:561]  # I think the names are already pretty descriptive

a <- aggregate(ttl_data,list(ttl_data$Y),mean)
b <- aggregate(ttl_data,list(ttl_data$subject),mean)
result<- rbind(a,b)

write.table(result,"~/Desktop/result.txt",row.name=FALSE)
