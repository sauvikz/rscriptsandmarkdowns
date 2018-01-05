library(statsr)
library(dplyr)
library(ggplot2)

# Load the dataset 
data(kobe_basket)

# Check the dataset
head(kobe_basket)
str(kobe_basket)
class(kobe_basket)
summary(kobe_basket)

# What were the number of hits and misses in Game 1 and Quarter 1?
table(kobe_basket %>% filter(game == 1, quarter == 1) %>% select(shot))
# Hence 3 Hits and 6 Misses

# Counting streak lengths manually for all 133 shots would get tedious, so we'll
# use the custom function `calc_streak` to calculate them, and store the results
# in a data frame called `kobe_streak` as the `length` variable.

kobe_streak <- calc_streak(kobe_basket$shot)

# Plot the distribution of streak lengths
ggplot(kobe_streak, aes(x=length)) + geom_histogram(binwidth = 1,col="white",alpha=0.5,fill="orange")
# Note that kobe_streak actually has a *name* called *length* attached to it
# Also Note the col, alpha and fill arguments

# Note the result of table(kobe_streak) is -> 
# kobe_streak
# 0  1  2  3  4 
# 39 24  6  6  1

# And other stats related to the distribution is
kobe_streak %>% summarise(median = median(length), mean = mean(length), sd = sd(length), size = n(), IQR = IQR(length))
#      median      mean        sd        size  IQR 
# 1      0       0.7631579    0.9915432   76    1

# Simulate a single coin-flip
coin_outcomes <- c("heads", "tails")
sample(coin_outcomes, size=1, replace=TRUE)

# Simulate a coin-flip 100 times and check for the results
sim_fair_coin <- sample(coin_outcomes, size=100, replace=TRUE)
sim_fair_coin
table(sim_fair_coin)

# Simulate a biased coin-flip where the probability of heads is 20%
sim_unfair_coin <- sample(coin_outcomes, size=100, replace=TRUE, prob=c(0.2,0.8))
sim_unfair_coin
table(sim_unfair_coin)

# Simulate a single shot from an independent shooter with a shooting percentage of 50%
shot_outcomes <- c("H","M")
sim_basket <- sample(shot_outcomes, size=1, replace=TRUE)

# What change needs to be made to the sample function so that it reflects a shooting percentage of 45%? 
# Make this adjustment, then run a simulation to sample 133 shots. 
# Assign the output of this simulation to a new object called sim_basket
sim_basket <- sample(shot_outcomes, size=133, replace=TRUE, prob=c(0.45,0.55))
table(sim_basket)

# Using calc_streak, compute the streak lengths of sim_basket, and save the results in a data frame called sim_streak. 
# Note that since the sim_streak object is just a vector and not a variable in a data frame, 
# we don???t need to first select it from a data frame like we did earlier when we calculated the streak lengths for Kobe???s shots.
sim_streak <- calc_streak(sim_basket)

# Make a plot of the distribution of simulated streak lengths of the independent shooter. 
# What is the typical streak length for this simulated independent shooter with a 45% shooting percentage? 
# How long is the player???s longest streak of baskets in 133 shots?
ggplot(sim_streak, aes(x=length)) + geom_histogram(binwidth=1,col="white",alpha=0.5,fill="orange")
sim_streak %>% summarise(median = median(length), mean = mean(length), sd = sd(length), size = n(), IQR = IQR(length))
table(sim_streak)

