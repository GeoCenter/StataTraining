## Homework Day 3
<br>
### Introduction
When we conduct analysis, rarely do we handed a clean dataset right from the start and just have dig into the numbers for some answers. For this week’s homework, we’re going to walk through a typical process for data munging and  then do a little bit of work with our final dataset. We'll be combining a number of topics we've covered over the past few weeks, so have your cheatsheets at the ready (but don't worry, we'll help you walk through the process).

Our homework will involve working with the [World Banks World Development Indicators] (http://data.worldbank.org/data-catalog/world-development-indicators) to answer a series of questions/tasks.
- What was the average percent of the workforce employed in agriculture by region in 2012?
- How many people had access to improved sanitation in 2012 by region?
- Create a scatter plot of improved sanitation versus the percent of the population living in rural areas in 2010.
- How has population growth changed over the period of 2003-2012 in different income levels?

To answer these questions, we have provided you with raw data files downloaded directly from [WDI] (http://data.worldbank.org/data-catalog/world-development-indicators). To answer these questions, we need to start with our raw data, import it, "clean" it, and create a final dataset to perform our anylysis on.

Assignments through out the walk through will look like this:
> A.1 Import data

### Part A - Import and Explore the data
The first stage of any analysis is getting the data setup and imported in our program. To do so, we want to start by identifying a directory of where the files are saved and see what files we have saved in there
```
*set working directory
    cd "~\Data Analysis Training\Day3HW\"
*lists files in the directory
    ls 
```
Now, let's import some data. All the files are set up in the same structure, just with different data. Let's import one of them to see what it looks like
> A.1 Import one data set
> - check out `help import excel` for help
> - your options (after the comma) should look like this `[command] ..., sheet("Data") cellrange(A4:BH252) firstrow clear'
>- dig into the data using commands like `browse`, `describe`, and `codebook`

Looking at the data, we can see there is only one indicator per file and the data is not "tidy". We can reshape long using the year variable. And as we see here, Stata cannot interpret variables that start with or are entirely numbers as indicator names. We will need to adjust this later, changing the varaibles to `y1960 y1961 y1962 ...`. On a good note, the string variables (country name, indicator, etc) imported as string and the numberic variables imported as numbers, so we don't need to destring any of the variables.

Rather than reshaping the file multiple times, we can append all the data together first and then we will only need one reshape. Instead of going through importing each data set individually into Stata and then saving it as a .dta file, we can run it through a loop. 

> A.2 Loop import over each of the indicator files 
> - import file
> - replace `IndicatorCode` with the indictor file name [for reshaping]
> - saves as .dta 
> - set a local macro ("vars") with the names of each file
>     * `local vars ag_empl chldmort electricity  health_exp_pc hivprev pop pop_rural sanitation`
> - check out `help foreach' on using a loop with a macro
> - use the import command line you used in A.1, replacing the indicator with *lname* ("x").
> ```
> foreach x of local vars{
>   import excel "~\Data Analysis Training\Day3HW\`x'", clear ...  
>   replace IndicatorCode = `x'	   
>   save ...
>  }
>```


The WDI files have another tab that includes "meta data" for each country, i.e. region, income level. It would be good to include these data in our final dataset.

> A.3 Import country meta data
> - Use the command used in A.1 on one indicator to import the Metadata sheet (you will not need to indicate a cell cell range)
> - encode region and income level, generating new variables called `reg` and `inc` and dropping the old variables afterward
> - see `help encode` for how to encode a variable and generate a new variable from this
> - make sure to save this as a .dta file

### Part B - Append, Reshape, and Clean Data
Now that we have all the data in Stata format (.dta), we can append all the files together so we can start using it to answer our questions. After it's appended we need to reshape the data **twice**. 

> B.1 Append files together
> - start by opening up one of your indicator files and append the other files onto
> ```
> use ..., clear
> append ...
> ```
> - see `help append` on how this works (note: you can append multiple files at the same time

Now that we have all the data together in one file, its time for us to start cleaning up the data a bit. The first we should so is reshape it. But before we can do that, we need to rename all our year variables to look like to `y1960 y1961 y1962 ...`.

> B.2 - Rename years (loop) and drop unnessary years
> - look through `help foreach` to figure out how to setup a loop over variables (I'll help you through the rest of the code)
> - we will use `year` for our *lname*
> ```
> foreach year ...{
>    local l`year' : variable label `year'
>	rename `year' y`l`year''
>	}
> ```
> - so, for a little more of what's going on in this loop, we are telling Stata to place in memory the variable label for each indicator e.g. for `E` the variable label is `1960`, and we are then renaming the variable with the label, e.g. `E` becomes `y1960`.
> - since we only need to observe variables during 2002-2012, you can drop all the other years
> - see `help drop`

Now that we have the years labeled correctly (and we have our stub of `y`, we can start our initial reshape. We can tidy up our data by having all of the years in one column and all the data in another.

> B.3 - Reshape 1
> - reshape so that you have one column for year and one for all your data
> - see `help reshape`
> - after reshaping, run the following code to do some more cleaning of the data
> ```
> drop IndicatorName //not needed; will be in variable label
>	encode IndicatorCode, gen(ind) //need to encode for reshape
>	drop IndicatorCode //no longer needed
>	order CountryName CountryCode year ind y //reorder for viewing when browsing
>	lab list ind //list for labeling variables after reshape
>```

So, we have all the years and data in two columns, but this still isn't tidy. It will be extremely useful for our analysis to have each WDI indicator as a seperate variable/column. You know what that means...a second reshape!

> B.4 - Reshape 2
> - reshape your data so in addition to your year column you will break your data column out by indicator, so you will have a seperate column per indicator
> - see `help reshape`

With this reshape, we lost the names of our indicators and they are now just numbered stubs. Luckily we ran `lab list ind` prior to our reshape and know what the variable are.

| n | var | varlabel |
|---|---------------|--------------------------------------------------------------|
| 1 | ag_empl | Employment in agriculture (% of total employment) |
| 2 | chldmort | Mortality rate, under-5 (per 1,000) |
| 3 | electricity | Access to electricity (% of population) |
| 4 | health_exp_pc | Health expenditure per capita (current US$) |
| 5 | hivprev | Prevalence of HIV, total (% of population ages 15-49) |
| 6 | pop | Population, total |
| 7 | pop_rural | Rural population (% of total population) |
| 8 | sanitation | Improved sanitation facilities (% of population with access) |

> B.5 - Label and rename variables
> - Rename each variable with its correct name and variable labels
> - see `help rename` and `help label`  

### Part C - Merge and Save Data

Hopefully you didn't forget about the metadata file we saved at the beginning. Now that we have our data together, we can merge the meta data with it.

> C.1 - Merge metadata onto datafile
> - since our "master" dataset has multiple country observations and and our merge file only has one observation per country, we will be using a many to one merge
> - locate the path of your country metadata file and merge this file with the appended dataset
> - since everything should merged (other than unclassificed), we don't need the generated variable so you can `drop _merge`
> - see `help merge`

Just a little bit of cleaning using the code below and we'll have a final dataset to use for our analysis!
```
rename CountryName ctry
rename CountryCode iso
   lab var iso "ISO Country Code"
   lab var year "Year"
order reg inc, before(ag_empl)
```

> C.2 - Save
> - its always good to save your dataset so you don't have to rerun your do file every time you need it
> - see `help save`


### Part D - Analysis

Wow, so it took quite a bit of work to get a working dataset to use for our analysis. Now that the hard part is out of the way, let's try to answer those initial questions.

> D.1 - What was the average percent of the workforce employed in agriculture by region in 2012?
> - see `help tabstat` to see how to structure this command and how to include the options you need to get at this answer

> D.2 - How many people had access to improved sanitation in 2012 by region?
> - you will need to generate a new variable as your first step 
> - see `help tabstat` 

> D.3 - Create a scatter plot of improved sanitation versus the percent of the population living in rural areas in 2010.
> - remember that the y variable goes before the x variable in our command for graphs
> - see `help scatter' or check out [Stata Graphs] (http://www.stata.com/support/faqs/graphics/gph/stata-graphs/) 

> D.4 - How has population growth changed over the period of 2003-2012 in different income levels?
> - it will be usefull to use the `collapse` command, aggregating up the sum by income level and year
> - Population growth in 2016 would look like
>     * ` popgrowth_16 = (pop_16 - pop_15)/pop_15`
> - in order to get the year before the observation, you will want to make sure you first sort (`sort inc year`) and then use `pop[_n-1]`, where `_n` is the number of the current observation.
> - see `help _n`
> - since this is a time series, it would be good to use a `line` or `connected` plot if you are going to graph this.
> - it will be useful to break the graphs into [small multiples] (https://en.wikipedia.org/wiki/Small_multiple), using the `by` option
> - see `help line`, `help connected` or check out [Stata Graphs] (http://www.stata.com/support/faqs/graphics/gph/stata-graphs/)  