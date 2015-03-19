Getting and Cleaning Data (Coursera). Course Project Codebook
==============================================================

## Source Data

The source data comes from the smartphone accelerometer and gyroscope signals, 
which have been processed using various signal processing techniques to measurement vector. 
For detailed description of the original dataset, please see `features_info.txt` in
the zipped dataset file.

- [source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) 
- [description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)


## Conventions followed

Processing code and dataset variable naming follows the conventions described in 
[Google R Styde Guide](http://google-styleguide.googlecode.com/svn/trunk/Rguide.xml).

## Data sets

### Raw data set

The raw dataset was created using the following filter expressions to filter out required
features, keeping only the mean and standard deviation for each measurement
from the original feature vector set:

mean() and std()

This operation selects 79 features from the original data set.
Combined with subject identifiers `subject` and activity labels `activity`, this makes up the
81 variables of the processed raw data set.

The training and test subsets of the original dataset were combined to produce final raw dataset.

### Tidy data set

Tidy data set contains the average of all feature standard deviation and mean values of the raw dataset. 
Original variable names were modified in the follonwing way:

 1. Removed parenthesis `-()`
 2. Replaced `-` with ` `
 3. Apply  make.names on the column names
 
### The code
The code uses a helper function, merge.with.order, which merges two data sets while keeping the order from one of them.
The data is loaded in intermediary variables, merged and then the column names processed.
Finnaly the means are calculated with the summarise_each function from the dplyr package.