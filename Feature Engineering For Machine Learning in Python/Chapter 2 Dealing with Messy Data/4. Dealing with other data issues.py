# Dealing with other data issues
# Dealing with bad charaters
df['RawSalary'] = df['RawSalary'].str.replace(',', '')
df['RawSalary'] = df['RawSalary'] .astype('float')
df[coerced_vals.isna()].head()
# Chain methods
df['column_name'] = df['column_name']\.method1().method2().method3()

#EX1: Dealing with stray characters (I)
# Remove the commas in the column
so_survey_df['RawSalary'] = so_survey_df['RawSalary'].str.replace(',', '')
# Remove the dollar signs in the column
so_survey_df['RawSalary'] = so_survey_df['RawSalary'].str.replace('$','')

#EX2: Dealing with stray characters (II)
# Attempt to convert the column to numeric values
numeric_vals = pd.to_numeric(so_survey_df['RawSalary'], errors='coerce')

# Find the indexes of missing values
idx = numeric_vals.isnull()

# Print the relevant rows
print(so_survey_df['RawSalary'][idx])

# Replace the offending characters
so_survey_df['RawSalary'] = so_survey_df['RawSalary'].str.replace('£','')

# Convert the column to float
so_survey_df['RawSalary'] = so_survey_df['RawSalary'].astype('float')

# Print the column
print(so_survey_df['RawSalary'])

# EX: Method chaining
# Use method chaining
so_survey_df['RawSalary'] = so_survey_df['RawSalary'] \
    .str.replace(',', '') \
    .str.replace('$', '') \
    .str.replace('£', '') \
    .astype('float')

# Print the RawSalary column
print(so_survey_df['RawSalary'])