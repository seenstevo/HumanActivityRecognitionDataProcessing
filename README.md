# HumanActivityRecognitionDataProcessing

This repository deals with the downloading, reformating and processing of the Human Activity Recognition Data available from the following link: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

This repository contains the script run_analysis.R which contains four functions which carry out the following steps:

1) mergeTrainTest: This merges train and test datasets and adds descriptive variable names as well as the extra variables for activity labels and subjects.
2) extractMeanSD: This function selects the mean and standard deviation measured variables.
3) describeLabel: Takes the activity label code (1-6) and replaces it with the descriptive activity label.
4) SubjectActivityMean: Uses the subject and activity labels to calculate the mean values for all subject-activity pairs. 

The script will then write out the final dataframe as the file "HAR_Mean_Subj_Activity.txt" in an Outputs directory. 
