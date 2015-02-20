# ======================================================
# The function run_analysis perform all the tasks 
# for the Getting and Cleaning Data - Course Project.
# From data stored locally in flat files, the function returns
# a cleaned and summarized dataset
#
# To call the function :
# 1. Place the run_analysis.R in your working directory
# 2. Type the following in R command prompt :
#   > source("run_analysis.R")
#   > DF <- run_analysis()
# ======================================================
run_analysis <- function()
{
    # -----------------------
    # Load dependencies
    # -----------------------
    library(dplyr)
    
    # -----------------------
    # Read data from text files
    # -----------------------
    activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
    features <- read.table("UCI HAR Dataset/features.txt")
    subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
    X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
    y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
    subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
    X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
    y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
    
    # -----------------------
    # Subject dataset
    # -----------------------
    # Merge test and train rows
    subject <- rbind(subject_test, subject_train)
    # Rename column 
    colnames(subject) <- "subject"

    # -----------------------
    # Y dataset
    # -----------------------
    # Merge rows
    y <- rbind(y_test, y_train)
    # Convert to factor
    y$V1 <- as.factor(y$V1)
    # Overwrite levels with levels from activity dataset
    levels(y$V1) <- activity_labels$V2 # (Coursera - Step 3)
    # Rename column
    colnames(y) <- "activity"
    
    # -----------------------
    # X dataset
    # -----------------------
    # Merge rows
    x <- rbind(X_test, X_train)
    # Rename column using features dataset.
    # Column name are cleanned for the sake of readability
    colnames(x) <- gsub("[\\(\\)]", "", gsub("[-,]", ".", features$V2)) # (Coursera - Step 4)
    # Extract only mean and standard deviation variables
    colidx <- grep("(-mean\\(\\))|(-std\\(\\))", features$V2) # (Coursera - Step 2)
    x <- x[,colidx]
    
    # -----------------------
    # Build first dataset
    # -----------------------
    data <- cbind(subject, x, y) # (Coursera - Step 1)
    
    # -----------------------
    # Build final dataset
    # -----------------------
    # Data is grouped and summarized using mean of each variables
    tidy.data <- data %>% group_by(activity,subject) %>% summarise_each(funs(mean)) # (Coursera - Step 5)
    tidy.data
}