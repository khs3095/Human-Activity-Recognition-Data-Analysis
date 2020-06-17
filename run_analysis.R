library(dplyr)


train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/Y_train.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")


test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/Y_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")


var_names <- read.table("./UCI HAR Dataset/features.txt")


act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")


total_x <- rbind(train_x , test_x)
total_y <- rbind(train_y, test_y)
total_subject <- rbind(train_subject, test_subject)


selected_var <- var_names[grep("mean\\(\\)|std\\(\\)",var_names[,2]),]
total_x <- total_x[,selected_var[,1]]


colnames(total_y) <- "activity"
total_y$activitylabel <- factor(total_y$activity, labels = as.character(act_labels[,2]))
activitylabel <- total_y[,-1]


colnames(total_x) <- var_names[selected_var[,1],2]


colnames(total_subject) <- "subject"
total <- cbind(total_x, activitylabel, total_subject)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)