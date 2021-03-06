# Chapter 1: Read, clean and validate
# Chapter 2: Distributions
# Chapter 3: Relationships
# Chapter 4: Multivariate Thinking

# Chapter 1: Read, clean and validate
# Dataframe and Series
import pandas as pd
nsfg = pd.read_hdf('nsfg.hdf5','nsfg')
type(nsfg)
nsfg.head()
nsfg.shape
nsfg.columns

pounds = nsfg['birthwgt_lb1']
type(pounds) # series
pounds.head()

# Clean and validate
pounds = nsfg['birthwgt_lb1']
ounces = nsfg['birthwgt_oz1']
pounds.value_counts().sort_index()
pounds.describe()
pounds = pounds.replace([98,99],np.nan)
pounds.mean()
pounds.replace([98,99],np.nan, inplace = True)
birth_weight = pounds + ounces / 16.0
birth_weight.decribe()
# Clean a variable
# Replace the value 8 with NaN
nsfg['nbrnaliv'].replace(8, np.nan, inplace = True)

# Print the values and their frequencies
print(nsfg['nbrnaliv'].value_counts())

# Filter and visualize
import matplotlib.plt as plt
plt.hist(birth_weight.dropna(), bins = 30 ) # work with series, does not deal with NA
plt.xlabel()
plt.ylabel()
plt.show()

#Boolean Series
preterm = nsfg['prglngth'] < 37
preterm.sum() # count of true
preterm.mean() # fraction, percentage
preterm_weight = birth_weight[preterm]
preterm_weight.mean()
full_term_weight = birth_weight[~preterm] # not
full_term_weight.mean()
resample_rows()_weighted()

# EX: Make a histogram
# Plot the histogram
plt.hist(agecon, bins=20, histtype='step')
# Label the axes
plt.xlabel('Age at conception')
plt.ylabel('Number of pregnancies')
# Show the figure
plt.show()

# Create a Boolean Series for full-term babies
full_term = nsfg['prglngth'] >= 37

# Select the weights of full-term babies
full_term_weight = birth_weight[full_term]

# Compute the mean weight of full-term babies
print(full_term_weight.mean())

# EX: filter
# Filter full-term babies
full_term = nsfg['prglngth'] >= 37

# Filter single births
single = nsfg['nbrnaliv'] == 1

# Compute birth weight for single full-term babies
single_full_term_weight = birth_weight[full_term & single]
print('Single full-term mean:', single_full_term_weight.mean())

# Compute birth weight for multiple full-term babies
mult_full_term_weight = birth_weight[full_term& ~single]
print('Multiple full-term mean:', mult_full_term_weight.mean())

# Chapter 2 Probability mass functions
educ = gss['educ']
pmf_edu = Pmf(edu,normalize = False) # return series - count
pmf_edu = Pmf(edu,normalize = True) # return series - percentage
pmf_edu.bar(label = 'educ') # used to check all unique values
plt.xlabel()
plt.ylabel()
plt.show()
cdf = cdf(gss['age'])
cdf.plot()
plt.xlabel()
plt.ylabel()
plt.show()
p = 0.25
q = Cdf.inverse(p)
# Select the age column
age = gss['age']

# Compute the CDF of age
cdf_age = Cdf(age)

# Calculate the CDF of 30
print(cdf_age(30))
# 0.2539137136526388

# Compute IQR
# Calculate the 75th percentile
percentile_75th = cdf_income.inverse(0.75)

# Calculate the 25th percentile
percentile_25th = cdf_income.inverse(0.25)

# Calculate the interquartile range
iqr = percentile_75th - percentile_25th

# Print the interquartile range
print(iqr)

# Plot a CDF
# Select realinc
income = gss['realinc']

# Make the CDF
cdf_income = Cdf(income)

# Plot it
cdf_income.plot()

# Label the axes
plt.xlabel('Income (1986 USD)')
plt.ylabel('CDF')
plt.show()

# Comparing distributions
# Select educ
educ = gss['educ']

# Bachelor's degree
bach = (educ >= 16)

# Associate degree
assc = np.logical_and(educ < 16, educ >= 14)

# High school (12 or fewer years of education)
high = (educ <= 12)
print(high.mean())

# Plot income CDFs
income = gss['realinc']

# Plot the CDFs
Cdf(income[high]).plot(label='High school')
Cdf(income[assc]).plot(label='Associate')
Cdf(income[bach]).plot(label='Bachelor')

# Label the axes
plt.xlabel('Income (1986 USD)')
plt.ylabel('CDF')
plt.legend()
plt.show()

# Modeling Distribution
sample = np.random.normal(size = 1000)
Cdf(sample).plot
From scipy.stats import norm
xs = np.linspace(-3,3) # an array of equally spaced points
ys = norm(0,1).cdf(xs) # create an object of normal distribution with mean 0 and sd 1; .cdf evaluate the nromal distrinution
plt.plot(xs, ys, color = 'grey')
Cdf(sample).plot()

xs = np.linspace(-3,3) # an array of equally spaced points
ys = norm(0,1).pdf(xs) # create an object of normal distribution with mean 0 and sd 1; .cdf evaluate the nromal distrinution
plt.plot(xs, ys, color = 'grey')

#KDE - Kernel Density Estimation. We can use the point from the sample to estimate the pdf of the distribution it came from
import seaborn as sns
sns.kdeplot(sample)

#Compare KDE and PDF
xs = np.linspace(-3,3) # an array of equally spaced points
ys = norm.pdf(xs)
plt.plot(xs, ys, color = 'grey')
sns.kdeplot(sample)

# Use CDFs for exploration
# Use PMFs if there is a small number of unique values
# Use KDE if there are a lot of values

# EX: Distribution of income
# Extract realinc and compute its log
income = gss['realinc']
log_income = np.log10(income)

# Compute mean and standard deviation
mean = log_income.mean()
std = log_income.std()
print(mean, std)

# Make a norm object
from scipy.stats import norm
dist = norm(mean,std)

# EX: Comparing CDFs
# Evaluate the model CDF
xs = np.linspace(2, 5.5)
ys = dist.cdf(xs)

# Plot the model CDF
plt.clf()
plt.plot(xs, ys, color='gray')

# Create and plot the Cdf of log_income
Cdf(log_income).plot()

# Label the axes
plt.xlabel('log10 of realinc')
plt.ylabel('CDF')
plt.show()

# EX: Comparing PDFs
# Evaluate the normal PDF
xs = np.linspace(2, 5.5)
ys = dist.pdf(xs)

# Plot the model PDF
plt.clf()
plt.plot(xs, ys, color='gray')

# Plot the data KDE
sns.kdeplot(log_income)

# Label the axes
plt.xlabel('log10 of realinc')
plt.ylabel('PDF')
plt.show()

# Chapter 3 Relationships
# Lecture 3.1 exploring relationships
# Scatter plot
plt.plot(height, weight, 'o', alpha = 0.02, markersize = 1 )
# Jittering
height_jitter = height + np.random.normal(0,2,size = len(brfss))
weight_jitter = weight + np.random.normal(0,2,size = len(brfss))
plt.plot(height_jitter, weight_jitter, 'o', alpha = 0.02, markersize = 1 )
#Zoom
plt.axis([140,200,0,160])

#EX: PMF of age
# Extract age
age = brfss['AGE']

# Plot the PMF
Pmf(age).bar()

# Label the axes
plt.xlabel('Age in years')
plt.ylabel('PMF')
plt.show()

#EX: Scatter plot
# Select the first 1000 respondents
brfss = brfss[:1000]

# Extract age and weight
age = brfss['AGE']
weight = brfss['WTKG3']

# Make a scatter plot
plt.plot(age,weight,'o',alpha = 0.1)

plt.xlabel('Age in years')
plt.ylabel('Weight in kg')

plt.show()

# Jittring
# Select the first 1000 respondents
brfss = brfss[:1000]

# Add jittering to age
age = brfss['AGE'] + np.random.normal(0,2.5,size = len(brfss))
# Extract weight
weight = brfss['WTKG3']

# Make a scatter plot
plt.plot(age, weight, 'o',alpha = 0.2)

plt.xlabel('Age in years')
plt.ylabel('Weight in kg')

plt.show()

# Lecture 3.2 Visualize relationships
# Violin plot
data = brfss. dropna(subset = ['Age','wtkg3'])
sns.violinplot(x = 'age', y = 'wtkg3', data = data, inner = None)
plt.show()
sns.boxplot(x = 'age', y = 'wtkg3', data = data, whis = 10)
plt.yscale("log")
plt.show()

# Drop rows with missing data
data = brfss.dropna(subset=['_HTMG10', 'WTKG3'])

# Make a box plot
sns.boxplot(x = '_HTMG10', y = 'WTKG3', data = data, whis = 10)

# Plot the y-axis on a log scale
plt.yscale = ("log")

# EX: Height and weight
# Remove unneeded lines and label axes
sns.despine(left=True, bottom=True)
plt.xlabel('Height in cm')
plt.ylabel('Weight in kg')
plt.show()

# EX: Distribution of income
# Extract income
income = brfss['INCOME2']

# Plot the PMF
Pmf(income).bar()

# Label the axes
plt.xlabel('Income level')
plt.ylabel('PMF')
plt.show()

# EX: Income and height
# Drop rows with missing data
data = brfss.dropna(subset=['INCOME2', 'HTM4'])

# Make a violin plot
sns.violinplot('INCOME2', 'HTM4', data = data, inner = None)

# Remove unneeded lines and label axes
sns.despine(left=True, bottom=True)
plt.xlabel('Income level')
plt.ylabel('Height in cm')
plt.show()

# Lecture 3.3 Correlation
columns = ['HTM4','WTKG3','AGE']
subset = brfss[columns]
subset.corr()


# EX: Computing correlations
# Select columns
columns = ['AGE', 'INCOME2','_VEGESU1']
subset = brfss[columns]

# Compute the correlation matrix
print(subset.corr())

# Lecture 3.4 Simple Regression
from scipy.stats import linregress

res = linregress(xs, ys)
fx = np.array([xs.min(),xs.max()])
fy = res.intercept + res.slope*fx
plt.plot(fx,fy,'-')
data = brfss. dropna(subset = ['WTKG3','HTM4'])
xs = subset['HTM4']
ys = subset['WTKG3']
res = linregress(xs,ys)
fx = np.array([xs.min(),xs.max()])
fy = res.intercept + res.slope*fx
plt.plot(fx,fy,'-')

# EX:Income and vegetables
from scipy.stats import linregress

# Extract the variables
subset = brfss.dropna(subset=['INCOME2', '_VEGESU1'])
xs = subset['INCOME2']
ys = subset['_VEGESU1']

# Compute the linear regression
res = linregress(xs, ys)
print(res)

# EX: fit a line
# Plot the scatter plot
plt.clf()
x_jitter = xs + np.random.normal(0, 0.15, len(xs))
plt.plot(x_jitter, ys, 'o', alpha=0.2)

# Plot the line of best fit
fx = np.array([xs.min(),xs.max()])
fy = res.intercept + res.slope*fx
plt.plot(fx, fy, '-',alpha=0.7)

plt.xlabel('Income code')
plt.ylabel('Vegetable servings per day')
plt.ylim([0, 6])
plt.show()

# Chapter 4 Multivariate thinking
# Lecture 4.1 : Limits of simple regression
import statsmodels.formula.api as smf
result = smf.ols('INCOME2 ~ _VEGESU1', data = brfss).fit()
results.params

# EX: Using StatsModels
from scipy.stats import linregress
import statsmodels.formula.api as smf

# Run regression with linregress
subset = brfss.dropna(subset=['INCOME2', '_VEGESU1'])
xs = subset['INCOME2']
ys = subset['_VEGESU1']
res = linregress(xs,ys)
print(res)

# Run regression with StatsModels
results = smf.ols('INCOME2 ~ _VEGESU1', data= subset).fit()
print(results.params)

# Lecture 4.2 Multiple regression
results = smf.ols('INCOME2 ~ _VEGESU1 + age', data= subset).fit()
grouped = gss.groupby('age')
mean_income_by_age = grouped['realinc'].mean()
plt.plot(mean_income_by_age,'o', alpha = 0.5)
gss['age2'] = gss['age']**2
model = smf.ols('INCOME2 ~ _VEGESU1 + age + age2', data = gss)
results = model.fit()
results.params

# EX: Plot income and education
# Group by educ
grouped = gss.groupby('educ')

# Compute mean income in each group
mean_income_by_educ = grouped['realinc'].mean()

# Plot mean income as a scatter plot
plt.plot(mean_income_by_educ, 'o', alpha=0.5) # o means scatterplot point

# Label the axes
plt.xlabel('Education (years)')
plt.ylabel('Income (1986 $)')
plt.show()

# Non-linear model of education
import statsmodels.formula.api as smf

# Add a new column with educ squared
gss['educ2'] = gss['educ']**2

# Run a regression model with educ, educ2, age, and age2
results = smf.ols('realinc ~ educ + educ2 + age + age2', data = gss).fit()

# Print the estimated parameters
print(results.params)

# Lecture 4.3 Visualize the results
# Generating predictions
df['age'] = np.linespace(18,85) # The numpy.linspace() function returns number spaces evenly w.r.t interval.
df['age2'] = df['age']**2

df['educ'] = 12
df['educ2'] = df['educ']**2

pred12 = results.predict(df)

plt.plot(df['age'], pred12, label = 'highschool')
plt.plot(mean_income_by_age, 'o', alpha = 0.5)

# EX: Making predictions
# Run a regression model with educ, educ2, age, and age2
results = smf.ols('realinc ~ educ + educ2 + age + age2', data=gss).fit()

# Make the DataFrame
df = pd.DataFrame()
df['educ'] = np.linspace(0,20)
df['age'] = 30
df['educ2'] = df['educ']**2
df['age2'] = df['age']**2

# Generate and plot the predictions
pred = results.predict(df)
print(pred.head())

# EX: Visualizing predictions
# Plot mean income in each age group
plt.clf()
grouped = gss.groupby('educ')
mean_income_by_educ = grouped['realinc'].mean()
plt.plot(mean_income_by_educ, 'o', alpha = 0.5)

# Plot the predictions
pred = results.predict(df)
plt.plot(df['educ'], pred, label='Age 30')

# Label axes
plt.xlabel('Education (years)')
plt.ylabel('Income (1986 $)')
plt.legend()
plt.show()

# Lecture 4.4 Logistic Regression
formula = 'realinc ~ educ + educ2 + age + age2 + C(sex)'
result = smf.olf(formula, data = gss). fit()
results.params

# Boolean variable
gss['gunlaw'].value_counts()
gss['gunlaw'].replace([2],[0], inplace = True)
gss['gunlaw'].value_counts()
formula = 'realinc ~ educ + educ2 + age + age2 + C(sex)'
result = smf.logit(formula, data = gss). fit()
results.params

df = pd.DataFrame()
df['age'] = np.linespace(18,85) # The numpy.linspace() function returns number spaces evenly w.r.t interval.
df['age2'] = df['age']**2

df['educ'] = 12
df['educ2'] = df['educ']**2

df['sex'] = 1
pred1 = results.predict(df)
df['sex'] = 2
pred1 = results.predict(df)

grouped = gss.groupby('age')
favor_by_age = grouped['gunlaw'].mean()
plt.plot(favor_by_age, 'o', alpha = 0.5)

# EX: Predicting a binary variable
# Recode grass
gss['grass'].replace(2, 0, inplace=True)

# Run logistic regression
results = smf.logit('grass ~ age + age2 + educ + educ2 + C(sex)', data = gss).fit()
results.params

# Make a DataFrame with a range of ages
df = pd.DataFrame()
df['age'] = np.linspace(18, 89)
df['age2'] = df['age']**2

# Set the education level to 12
df['educ'] = 12
df['educ2'] = df['educ']**2

# Generate predictions for men and women
df['sex'] = 1
pred1 = results.predict(df)

df['sex'] = 2
pred2 = results.predict(df)

plt.clf()
grouped = gss.groupby('age')
favor_by_age = grouped['grass'].mean()
plt.plot(favor_by_age, 'o', alpha=0.5)

plt.plot(df['age'], pred1, label='Male')
plt.plot(df['age'], pred2, label='Female')

plt.xlabel('Age')
plt.ylabel('Probability of favoring legalization')
plt.legend()
plt.show()