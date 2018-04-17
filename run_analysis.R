# Step1 Read and merge sets into one data set 
test1 <- read.table("./test/X_test.txt")
test2 <- read.table("./test/y_test.txt")
test3 <- read.table("./test/subject_test.txt")
train1 <- read.table("./train/X_train.txt")
train2 <- read.table("./train/y_train.txt")
train3 <- read.table("./train/subject_train.txt")
test <- cbind(test3, test2) %>% cbind(test1)
train <- cbind(train3, train2) %>% cbind(train1)
set <- rbind(test, train)

# Step4 Set variable names
label <- read.table("features.txt")
names(set) <- c("Subject", "Activity", as.character(label$V2)) 

# Step2 Extract mean and std for each measurement
sub <- grep("mean\\(\\)|std\\(\\)", names(set), value = TRUE)
set <- set[1:2] %>% cbind(set[sub])

# Step3 Use activity names in data set
act <- read.table("activity_labels.txt")
set$Activity <- sapply(as.list(set$Activity), function(x) { as.character(act$V2)[x]})

# Step5 Create a tidy data set
library(dplyr)
tidy_set <- set %>% group_by(Subject, Activity) %>% summarise_all(funs(mean)) %>% as.data.frame()