# Dealing with missing values

# listwise deletion: if
df.dropna(how ='any')
df.dropna(subset=['versioncontrol'])
# Issues with deletion:
# delete valid data points
# relies on randomness
# reduces info

# Replacing with strings
df['versioncontrol'].fillna(value = ' None Given', inplace = True)

# Recording missing values
df['SalaryGiven'] = df['ConvertedSalary'],notnull()
df.drop(columns = ['ConvertedSalary'])

#EX:Listwise deletion
# Print the number of rows and columns
print(so_survey_df.shape)

# Create a new DataFrame dropping all incomplete rows
no_missing_values_rows = so_survey_df.dropna(how='any')

# Print the shape of the new DataFrame
print(no_missing_values_rows.shape)

# Create a new DataFrame dropping all columns with incomplete rows
no_missing_values_cols = so_survey_df.dropna(how = 'any', axis=1)

# Print the shape of the new DataFrame
print(no_missing_values_cols.shape)

# Drop all rows where Gender is missing
no_gender = so_survey_df.dropna(subset = ['Gender'])

# Print the shape of the new DataFrame
print(no_gender.shape)

# Replacing missing values with constants
# Print the count of occurrences
print(so_survey_df['Gender'].value_counts())

# Replace missing values
so_survey_df['Gender'].fillna(value='Not Given', inplace = True)

# Print the count of each value
print(so_survey_df['Gender'].value_counts())
