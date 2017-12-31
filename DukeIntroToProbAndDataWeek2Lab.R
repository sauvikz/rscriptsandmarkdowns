# Duke University's Intro to Probability and Data's Week 2 Lab
install.packages("devtools")
library(devtools)
install.packages("dplyr")
install.packages("ggplot2")
install.packages("shiny")
install_github("StatsWithR/statsr")

# Use packages

library(statsr)
library(dplyr)
library(ggplot2)

# Load the data
data(nycflights)

# Check the data
head(nycflights)

# Check all relevant data
# Check data-type
clasS(nycflights)

# Check data.frame summary ie. column summaries
summary(nycflights)

# Check structure of data.frame ie. data-types of every columns/variable as well as the data.frame's dimensions
str(nycflights)

# nrow() and ncol() will give you number of rows/observations and columns/variables respectively
# Remember the difference between data.frame and matrices in R. Dataframes can contain a mixture of data-types whereas matrices can't

# View the names of variables
names(nycflights)
# Can also do colnames(nycflights) here; Similarly rownames(nycflights) if rows are named otherwise you'll just get indices

# Many datasets might have additional information that can be viewed by ?dataset; in this case ?nycflights gives you additional information

# control + shift + c in Mac will comment out multiple lines!

# The `dplyr` package offers seven verbs (functions) for basic data 
# manipulation:
#   
# - `filter()`
# - `arrange()`
# - `select()` 
# - `distinct()`
# - `mutate()`
# - `summarise()`
# - `sample_n()`

# Histograms can be plotted by the hist() function, let's plot it for `dep_delay`
# This is the format: hist(data,breaks=seq(min(data),max(data),l=number_of_bins+1))
hist(
  nycflights$dep_delay, 
  breaks=seq(min(nycflights$dep_delay), max(nycflights$dep_delay), l=21), 
  col="orange", 
  main="Histogram", 
  xlab="Delay", 
  ylab="Freq"
)

# This can also be done by using ggplot! (Remember the package is ggplot2 but the function is just called ggplot())
ggplot(data = nycflights, aes(x = dep_delay)) + geom_histogram()
# Notice the format of aes() above! If you want bins
ggplot(data = nycflights, aes(x = dep_delay)) + geom_histogram(binwidth=20)
# Remember this is binwidth and not number of bins, so higher the binwidth, lesser number of bins/buckets

# Comapre these graphs (par(mfrow=c(x,x)) will not work for ggplot)
ggplot(data = nycflights, aes(x = dep_delay)) + geom_histogram()
ggplot(data = nycflights, aes(x = dep_delay)) + geom_histogram(binwidth=15)
ggplot(data = nycflights, aes(x = dep_delay)) + geom_histogram(binwidth=150)

# Let's check for departure delays of flights headed only to 'RDU' ie. dest = 'RDU'
# This subsetting can be done in R Base by using the subset function as well as dplyr. Let's do both!

# Using R Base's subset() function
subset(nycflights, subset = dest == 'RDU')

# Using dplyr
rdu_flights <- nycflights %>% filter(dest == "RDU")

# Let's plot the above
ggplot(rdu_flights, aes(x=dep_delay)) + geom_histogram()

# dplyr's summarise function
nycflights %>% summarise(mean_dd = mean(dep_delay), sd_dd = sd(dep_delay), n = n())
# Remember mean_dd, sd_dd and n are user defined variables and so the nomenclature can be changed! n() is the sample size

# Some useful function calls for summary statistics for a 
# single numerical variable are as follows:
#   
# - `mean`
# - `median`
# - `sd`
# - `var`
# - `IQR`
# - `range`
# - `min`
# - `max`

# Subsetting on multiple criteria. Again this can be done using R Base's subset() function as well as dplyr
# Suppose we are interested in flights headed to San Francisco (SFO) in February

# Using R Base's subset() function
subset(nycflights, subset = (month == 2) & (dest == 'SFO'))

# Using dplyr
nycflights %>% filter(month == 2, dest == 'SFO')
# The above is same as nycflights %>% filter((month == 2) & (dest == 'SFO')), replace with '|' if you want to use OR


