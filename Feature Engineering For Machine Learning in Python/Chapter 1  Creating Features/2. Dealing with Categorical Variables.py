# Encoding categorical featuress:
# One-hot encoding : explainable features
pd.getdummies(df, columns = ['Country'], prefix = 'C')

# Dummy encoding: Necesary info without duplication
pd.get_dummies(df, columns = ['Country'], drop_first = True, prefix = 'C')

# limiting your columns
counts = df['Country'].value_counts()
print(counts)
mask = df['Country'].isin(counts[counts < 5].index )
df['Country'][mask] = 'Other'
print(pd.value_counts(colors))

# EX: One-hot encoding and dummy variables
# Convert the Country column to a one hot encoded Data Frame
one_hot_encoded = pd.get_dummies(so_survey_df, columns=['Country'], prefix='OH')

# Print the columns names
print(one_hot_encoded.columns)

# Create dummy variables for the Country column
dummy = pd.get_dummies(so_survey_df, columns=['Country'], drop_first=True, prefix='DM')

# Print the columns names
print(dummy.columns)

# Ex: Dealing with uncommon categories
# Create a series out of the Country column
countries = so_survey_df['Country']

# Get the counts of each category
country_counts = countries.value_counts()

# Print the count values for each category
print(country_counts)

# Create a mask for only categories that occur less than 10 times
mask = countries.isin(country_counts[country_counts<10].index)

# Print the top 5 rows in the mask series
print(mask.head(5))

# Label all other categories as Other
countries[mask] = 'Other'

# Print the updated category counts
print(pd.value_counts(countries))
