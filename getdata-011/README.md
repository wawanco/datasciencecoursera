# Getting and Cleaning Data Course Project

*Dependencies: dplyr*

## Introduction
The function `run_analysis` contained in `"run_analysis.R"` file performs all the tasks needed for the Getting and Cleaning Data Course Project.
From data stored locally in flat files, the function returns a cleaned and summarized dataset.


## Resulting dataset
The tidy dataset file uploaded in the course project is generated following the following commands :
1. Unzip the file `getdata_projectfiles_UCI HAR Dataset.zip` in working dir
2. Place the `run_analysis.R` file in your working directory
3. Type the following in R command prompt :
```bash
    > source("run_analysis.R")
    > tidy.data <- run_analysis()
    > write.table(tidy.data, "tidy-data.txt")
```

The resulting file can be read again using `tidy.data <- read.table("tidy-data.txt")`

## Data cleaning
### Read data
It is assumed that files are in a directory named `UCI HAR Dataset` in the working directory.
Flat files are read using `read.table` function with default parameters.

Files contained in `test\Inertial Signals` and `train\Inertial Signals` are not considered for this project.

### Subject dataset
Rows from `subject_test.txt` and `subject_train.txt` are concatenated. Column name is set to `"subject"`.
Result is stored in the variable `subject`.

### Y dataset
Rows from `y_test.txt` and `y_train.txt` are concatenated. 
Data type is coerced to factor using `as.factor()` function.
The levels the categorical variables are overwritten using labels given in `activity_labels.txt`.

NB : Levels of variables being `"1"`, `"2"`, `".."` there is no need to sort levels before assigning new labels.

Column name is set to `"activity"`.
Result is stored in the variable `y`.

### X dataset
Rows from `X_test.txt` and `X_train.txt` are concatenated.

`features.txt` contains measure names, but the syntax is not easily readable, hence the labels are cleaned using regular expressions and `gsub()` function.
We perform two operations with `gsub()` function :

* Parenthesis are removed : `gsub("[\\(\\)]", "", x)`
* Dashes and commas are replaced by dot : `gsub("[-,]", ".", x)`

For instance, we have the following results:
```bash
"tBodyAcc-mean()-X" -> "tBodyAcc.mean.X"
"tBodyAcc-arCoeff()-Z,4" -> "tBodyAcc.arCoeff.Z.4"
```

We are asked to keep only measure of mean and standard deviation. 
As indicated in `features_info.txt`, mean (resp. std) measurements have the following structure : `<measure>-mean()` (or `<measure>-std()`).
I use `grep()` function with a regular expression that recognizes these patterns and select only the indices of wanted columns : `grep("(-mean\\(\\))|(-std\\(\\))", x)`.

NB : In the regular expression `mean` and `std` are preceded by a dash to avoid selecting `gravityMean` for instance.

Result is stored in the variable `x`.

### Build first dataset
The first dataset is built binding column cleaned as described above : `subject`, `x`, `y`.

### Tidy dataset
the first dataset is grouped by `subject` and `activity` using `group_by`. We compute means of each variables for each group using `summarise_each()` function. I use the `dplyr` library chaining syntax here with `%>%`.
