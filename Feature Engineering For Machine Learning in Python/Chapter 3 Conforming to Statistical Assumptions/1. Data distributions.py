# Data Distributions

import matplotlib as plt
df.hist()
plt.show()

df[['column_1']].boxplot()
plt.show()

import seaborn as sns
sns.pairplot(df)

df.describe()

#EX1 What does your data look like? (I)
# Create a histogram
so_numeric_df.hist()
plt.show()

# Create a boxplot of two columns
so_numeric_df[['Age', 'Years Experience']].boxplot()
plt.show()

# Create a boxplot of ConvertedSalary
so_numeric_df[['ConvertedSalary']].boxplot()
plt.show()

#EX2 What does your data look like? (II)
# Import packages
import matplotlib.pyplot as plt
import seaborn as sns

# Plot pairwise relationships
sns.pairplot(so_numeric_df)

# Show plot
plt.show()

# Print summary statistics
print(so_numeric_df.describe())