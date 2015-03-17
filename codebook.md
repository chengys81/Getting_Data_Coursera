# variable names in final tidy data

* suject - individual person enrolled in the wearable study, coded from 1 to 30
* activity - 6 different activities each subject has, including:
  1. 1-WALKING
  2. 2-WALKING_UPSTAIRS
  3. 3-WALKING_DOWNSTAIRS
  4. 4-SITTING
  5. 5-STANDING
  6. 6-LAYING
* datasource - data from train or test folder in original datasets
* measure - 66 different measures
* summaryStat - summary statistics for these measurements, including mean and standard deviation
* coordinate - X, Y, Z or empty
* mean - mean of summary statistics for each coordinate, each measure, each activity and subject

# steps in run_analysis.R

* download the data using download.file() function
* unzip the downloaded zipped dataset
* list all files in the extracted folder by using list.files(..., recursive=TRUE) to have all files in child folders
* use for loop to sequentially read x,y,subject data from train and test folder
* combine the train and test dataset using cbind() function
* change the column names of total dataset into readable names
* create a new variable indicating the data source
* melt the total dataset for making tidy dataset
* split the new generated variable column into 3 new column, called measure, summaryStat(summary statistics), and coordinate(x,y,z,or empty)
* calculate summary statistics by grouping the data set at each subject, activity, measure, summary statistics (mean or std), coordinate(x,y,z or empty)
* write tidy data set into txt file called summarized.txt
* plot the data set with ggplot