library(data.table)

# Script description:
# Load the 'Human Activity Recognition Using Smartphones' data into R,
# combine everything to one 'big' data set
# and execute two differenct calculations.
# In the end produce an output file.



## Download data required for the project --------------------------------------
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- file.path(getwd(), "UCI_HAR_Dataset.zip")
download.file(url, f)

## Unzip and set a new working directory
unzip(f, overwrite = TRUE)
setwd("./UCI HAR Dataset")



## Load and prepare data -------------------------------------------------------

## Merge the training and the test sets to create one data set.

### Load the 'train' data
sbj_train <- read.table("./train/subject_train.txt")
y_train <- read.table("./train/y_train.txt")
x_train <- read.table("./train/X_train.txt", stringsAsFactors = FALSE)

### Now load the 'test' data
sbj_test <- read.table("./test/subject_test.txt")
y_test <- read.table("./test/y_test.txt")
x_test <- read.table("./test/X_test.txt", stringsAsFactors = FALSE)

### Combine and convert the created tables
df1 <- cbind(sbj_train, y_train, x_train)
df2 <- cbind(sbj_test, y_test, x_test)
df <- rbind(df1, df2)



## Use descriptive activity names to name the activities in the data set.
## Appropriately label the data set with descriptive variable names.

### Load dimension data
features <- read.table("./features.txt", stringsAsFactors = FALSE)
activity_labels <- read.table("./activity_labels.txt")

### Make the adjustments
colnames(df) <- c("subject", "activity", features[, 2])
df$activity = factor(df$activity)
levels(df$activity) <- activity_labels[, 2]



## Extract only the measurements on the mean and standard ----------------------
## deviation for each measurement.

### Get the relevant column indizes
pattern <- '.mean()|std().'
col_index <- grep(pattern, names(df), perl=T)

### Save the required result set (task part 2)
res_prefinal <- df[, c(1, 2, col_index)]



## From the data set in step 4, create a second, independent tidy data set with
## the average of each variable for each activity and each subject. ------------

### Calculate the mean
dt <- data.table(res_prefinal)
res_final <- dt[, lapply(.SD, mean), by = c("subject", "activity")]


### Create a file output
write.table(res_final, "./tidy_data_part_5.txt", row.name=FALSE)



#-------------------------------------------------------------------------------

## Clean up, leave the current working dir and reset it to the prior state
rm(sbj_train, x_train, y_train, sbj_test, x_test, y_test, df1, df2)
rm(features, activity_labels, pattern, col_index)
rm(f, url, df)
rm(dt)

setwd("./..")







