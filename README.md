# GettingAndCleaningData_Assignment
This repository contains the R script, the tidy dataset and the code book describing the variables and procedures in manipulating the raw data. This ReadMe file describes the process of tidying up the raw data, a description of the run_analysis.R file. The package dplyr was implemented to tidy the raw data.

Contents of this repository:

MeanTidy.csv
These are the results of the processing on the raw data computed by "run_analysis.R" 

run_analysis.R
This is a R script which loads the raw "wearable computing" data and completes a series of tidying up functions

CodeBook.md
The codebook describes each "tidy variable" in the "MeanTidyD.csv". 


Raw Data Processing Procedure (run_analysis.R)

Pre-processing prodcedure:
1) Set your working directory to the location of the extracted RAW data 

2) Install the dplyr package

3) Source the script and the clean up will occur automatically

4) Two outputs are stored a) the MeanTidy.txt which contains the means of the data grouped by Subject and Activity. As well as, b) FullTidy.csv which contains the tidy dataset before the averaging occurs.


Processing:
1) Import the raw data into dplyr table variables

2) Import the reference data (activities and subjects) as dplyr table variables

3) Rename the reference and raw data column names to more understandable labels

4) Column bind the Activity Code and the Subject Code with the raw train and test data frames

5) Row bind the Test and Train raw data to form one dataset

6) Test if all the column names are valid for further processing

7) Remove the raw table data from the workspace

8) Begin tidying the raw data using dplyr and the following steps:
  - Selecting only the columns that contain "mean" or "std" or "Activity" (Task 2)
  - Joining the Activity names based on the match between the numbers of each table (Task 3)
  - Removing the "Activity" column that contains the numbers, to only keep the Activity column that contains the description
  - Renaming the factor variable column with the description of the activity to "Activity"(Start of Task 4)

9) Using Regular Expressions (RegEx) rename the columns with the function created called mgsub

10) Rename columns with the following pattern
  - patt = c("^t","tB","Freq",".Freq.","^f","^angle","\\.+","\\.$")
  - repl = c("Triaxial","TriaxialB","","","Freq","Angle",".","")
  - Which  means replace:
    - All columns starting with a "t" are replaced my "Triaxial"
    - All containing "tB" are replaced by "TriaxialB"
    - Remove all duplicate "Freq" by ""
    - All columns starting with a "f" are replaced my "Freq" for Frequency
    - All columns starting with a "angle" are capitalized
    - Replace multiple "." with a single "."
    - Remove any "." that occurs and the send of the column name

11) Replace column names

12) Save the full tidy data as "FullTidy.csv"

13) Convert the Subject column from a NUM to a FACTOR variable to group the data

14) Test if the column names are still valid, if not they are modified slightly but still are easy to read and understand

15) Group the data by Subject ID and Activity Type

16) Using the grouped data, summarize each table with the mean function

17) Output the tidy mean dataset to TXT for storage on GitHub, and Coursera submission

18) Remove remaining processing tables from the workspace


END of ReadMe
