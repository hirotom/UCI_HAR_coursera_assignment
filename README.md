#README

This file explains, how the script run_analysis.R works.

There are 4 major parts in the script
* Getting the raw data
* Loading the raw data into R
* Preparing the data according to the assignment requirements
* Generate an output file


To execute this script a package "data.table" is required.
This package can be downloaded by executing: download.packages("data.table")


##Getting the raw data
The raw data is downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
This url is assigned to the variable 'url' and the downloaded file is saved
under the path as stated in the variable 'f'.

```
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- file.path(getwd(), "UCI_HAR_Dataset.zip")
download.file(url, f)
```

Once the file has been downloaded, the unzip() function extracts the necessary
raw data to the subfolder 'UCI HAR Dataset'. The working directory is also
changed to this subfolder.

```
unzip(f, overwrite = TRUE)
setwd("./UCI HAR Dataset")
```


##Load and prepare data
This script only uses the following data files to import the required data:
*./train/subject_train.txt
*./train/y_train.txt
*./train/X_train.txt
*./test/subject_test.txt
*./test/y_test.txt
*./test/X_test.txt
*./features.txt
*./activity_labels.txt

First, the data is loaded into R using the read.table function. Each input
is assigned to a variable. No modifications to the data are applied at this
step.
During the import of the X_test.txt and X_train.txt data the parameter
stringsAsFactors = FALSE is used to prevent additional changes later in the
skript.

```
sbj_train <- read.table("./train/subject_train.txt")
y_train <- read.table("./train/y_train.txt")
x_train <- read.table("./train/X_train.txt", stringsAsFactors = FALSE)

sbj_test <- read.table("./test/subject_test.txt")
y_test <- read.table("./test/y_test.txt")
x_test <- read.table("./test/X_test.txt", stringsAsFactors = FALSE)
```

So far the train and the test data are saved in three variables each. These
variables (which are classified as data frames) are joined during the next step
to produce one single data frame (per activity type) with
- subject in the first column
- activity in the second column
- features in all the other columens.

```
df1 <- cbind(sbj_train, y_train, x_train)
df2 <- cbind(sbj_test, y_test, x_test)
```

At last both data frames (test and train) are combined.

```
df <- rbind(df1, df2)
```



##Preparing the data according to the assignment requirements
In this part the activity names and the feature names are loaded
and saved in variables 'features' and 'activity_labels'. Data in these 
variables is used to rename column names of the data frame from the previous
part and to change its labels for the column 'activity'.

```
features <- read.table("./features.txt", stringsAsFactors = FALSE)
activity_labels <- read.table("./activity_labels.txt")

colnames(df) <- c("subject", "activity", features[, 2])
df$activity = factor(df$activity)
levels(df$activity) <- activity_labels[, 2]
```

According to the assignment only certain feature columns are in scope. These
columns are identified through a pattern search. The result is subsetted and
saved in the variable 'res_prefinal'.

```
pattern <- '.mean()|std().'
col_index <- grep(pattern, names(df), perl=T)

res_prefinal <- df[, c(1, 2, col_index)]
```

At last, the mean of each feature for each activity and subject is calculated
using the lapply function.

```
dt <- data.table(res_prefinal)
res_final <- dt[, lapply(.SD, mean), by = c("subject", "activity")]
```



##Generate an output file
Using the write.table function the output from the previous step, which was
saved in the variable 'res_final' is exported to a file.

```
write.table(res_final, "./tidy_data_part_5.txt", row.name=FALSE)
```

The filename is: tidy_data_part_5.txt. It can be found in the working directory.



##Clean up
During this last part the variables, which were produced during the execution
of the script, are deleted. Also, the working directory is set to the privious
state.

```
rm(sbj_train, x_train, y_train, sbj_test, x_test, y_test, df1, df2)
rm(features, activity_labels, pattern, col_index)
rm(f, url, df)
rm(dt)

setwd("./..")
```









