# Why do missing values exist?
 df.isnull()
 df.notnull()
 df[''].isnull().sum()

 # EX: How sparse is my data?
# Subset the DataFrame
sub_df = so_survey_df[['Age','Gender']]

# Print the number of non-missing values
print(sub_df.notnull().sum())

# Finding the missing values
# Print the top 10 entries of the DataFrame
print(sub_df.head(10))

# Print the locations of the missing values
print(sub_df.head(10).isnull())

# Print the locations of the non-missing values
print(sub_df.head(10).notnull())
