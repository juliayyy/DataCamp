# Dealing with missing values
# What else can we do?
# Categorical columns: Replace missing values with the most common occuring value or with a string that flags
# missing values such as 'None'


# Numeric columns: Replace missing values with a suitable value
mean
median
# need to be used before missing value replaced
df['ConvertedSalary'] = df['ConvertedSalary'].fillna(df['ConvertedSalary'].mean())
df['ConvertedSalary'] = df['ConvertedSalary']\.astype('int64')
df['ConvertedSalary'] = df['ConvertedSalary'].fillnaround((df['ConvertedSalary'].mean()))

# EX1:Filling continuous missing values
# Print the first five rows of StackOverflowJobsRecommend column
print(so_survey_df['StackOverflowJobsRecommend'].head(5))

# Fill missing values with the mean
so_survey_df['StackOverflowJobsRecommend'].fillna(so_survey_df['StackOverflowJobsRecommend'].mean(), inplace= True)

# Print the first five rows of StackOverflowJobsRecommend column
print(so_survey_df['StackOverflowJobsRecommend'].head())

# Round the StackOverflowJobsRecommend values
so_survey_df['StackOverflowJobsRecommend'] = round(so_survey_df['StackOverflowJobsRecommend'])

# Print the top 5 rows
print(so_survey_df['StackOverflowJobsRecommend'].head())