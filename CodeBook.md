Data source and processing: Data are taken from http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. These data come from signal data from the inbuilt accelerometer and gyroscopes on a smartphone while subjects carry out six activities. Data processing is described by the original authors and no further transformations were carried out.

All following steps were carried out by the run_analysis.R script:

Data filtering: Of the 561 original variables (feature vector), only those for the mean and standard deviation were kept, leaving 86 variables. 

Data summerising: The mean values were calculated for the 86 variables across each activity for each of the 30 subjects. We therefore are left with a single feature vector (limited to the mean and standard variation values) per activity (n=6) per subject (n=30) giving 180 rows.



