# This code imports and processes the raw data according to the Coursera requirements, and outputs a new file called "TidyData.csv".
# Please set you working directory as the directory with the raw data

library(dplyr)
library(tidyr)

### Step 0: Import all the data
test_subject <- tbl_df(read.table("./test/subject_test.txt"))
test_data <- tbl_df(read.table("./test/X_test.txt"))
test_labels <- tbl_df(read.table("./test/y_test.txt"))


train_subject <- tbl_df(read.table("./train/subject_train.txt"))
train_data <- tbl_df(read.table("./train/X_train.txt"))
train_labels <- tbl_df(read.table("./train/y_train.txt"))

act_names <- tbl_df(read.table("activity_labels.txt"))
features <- tbl_df(read.table("features.txt"))

### Step 1: Rename all columns
names(train_labels) <- "Activity"
names(test_labels) <- "Activity"

# Add column names to the data tables.
features <- features$V2
colnames(test_data) <- features
colnames(train_data) <- features

### Step 2: Merge all the data

# Column bind the Activity Code with the train and test data frames
test_data <- cbind(test_labels,test_data)
train_data <- cbind(train_labels,train_data)
# Merge the subject identifier to the main train and test data frames
test_data <- cbind(test_subject,test_data)
train_data <- cbind(train_subject,train_data)

# Row bind the data table with rbind to preserve all the data (Task 1)
full_data <- rbind(test_data,train_data)

# Fix the column names to text formats that R accepts
valid_column_names <- make.names(names=names(full_data), unique=TRUE, allow_ = TRUE)
# Rename the columns agains with valid names
names(full_data) <- valid_column_names

# Extract the list of tables in the current workspace
tbllist <- ls()
# Remove all tables that start with train or test
rm(list = tbllist[grepl("train.",tbllist) | grepl("test.",tbllist)])

### Step 3: Select data only containing mean, standard deviation and the activity type
part_data <- full_data %>%
  
  # Selecting only the columns that contain "mean" or "std" or "Activity" (Task 2)
  select(contains("mean"),contains("std"),matches("Activity"),matches("V1")) %>%
  
  # Joining the Activity names based on the match between the numbers of each table (Task 3)
  left_join(act_names,by=c("Activity" = "V1")) %>%
  
  # Removing the "Activity" column that contains the numbers
  select(-Activity) %>%
  
  # Renaming the factor variable column with the description of the activity to "Activity"(Start of Task 4)
  rename(Activity = V2) %>%
  rename(Subject = V1)


# Task 4: Renaming the variables from domain to non-domain expert, ie. more understandable
#rename(part_data,Subject = V1)
old_tblnames <- names(part_data)

# A function that takes a list of patterns (RegEx) and replacments and runs all the gsub expressions
mgsub <- function(pattern, replacement, x, ...) {
  if (length(pattern)!=length(replacement)) {
    stop("pattern and replacement do not have the same length.")
  }
  result <- x
  for (i in 1:length(pattern)) {
    result <- gsub(pattern[i], replacement[i], result, ...)
  }
  result
}

# List of strings to run the renaming on - the raw data column names
old_tblnames <- names(part_data)
# A list with RegEx patterns to search for in the old_tblnames
patt = c("^t","tB","Freq",".Freq.","^f","^angle","\\.+","\\.$")
# The respective replacement if the RegEx is found in the old_tblnames
repl = c("Triaxial","TriaxialB","","","Freq","Angle",".","")

# Save the renamed column list into the variable new_tblnames
new_tblnames <- mgsub(patt,repl,old_tblnames)
# Rename the columns based on the changes made
names(part_data) <- new_tblnames
# Output the full tidy dataset to CSV for storage on GitHub
write.csv(part_data, file = "FullTidy.csv")

# Task 5: 
# Convert the subject to a factor variable
part_data$Subject <- as.factor(part_data$Subject)
# Group data based on Activity and Subject
group_data <- group_by(part_data,Activity,Subject)
# Must re-evaluate the names assigned to the columns 
valid_column_names <- make.names(names=names(group_data), unique=TRUE, allow_ = TRUE)
names(group_data) <- valid_column_names

# Using the grouped data, summarize each table with the mean function
mean_data <- summarize_each(group_data,funs(mean))
# Output the tidy mean dataset to CSV for storage on GitHub
write.table(mean_data, file = "MeanTidy.txt",row.names = FALSE)

# Remove the untidy datasets
rm(list = c("part_data","full_data","act_names"))


