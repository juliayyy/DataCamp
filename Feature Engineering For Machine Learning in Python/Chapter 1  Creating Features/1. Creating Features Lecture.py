# Why generate features?

# seleting specific data types:
only_ints = df.select_dtypes(include =['int'])
print(only_ints.columns)

# Ex: Getting to know your data
# Import pandas
import pandas as pd

# Import so_survey_csv into so_survey_df
so_survey_df = pd.read_csv(so_survey_csv)

# Print the first five rows of the DataFrame
print(so_survey_df.head(5))

# Print the data type of each column
print(so_survey_df.dtypes)

# Ex: Selecting specific data types
# Create subset of only the numeric columns
so_numeric_df = so_survey_df.select_dtypes(include=['int','float'])

# Print the column names contained in so_survey_df_num
print(so_numeric_df.columns)