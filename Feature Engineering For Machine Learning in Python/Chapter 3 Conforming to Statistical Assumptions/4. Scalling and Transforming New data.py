# Reuse training scalers
scaler = StandardScaler()

scaler.fit(train[['col']])
train['scaled_col'] = scaler.transform(train[['col']])

# FIT SOME MODEL
#
test pd.read_csv('test_csv')
test['scaled_col'] = scaler.transform(test[['col']])


# Training transformation for reuse
train_std = so_numeric_df['ConvertedSalary'].std()
train_mean = so_numeric_df['ConvertedSalary'].mean()

# Calculate the cutoff
cut_off = train_std * 3
train_lower, train_upper = train_mean - cut_off, train_mean + cut_off

test pd.read_csv('test_csv')
test = test[(test['ConvertedSalary'] < train_upper)
                           & (test['ConvertedSalary'] > train_lower)]

#ex:
# Import StandardScaler
from sklearn.preprocessing import StandardScaler

# Apply a standard scaler to the data
SS_scaler = StandardScaler()

# Fit the standard scaler to the data
SS_scaler.fit(so_train_numeric[['Age']])

# Transform the test data using the fitted scaler
so_test_numeric['Age_ss'] = SS_scaler.transform(so_test_numeric[['Age']])
print(so_test_numeric[['Age', 'Age_ss']].head())

#ex2: Train and testing transformations (II)
train_std = so_train_numeric['ConvertedSalary'].std()
train_mean = so_train_numeric['ConvertedSalary'].mean()

cut_off = train_std * 3
train_lower, train_upper = train_mean - cut_off, train_mean + cut_off

# Trim the test DataFrame
trimmed_df = so_test_numeric[(so_test_numeric['ConvertedSalary'] < train_upper) \
                             & (so_test_numeric['ConvertedSalary'] > train_lower)]
