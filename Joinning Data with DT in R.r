# Chapter 1: Joining Multiple data.tables
# Chapter 2: Joins Using data.table Syntax
# Chapter 3: Diagnosing and Fixing Common Join Problems
# Chapter 4: Concatenating and Reshaping data.tables

# Chapter 1: Joining Multiple data.tables
# Lecture 1.1 Welcome to the course
merge()
tables() # show you all data.tables
str()
demographics_all

#EX: Exploring data.tables
# What data.tables are in my R session?
tables()

# View the first six rows
head(netflix,6)
head(imdb,6)

# Print the structure
str(netflix)
str(imdb)

# Lecture 1.2 Merge function
merge(x = demographics, y = shipping, by.x = "name", by.y = "name") # inner join
merge(x = demographics, y = shipping, by = "name") # inner join
merge(x = demographics, y = shipping, by = "name", all = TRUE) # Full join

# EX: Inner Join
# Inner join netflix and imdb
merge(netflix, imdb, by = "title")

# EX: Full join
# Full join netflix and imdb
merge(netflix, imdb, by = "title", all = TRUE)
# Full join imdb and netflix
merge(imdb, netflix, by = "title", all = TRUE)

# Lecture 1.3 Left and right joins
merge(x = demographics, y = shipping, by = "name", all.x = TRUE) # left join
merge(x = demographics, y = shipping, by = "name", all.y = TRUE) # right join

#EX: Left join
# Left join imdb to netflix
merge(x = netflix,y = imdb, by = "title", all.x = TRUE)

#EX: Right join
# Right join imdb to netflix
merge(netflix,imdb,by = 'title', all.y = TRUE)
# Compare to a left join of netflix to imdb
merge(imdb, netflix, by = 'title', all.x = TRUE)

#EX: Mastering simple joins
# Identify the key for joining capitals and population
capitals_population_key <- 'city'
#tables()
# Left join population to capitals
capital_pop <- merge(capitals,population,by = capitals_population_key, all.x = TRUE)
capital_pop

# Identify the key for joining capital_pop and area
capital_pop_area_key <- 'state'

# Inner join area to capital pop
australia_stats <- merge(capital_pop,area, by = capital_pop_area_key)

# Print the final result
australia_stats

# Chapter 2: Joning using data.table syntax
# Lecture 2.1 data.table syntax
demographics[shipping, on = .(name)]
shipping[demographics, on = list(name)]
shipping[demographics, on = .(name)]
join_key <- c("name")
shipping[demographics, on = join_key]
shipping[demographics, on = .(name), nomatch = 0] # inner join
# no syntax for full join
merge(x = demographics, y = shipping, by = "name", all.x = TRUE)
demographics[!shipping, on = .(name)] # antijoin, filter dt to rows that have no match in another dt

# EX:Right join with the data.table syntax
# Right join population to capitals using data.table syntax
capitals[population, on = 'city']
# Right join using merge
merge(capitals, population, by = 'city', all.y = TRUE)

# EX: Inner join with the data.table syntax
# Inner join with the data.table syntax
capitals[population, on = 'city', nomatch = 0]

# EX: Anti-joins
# Anti-join capitals to population
population[!capitals, on = 'city']
# Anti-join capitals to area
area[!capitals, on = 'state']

# Lecture 2.2 Setting and viewing dt keys
setkey(DT,...)
setkey(DT,key1, key2, key3)
setkey(DT, 'key1', 'key2', 'key3')
keys <- c('key1', 'key2', 'key3')
setkeyv(dt,keys)
haskey(dt1)
key(dt1)

# EX: set keys
# Set the keys
setkey(netflix,'title')
setkey(imdb, 'title')

# Inner join
netflix[imdb, nomatch = 0]

#EX: getting keys
# Check for keys
haskey(netflix)
haskey(imdb)

# Find the key
the_key <- key(netflix)

# Set the key for the other data.table
setkeyv(imdb, the_key)

# Lecture 2.3 Incorporating joins into your dt workflow
# Chaining dt expressions
dt1[dt2,on][i,j,by]
customers[purchase,on = .(name)][sales > 1, j = .(avg_spent = sum(spent)/sum(sales)), by = .(gender)]
dt1[dt2, on, j]
customers[purchase,on = .(name), return_customer := sales > 1] # compute on j
dt1[dt2, on, j, by = .EACHI] # group j by each row from DT2
# dt2: join to what?
# on: on which key?
# j: what to do on columnes in DT1?
# grouped by what columes in DT1?
customers[purchase,on = .(name), j = .('# of shipping address' = .N), by = .EACHI] # group by matches

#EX: Exploring the Australian population
# Inner join capitals to population
capitals[population, on = 'city', nomatch = 0]
# Join and sum
population[capitals, on = .(city), nomatch = 0,
           j = sum(percentage)]

#EX: Finding multiple matches
# How many continents is each country listed in?
continents[life_exp, on = .(country), .N,
    by = .EACHI]
# What countries are listed in multiple continents?
continents[life_exp, on = .(country), .N,
           by = .EACHI][N > 1]

#EX: Exploring world life expectancy
# Calculate average life expectancy per continent:
avg_life_expectancy <- continents[life_exp, on = .(country),
                                  nomatch = 0][, j = mean(years),
                                       by = continent]
avg_life_expectancy

# Chapter 3: Complex keys
on = .(name = person)
on = c("name" = "person")
key <- c("name" = "person")
customers[web_visits, on = key]
merge(purchases, web_visits, by = c("name","date"))
merge(purchases, web_visits, by.x = c("name","date"), by.y = c("person","date"))
purchases[web_visits, on = .(name,date)]
purchases[web_visits, on = c('name','date')]
purchases[web_visits, on = .(name =  person,date)]
purchases[web_visits, on = .('name' =  'person', 'date')]

# EX: Keys with different names
# Full join
merge(students, guardians, by = 'name', all = TRUE)
# Left join
merge(students, guardians, by = "name", all.x = TRUE)
# Inner join
students[guardians, on = .(name), nomatch = 0]
# What are the correct join key columns?
students[guardians, on = .(guardian = name), nomatch = 0]

# EX: Multi-column keys
# Right join
subjects[locations, on = c("subject", "semester")] # result an error
# Structure
str(subjects)
str(locations)

# Does semester have the same class?
same_class <- FALSE
# Fix the column class
locations[, semester := as.integer(semester )]

# Right join
subjects[locations, on = c("subject", "semester")]

# EX: Multi-key, single-key
# Identify and set the keys
join_key <- c( 'topic' = 'subject')

# Right join
teachers[locations, on = join_key]

# Lecture 3.2 Tricky columns
parents[children, on = .(name = parent)]
merge(children, parents, by.x = "parent", by.y = "name", suffixes = c(".child", ".parent"))
setnames(parents, c("parent", "parent.gender", "parent.age"))
setnames(parents, old = c('gender', 'age'), new = c("parent.gender", "parent.age"))
parents <- as.data.table(parents, keep.rownames = "parent") # convert df to dt

# EX: Column name suffixes
# Inner join
capital_pop <- merge(capitals, population, by = c('city'), )

# Left join
merge(x = capital_pop, y = area, by = 'state', all.x = TRUE)
# Inner join from step 1
capital_pop <- merge(capitals, population, by = "city")

# Left join with suffixes
merge(capital_pop, area, by = "state", all.x = TRUE, suffixes = c(".pop", ".area"))

# EX: Joining a data.frame
# Convert netflix to a data.table
netflix_dt <- as.data.table(netflix,keep.rownames = "series")

# Right join
imdb[netflix_dt, on = c( 'title' = 'series')]

# Lecture 3.3 Duplicate matches
site1_ecology[site2_ecology, on = .(genius), allow.cartesian = TRUE]
merge(site1_ecology,site2_ecology, by = "genius", allow.cartesian = TRUE  )
!is.na()
site1_ecology <- site1_ecology[!is.na(genius)]
merge(site1_ecology,site2_ecology, by = "genius", mult = "first"  )
children[parents, on = .(parent = name), mult = 'last']
duplicated(site1_ecology, by = 'genius', fromLast = TRUE)
unique(site1_ecology, by = 'genius', fromLast = TRUE)

# EX: Joining with missing values
# Try an inner join
merge(cardio, heart, by = 'gene', allow.cartesian = TRUE)

# Filter missing values
heart_2 <- heart[!is.na(gene)]
cardio_2 <- cardio[!is.na(gene)]

# Inner join the filtered data.tables
merge(heart_2, cardio_2, by = 'gene')

# EX: Filtering duplicates
# Keep only the last probe for each gene
heart_3 <- unique(heart_2, by = 'gene', fromLast = TRUE)
cardio_3 <- unique(cardio_2, by = 'gene', fromLast = TRUE)

# Inner join
reproducible <- merge(heart_3, cardio_3, by = "gene", suffixes = c(".heart", ".cardio"))
reproducible

# EX: Joining and filtering duplicates
# Right join taking the first match
heart_2[framingham, on = 'gene', mult = "first" ]

# Anti-join
reproducible[!framingham, on = 'gene']

# Chapter 4 Concatenating and reshaping data.tables
# Lecture 4.1 Concatenating data.tables
# same columns, different data.tables
rbind() # concatenate rows from data. tables stored in different variables
rbindlist() # concatenate rows from a list of data.tables
rbind("2015" = sales_2015, "2016" =  sales_2016, idcol = "year") # idcol adds a column indicating origin

#Handling missing columns
rbind("2015" = sales_2015, "2016" =  sales_2016, idcol = "year", fill = TRUE)

table_files <- c("sales_2015.csv","sales_2016.csv")
list_of_tables <- lapply(table_files, fread)
rbindlist(list_of_tables)
names(list_of_tables) <- c("2015", "2016")
rbindlist(list_of_tables, idcol = 'year')

rbind("2015" = sales_2015, "2016" =  sales_2016, idcol = "year", use,names = FALSE) # allow concatenate columns with different names

#EX: Concatenating data.table variables
# Concatenate case numbers from weeks 50 and 51
rbind(ebola_W50, ebola_W51)
# Concatenate case numbers from all three weeks
rbind(ebola_W50, ebola_W51, ebola_W52) # error
# Modify the code
rbind(ebola_W50, ebola_W51, ebola_W52, fill = TRUE)

#EX: Concatenating a list of data.tables
# Concatenate its data.tables
gdp_all_1 <- rbindlist(gdp)
# Concatenate its data.tables
gdp_all_2 <- rbindlist(gdp, idcol = "continent")
# Run this code to inspect gdp_all_2
gdp_all_2 <- rbindlist(gdp, idcol = "continent")
str(gdp_all_2)
gdp_all_2[95:105]

# Fix the problem
gdp_all_3 <- rbindlist(gdp, idcol = "continent", fill = TRUE)
gdp_all_3

# Lecture 4.2 Set operations
fintersect(dt1, dt2, all = TRUE) # what rows do these two data.tables share in common?
funion(dt1, dt2, all = TRUE) # what is the unique set of rows across these two data.set?
fsetdiff(dt1, dt2, all= TRUE) # what rows are unique rows in the first dt?

# 2dt: use funion()
# > 3 dts: rbind(), remove using duplicated() and unique()

# EX: Identifying observations shared by multiple tables
# Obtain countries in both Asia and Europe
fintersect(gdp$europe, gdp$asia)

# Concatenate all data tables
gdp_all <- rbindlist(gdp)

# Find all countries that span multiple continents
gdp_all[duplicated(gdp_all)]

# Removing duplicates while combining tables
# Get all countries in either Asia or Europe
funion(gdp$asia, gdp$europe)

# Concatenate all data tables
gdp_all <- rbindlist(gdp)

# Print all unique countries
unique(gdp_all)

# EX: Identifying observations unique to a table
# Which countries are in Africa but not considered part of the middle east?
fsetdiff(gdp$africa, middle_east)

# Which countries are in Asia but not considered part of the middle east?
fsetdiff(gdp$asia, middle_east)

# Which countries are in Europe but not considered part of the middle east?
fsetdiff(gdp$europe, middle_east)

#Lecture 4.3 Melting data.tables
melt(sales_wide, measure.vars = c("2015", "2016"))
melt(sales_wide, measure.vars = c("2015", "2016"), variable.name = "year", value.name = "amount")
melt(sales_wide, id.vars = "quarter", variable.name = "year", value.name = "amount")
melt(sales_wide, id.vars = "quarter", measure.vars = "2015", variable.name = "year", value.name = "amount") #2016 will be droped

#EX: Melting a wide table
# Print gdp_per_capita
gdp_per_capita

# Reshape gdp_per_capita to the long format
melt(gdp_per_capita, id.vars = "year")
# Rename the new columns
melt(gdp_per_capita, id.vars = "year",
     variable.name = 'country', value.name = 'gdp_pc')

# EX: More melts
# Print ebola_wide
ebola_wide

# Stack Week_50 and Week_51
melt(ebola_wide, measure.vars = c("Week_50", "Week_51"), variable.name = "period", value.name = "cases")

# Lecture 4.4 Casting data.tables
sales_wide <- dcast(sales_long, quarter ~ year, value.var = c("amount", "profit"))
sales_wide <- dcast(sales_long, quarter + season ~ year, value.var = c("amount", "profit"))
sales_wide <- dcast(sales_long, quarter ~ department + year, value.var = c("amount", "profit"))
mat <- as.matrix(sales_wide, rownames = " season")

#EX: Casting a long table
# Split the population column by year
dcast(gdp_oceania, formula = country ~ year, value.var = "population")
# Split the gdp column by country
dcast(gdp_oceania, country ~ year, value.var = 'gdp')
# Split the gdp column by country
dcast(gdp_oceania, year ~ country , value.var = 'gdp')

#EX: Casting multiple columns
# Split the gdp and population columns by year
dcast(gdp_oceania, formula =  country~ year, value.var = c('gdp','population'))
# Reshape from wide to long format
wide <- dcast(gdp_oceania, formula = country ~ year, value.var = c("gdp", "population"))

# convert to a matrix
as.matrix(wide, rownames = "country")

# Modify your previous code
dcast(gdp_oceania, formula = country + continent ~ year, value.var = c("gdp", "population"))

#EX: Splitting by multiple groups
# Split gdp by industry and year
dcast(gdp_by_industry_oceania, country ~ industry + year, value.var = 'gdp')






