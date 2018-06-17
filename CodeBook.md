run_analysis.Rperforms the 5 steps described in the course project's definition.
1) similar data is merged using the rbind() function. 
2) data sets are referred to the same entities.
3) Columns with the mean and standard deviation measures are considered, given the correct names (features.txt).
4) Activity names and IDs from activity_labels.txt and they are substituted in the dataset.
5) we generate a new dataset with all the average measures for each subject and activity type 
The output file is called tidy.txt.

Variable description:
- X_train, y_train, X_test, y_test, subject_train and subject_test => data from the downloaded files.
- x_all, y_all and subject_all => merge the previous datasets.
- features => correct names for x_all dataset
- Ideem with activity names through the activity_labels variable.
- x_extract => table with the features selected
- all_data => merges x_all, y_all and subject_all.
- tidy contains averages (stored in a .txt file)
