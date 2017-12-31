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
# Remember to not put spaces in variable names

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

# 1. Create a new data frame that includes flights headed to SFO in February, and save 
# this data frame as `sfo_feb_flights`. How many flights meet these criteria?
sfo_feb_flights <- nycflights %>% filter(month == 2, dest == 'SFO')
nrow(sfo_feb_flights)

# 2. Make a histogram and calculate appropriate summary statistics for **arrival** 
# delays of `sfo_feb_flights`. Which of the following is false?
ggplot(sfo_feb_flights, aes(x=arr_delay)) + geom_histogram(binwidth=20)
sfo_feb_flights %>% summarise(mean_stat = mean(arr_delay), std_stat = sd(arr_delay), median_stat = median(arr_delay), n = n())

# dplyr's group_by functionality (very useful!)
nycflights %>% group_by(origin) %>% summarise(mean_stat = mean(arr_delay), std_stat = sd(arr_delay), median_stat = median(arr_delay), n = n())

# 3. Calculate the median and interquartile range for `arr_delay`s of flights in the 
# `sfo_feb_flights` data frame, grouped by carrier. Which carrier has the hights 
# IQR of arrival delays?
sfo_feb_flights %>% group_by(carrier) %>% summarise(median = median(arr_delay), interquartilerange = IQR(arr_delay))

# 4.  Which month has the highest average departure delay from an NYC airport? 
nycflights %>% group_by(month) %>% summarise(average_departure_delay = mean(dep_delay))

# 5.  Which month has the highest median departure delay from an NYC airport?
nycflights %>% group_by(month) %>% summarise(highest_median_departure_delay = median(dep_delay)) %>% arrange(desc(highest_median_departure_delay))
# Note how to use the arrange() function to display data accordingly!

# 6. Is the mean or the median a more reliable measure for deciding which month(s) to 
# avoid flying if you really dislike delayed flights, and why?
nycflights %>% group_by(month) %>% summarise(median_departure_delay = median(dep_delay), mean_departure_delay = mean(dep_delay))
ggplot(nycflights, aes(x = dep_delay)) + geom_histogram(binwidth=50)

# Instead of bar plots, we can plot side-by-side boxplots by
ggplot(nycflights, aes(x = factor(month), y = dep_delay)) + geom_boxplot()
# Remember that side-by-side plots require a categorical variable on the x-axis!

# Introducing a new column based on certain conditions using dplyr
# Suppose you will be flying out of NYC and want to know which of the 
# three major NYC airports has the best on time departure rate of departing flights. 
# Suppose also that for you a flight that is delayed for less than 5 minutes is 
# basically "on time". You consider any flight delayed for 5 minutes of more to be 
# "delayed".
# 
# In order to determine which airport has the best on time departure rate, 
# we need to 
# 
# - first classify each flight as "on time" or "delayed",
# - then group flights by origin airport,
# - then calculate on time departure rates for each origin airport,
# - and finally arrange the airports in descending order for on time departure
# percentage.
# 
# Let's start with classifying each flight as "on time" or "delayed" by
# creating a new variable with the `mutate` function.
nycflights <- nycflights %>% mutate(dep_type = ifelse(dep_delay < 5, "on time", "delayed"))

nycflights %>% group_by(origin) %>% summarise(on_percentage = sum(dep_type == 'on time')/n()) %>% arrange(desc(on_percentage))

# Visualize the above using a segmented bar plot
ggplot(data = nycflights, aes(x = origin, fill = dep_type)) + geom_bar()

# 8. Mutate the data frame so that it includes a new variable that contains the 
# average speed, `avg_speed` traveled by the plane for each flight (in mph). What is 
# the tail number of the plane with the fastest `avg_speed`? **Hint:** Average speed 
# can be calculated as distance divided by number of hours of travel, and note that 
# `air_time` is given in minutes. If you just want to show the `avg_speed` and 
# `tailnum` and none of the other variables, use the select function at the end of your 
# pipe to select just these two variables with `select(avg_speed, tailnum)`. You can 
# Google this tail number to find out more about the aircraft. 
nycflights <- nycflights %>% mutate(avg_speed = (distance*60)/(air_time))
nycflights %>% group_by(tailnum) %>% summarise(highest_avg_speed = max(avg_speed)) %>% arrange(desc(highest_avg_speed))

# 9. Make a scatterplot of `avg_speed` vs. `distance`. Which of the following is true 
# about the relationship between average speed and distance.
ggplot(nycflights, aes(x=distance, y=avg_speed)) + geom_point()

# 10. Suppose you define a flight to be "on time" if it gets to the destination on 
# time or earlier than expected, regardless of any departure delays. Mutate the data 
# frame to create a new variable called `arr_type` with levels `"on time"` and 
# `"delayed"` based on this definition. Then, determine the on time arrival percentage 
# based on whether the flight departed on time or not. What proportion of flights  that 
# were `"delayed"` departing arrive `"on time"`?
nycflights <- nycflights %>% mutate(arr_type = ifelse(arr_delay <= 0, "on time", "delayed"))
nycflights %>% filter(dep_type == 'delayed') %>% summarise(perc = sum(arr_type == 'on time')/n())
