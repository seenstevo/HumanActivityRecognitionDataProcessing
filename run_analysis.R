##########download, unzip and prepare directories####
# First we will establish directories and download/extract the data files

# set up directory names
maindir <- getwd()
projectdir <- "Getting_and_Cleaning"
# create the project directory and output directory if don't exist
if (!(dir.exists(file.path(maindir, projectdir)))){
    dir.create(file.path(maindir, projectdir))}
if (!(dir.exists(file.path(maindir, projectdir, "Outputs")))){
    dir.create(file.path(maindir, projectdir, "Outputs"))}
# setwd to the project directory and save output directory variable
setwd(paste0(maindir, "/", projectdir))
outputdir <- paste0(maindir, "/", projectdir, "/Outputs")
# download file into the project directory
if (!(dir.exists("./UCI HAR Dataset"))){
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./HAR.zip")
    # unzip then delete original zip
    unzip("HAR.zip")
    file.remove("HAR.zip")}
# get the data directory and data files into variables
data_dir <- list.dirs(full.names = TRUE, recursive = FALSE)[2]
Xtrain <- file.path(data_dir, "train/X_train.txt")
ytrain <- file.path(data_dir, "train/y_train.txt")
Xtest <- file.path(data_dir, "test/X_test.txt")
ytest <- file.path(data_dir, "test/y_test.txt")
features <- file.path(data_dir, "features.txt")
labels <- file.path(data_dir, "activity_labels.txt")
subjectTrain <- file.path(data_dir, "train/subject_train.txt")
subjectTest <- file.path(data_dir, "test/subject_test.txt")
##########load required libraries################################
# Then import required libraries
library(dplyr)
library(stringr)
##########Merge train and test data, adding labels, subjects and variable names##########################

mergeTrainTest <- function(data_dir, features, Xtrain, ytrain, Xtest, ytest, subjectTrain, subjectTest){
    # this function reads in the test and train data and combines it all together
    # it also adds in the descriptive variable names 
    
    # first read in all relevant files
    features <- read.table(features)
    Xtrain <- read.table(Xtrain)
    ytrain <- read.table(ytrain)
    Xtest <- read.table(Xtest)
    ytest <- read.table(ytest)
    subjectTrain <- read.table(subjectTrain)
    subjectTest <- read.table(subjectTest)
    # first we cbind the labels (y) and subjects to the data
    test <- cbind(subjectTest, Xtest, ytest)
    train <- cbind(subjectTrain, Xtrain, ytrain)
    # then we check that columns/variables are equal and rbind train and test
    # also add the variable names from features.txt file
    if (dim(test)[2] == dim(train)[2]){
        merged <- rbind(test, train)
        names(merged) <- c("Subject", as.character(features[,2]), "Label")
        names(merged) <- make.unique(names(merged), sep="_")
    } else {
        stop("dataframes do not have same no of columns")
    }
    merged
}

mergedData <- mergeTrainTest(data_dir, features, Xtrain, ytrain, Xtest, ytest, subjectTrain, subjectTest)

##########Select to keep only mean and std values per measurement####

selectMeanSD <- function(mergedData){
    # this function simple uses the select function from dplyr to filter all columns that 
    # contain "mean" or "std" strings meaning they are means and standard deviation values
    meanSTDdata <- select(mergedData, Subject, contains("mean", ignore.case = TRUE), 
               contains("std", ignore.case = TRUE), Label)
    meanSTDdata
}

meanSTDdata <- selectMeanSD(mergedData)

##########Replace activity code with descriptive activity name#############

describeLabel <- function(meanSTDdata, labels){
    labels <- read.table(labels, colClasses = "character")
    meanSTDdata$Label <- str_replace_all(meanSTDdata$Label, setNames(labels$V2, labels$V1))
    meanSTDdata
}

meanSTDdata <- describeLabel(meanSTDdata, labels)

##########Create the tidy dataset with means per measurement and subject#####

SubjectActivityMean <- function(meanSTDdata){
    # function adds and uses the subject variable to group_by along with the activity
    # so we make a tidy dataset with the mean per subject per activity
    
    # chain the group_by and summerise_at to get mean values per subject per activity
    subjsMeanSTD <- meanSTDdata %>% 
        group_by(Subject, Label) %>% 
        summarise_at(vars(`tBodyAcc-mean()-X`:`fBodyBodyGyroJerkMag-std()`), mean)
    subjsMeanSTD
}

subjsMeanSTD <- SubjectActivityMean(meanSTDdata) 
write.table(subjsMeanSTD, "./Outputs/HAR_Mean_Subj_Activity.txt", 
            sep = "\t", row.names = FALSE)

