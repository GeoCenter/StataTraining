

# Import useful functions -------------------------------------------------

# Workhorse libraries for data science: data cleanup, summaries, merging, etc.
library(dplyr) # Filter, create new variables, summarise, ... Basically, anything you can think to do to a dataset
library(tidyr) # Reshape and merge datasets
library(stringr) # String manipulation

# Incredibly powerful plotting library built off of the "Grammer of Graphics"
library(ggplot2)

# Libraries to help import files
library(haven) # Imports in files from Stata, SAS, and SPSS
library(readr) # An advanced form of the base 'read.csv' file with some added functionality.

# Problem -----------------------------------------------------------------


# Import the data ---------------------------------------------------------

spent = read_csv('~/GitHub/StataTraining/Data/Full_ForeignAssistanceData_spent.csv')

# Wait... that doesn't give me what I want.  There are two extra lines at the top.
# I need to specify where the header row is, and to skip the first rows.
spent = read_csv('~/GitHub/StataTraining/Data/Full_ForeignAssistanceData_spent.csv',
                 col_names = TRUE, skip = 2)

# Let's take a quick look at our data and make sure that everything is imported correctly.

# R has many redundant ways of doing things. Sometimes they're exactly the same 
# (with different details under the hood), and sometimes they're slightly different and complementary.
# In this case, 'glimpse' and 'summary' provide two quick looks at what a dataset looks like.

# 'glimpse' gives you the name of the variable, its type, and the initial values.
glimpse(spent)

# 'summary' similarly gives you the type of data, but also for numerical data, gives you 
# quick stats on the range of the data, the mean, and the distribution.
summary(spent)

# ... from either of those tests, we can identify one major problem.
# Amount -- which is the amount of money spent -- should be a number.  
# But since they're given as things like $5,238.23 in the dataset, they're imported as strings.
# Before we go any further, we need to fix that.

# Simple way-- reimport the data. If you specify 