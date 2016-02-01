## Homework Day 3
<br>
### Introduction
When we conduct analysis, rarely are we handed a clean dataset right from the start and just have dig into the numbers for some answers. For this week’s homework, we’re going to walk through a typical process for data munging and then do a little bit of work with our final dataset. We'll be combining a number of topics we've covered over the past few weeks, so have your [cheat sheets] (https://github.com/GeoCenter/StataTraining/tree/master/Cheat%20Sheets) at the ready (but don't worry, we'll help you walk through the process).

Your homework will involve working with select indicators from the [World Banks World Development Indicators (WDI)] (http://data.worldbank.org/data-catalog/world-development-indicators) to answer the following series of questions/tasks.
	
- What was the average percent of the workforce employed in agriculture by region in 2012?
- How many people had access to improved sanitation in 2012 by region?
- Visualize the relationship between access to improved sanitation and size of a country's rural population in 2010 via a scatter plot.
- How has population growth changed over the period of 2003-2012 across different country income level groups?

We have provided you with raw data files downloaded directly from WDI, which you can acess and **[download from here] (https://github.com/GeoCenter/StataTraining/tree/master/Day3/Homework/WDI_Data)**. To answer these questions, we need to start with our raw data, import it, "clean" it, and create a final dataset to perform our analysis on.

Assignments through out the walk through will look like this:
> **X.1 Derive demand**
> - [hint/guidance]
> -...

### Overview
Before we dive into our analysis, let's develop a plan of action.Thinking about where we need to get to, I forsee breaking our homework into four parts: (a) import/explore, (b) append, reshape, and clean, (c) merge, and (d) analyze.  In Part A, we'll introduce you to loops which is not an easy concept. If you are up for it, we'd like you to take a stab at it, but its completely up to you. If you don't have time or are getting stuck, we've provided the [WDI data in .dta format] (https://github.com/GeoCenter/StataTraining/tree/master/Day3/Homework/WDI_Data) so you can jump right into the data analysis and manipulation in Part B.

- Part A - Import and Explore (Optional Section)
    - Review one WDI excel file
	- Import files via a loop
	- Import country meta data
- Part B - Append, Reshape and Clean
	- Append all WDI .dta files together
	- Rename years
	- Reshape twice
	- apply variable names and labels
- Part C - Merge and Save
	- Merge meta data onto appended dataset
	- Save as .dta file
- Part D - Analysis
	- Answer questions for analysis


### Part A - Import and Explore the data
*This is an option section. If you do not have enough time to complete or are having through getting through this section, you can skip to Part B and [access the .dta files] (https://github.com/GeoCenter/StataTraining/tree/master/Day3/Homework/PartB_WDI_Data_STATA).*

If you have not already done so, you will need to download the files we're working from the **[WDI_Data folder] (https://github.com/GeoCenter/StataTraining/tree/master/Day3/Homework/WDI_Data)**. 

The first stage of any analysis is getting the data setup and imported in our program. Let's open up a do file and get to work! To get started, we want to identify the directory where the files are saved and see what files we have saved in there. You can use the commands below to perform this task, replacing the file path with your local directory.
```
*set working directory (where data is saved)
    cd "~\Data Analysis Training\Day3\Homework\WDI_Data"
*lists files in the directory
    ls 
```
Now, let's import some data. All the files are set up in the same structure, just with different data. Let's import one of them to see what it looks like, so let's start with the `ag_empl.xlsx` file in our set of data files.
> **A.1 Import one data set**
> - check out `help import excel` for help
> - your options (after the comma) should look like this 
> `[command] ..., sheet("Data") cellrange(A4:BH252) firstrow clear`
>     * `sheet("Data")` - this will pull the data we need in from the tab labeled "Data" in the Excel file
>     * `cellrange(A4:BH252)` - here, we're telling Stata to adjust the first row it pulls in. WDI adds some headers rows. Remember we want the first row to be variable names and for the data to start on the second row.
>     * `firstrow` - this option tells Stata the first row of the dataset is indeed variable name, not data.
>     * `clear` - and finally, we are telling Stata to clear out any datasets that may be currently stored in the directory
> - dig into the data using commands like `browse`, `describe`, and `codebook`

Looking at the data, we can see there is only one indicator per file (in this case, its Agricultural Employment as a percent of the overall workforce) and the data is not "tidy". We can reshape long using the year variable. And as we see here, Stata cannot interpret variables that start with or are entirely numbers as indicator names; instead, we are just given letters as variable names in place of the year. We will need to adjust this later, changing the variables to `y1960 y1961 y1962 ...`. On a lighter note, the string variables (country name, indicator, etc) imported as string and the numeric variables imported as numbers, so we don't need to destring any of the variables.

Rather than reshaping each file, we can append all the data together first and then we will only need conduct the reshape on one dataset. Instead of going through importing each data set in our downloaded file individually into Stata and then saving it as a .dta file, we can run it through a loop. We will need to import all eight files in the folder (one for each variable) and append them together.

> **A.2 Loop import over each of the indicator files**
> - review the setup `help foreach` for a loop using `in`
> - your loop should contain 3 lines of code within it: 
>     * `import` indicator file from downloaded folder
>     * `replace` `IndicatorCode` with the indictor file name for reshaping. For example, when import the ag_empl.xlsx file, the `IndicatorCode` will list the WDI code for this variable, "SL.AGR.EMPL.ZS", which is not very meaningful to us. Instead, we will replace "SL.AGR.EMPL.ZS" with "ag_empl" and will use this in the reshape later on, so that the variable will be named `ag_empl`
>     * `save` as .dta file 
> - use the import command line you used in A.1, replacing the indicator with *lname* ("``` `x' ```").
> - your code should look very similar to what is listed below
> ```
> foreach x in ag_empl chldmort electricity health_exp_pc hivprev pop pop_rural sanitation{
>   import excel "~\Data Analysis Training\Day3\Homework\WDI_Data\`x'", clear ...  
>   replace IndicatorCode = "`x'""	   
>   save ...
>  }
>```

All the WDI files also include another tab that contains "meta data" for each country, i.e. region, income level. It would be good to include this information in our final dataset. Since the meta data tab is the same in all the files, we only need to import one file (eg ag_empl.xlsx).

> **A.3 Import country meta data**
> - Use the command used in A.1 on one indicator to import the Metadata sheet (you will not need to indicate a cell cell range as it variables names start on the first row)
> - The regions and income levels are currently strings/text. It's useful to convert these to number and apply a variable label to them. Rather than doing this by hand, we can use the `encode` commandand generate a new variable. Encode region and income level, generating new variables called `reg` and `inc` and dropping the old variables afterward
> - see `help encode` for how to encode a variable and generate a new variable from this
> - make sure to save this as a .dta file

### Part B - Append, Reshape, and Clean Data
*If you are starting here, be sure to [download the WDI data in Stata format] (https://github.com/GeoCenter/StataTraining/tree/master/Day3/Homework/PartB_WDI_Data_STATA)*

Now that we have our data in Stata format (.dta), we can append all the files together so we can start using it to answer our questions. After it's appended we need to reshape the data **twice**. 

> **B.1 Append files together**
> - start by opening up one of your indicator .dta files (eg `ag_empl.dta`) and append the other files onto it
> ```
> use ..., clear
> append ...
> ```
> - see `help append` on how this works (note: you can append multiple files at the same time

Now that we have all the data together in one file, it's time for us to start cleaning up the data a bit. The first we should so is reshape it. But before we can do that, we need to rename all our year variables, adding a `y` stub to the year, so they will look like `y1960 y1961 y1962 ...`.

We could rename each of the year variables by hand, but it would take a while. It would look something like this:
 ```
  *rename each indicator manually
    rename E y1960
    rename F y1961
    ...etc
```
Instead, we can take advantage of loops and macros. We can use a macro that stores variable label and apply this as the variable name (the variable label is the year).
```
  *using a macro to take the variable label and assign it as the variable name
    local yearlabel : variable label E //the variable label is 1960
    rename E y`yearlabel' //adding on y to the beginning since Stata variables cannot start with numbers
    *E would be renamed y1960 
 ``` 
 
So, that's the gist of it. Now we just need to add this too a loop to go through all our year variables.

> **B.2 - Rename years (loop) and drop unnecessary years**
 Look through `help foreach` to figure out how to setup a loop over a series of variables (I'll help you through the rest of the code)
>     * we will use `year` for our *lname* [indicated in the `help` file]
> ```
> foreach year ...{
>    local l`year' : variable label `year'
>    rename `year' y`l`year''
>	}
> ```
> - so, for a little more of what's going on in this loop, we are telling Stata to store in its memory the variable label for each indicator e.g. variable `E`'s label is `1960`, and we are then renaming the variable with its label, e.g. `E` becomes `y1960`.
> - since we only need to observe variables during 2002-2012, you can drop all the other years
> - see `help drop`

Now that we have the years labeled correctly and we have our stub of `y` before each year, we can start our initial reshape. We can tidy up our data by having all of the years in one column and all the data in another.

We want our data table to go from this:

| CountryName | CountryCode | IndicatorName                                     | IndicatorCode | y2002 | y2003 | y... |
|-------------|-------------|---------------------------------------------------|---------------|-------|-------|------|
| Aruba       | ABW         | Employment in agriculture (% of total employment) | ag_empl       |       |       |      |
| Andorra     | AND         | Employment in agriculture (% of total employment) | ag_empl       |       |       |      |

And reshape to look like this:

| CountryName | IndicatorName                           | year | CountryCode | IndicatorCode | y |
|-------------|-----------------------------------------|------|-------------|---------------|---|
| Afghanistan | Access to electricity (% of population) | 2002 | AFG         | electricity   |   |
| Afghanistan | Access to electricity (% of population) | 2003 | AFG         | electricity   |   |

> **B.3 - Reshape 1 (Long)**
> - reshape so that you have one column for year and one for all your data
> - see `help reshape`
> - after reshaping, run the following code to do some more cleaning of the data
> - during the data cleaning, we'll want to encode `IndicatorCode`. As we saw in A.3, encoding allows us to take our a string/text variable, convert it to a number and add the string as a variable label. Converting `IndicatorCode` to an encoded variable will allow us to reshape since we can't reshape on a string variable.
> ```
> *cleaning
>   drop IndicatorName //not needed; will be in the variable label
>	encode IndicatorCode, gen(ind) //need to encode prior to reshaping
>	drop IndicatorCode //no longer needed since we have the new variable ind
>	order CountryName CountryCode year ind y //reorder for viewing purposes when browsing
>	lab list ind //list for labeling variables after reshape
>```

So, we have years and data in two columns, but this still isn't tidy. It will be extremely useful for our analysis to have each WDI indicator as a separate variable/column. You know what that means...a second reshape!

We're starting with this:

| CountryName | CountryCode | year | ind         | y |
|-------------|-------------|------|-------------|---|
| Afghanistan | AFG         | 2002 | electricity |   |
| Afghanistan | AFG         | 2003 | electricity |   |

And want to reshape to look like this:

| CountryName | CountryCode | year | ag_empl | chldmort | etc... |
|-------------|-------------|------|---------|----------|--------|
| Afghanistan | AFG         | 2002 |         | 130.3    |        |
| Afghanistan | AFG         | 2003 |         | 126.8    |        |

> **B.4 - Reshape 2 (Wide)**
> - reshape your data so in addition to your year column you will break your data column out by indicator, so you will have a separate column per indicator
> - see `help reshape`

With this reshape, we lost the names of our indicators and they are now just `y1-y8`. Luckily we ran `lab list ind` prior to our reshape and know which variables are which.

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

> **B.5 - Label and rename variables**
> - Rename each variable with its correct name and variable labels
> - see `help rename` and `help label`  

### Part C - Merge and Save Data

Hopefully you didn't forget about the metadata file we saved at the beginning. Now that we have our data together, we can merge the meta data with it.

> **C.1 - Merge metadata onto datafile**
> - since our "master" dataset has multiple country observations and and our merge file only has one observation per country, we will be using a **many to one merge**
> - locate the path of your country metadata file and merge this file with the appended dataset
> - since everything should have merged (other than unclassified), we don't need the generated variable so you can `drop _merge`
> - see `help merge`

With a little bit of cleaning using the code below, we'll have a final dataset to use for our analysis! Run the commands below and then save the data file.
```
*more cleaning
  rename CountryName ctry
  rename CountryCode iso
  lab var iso "ISO Country Code"
  lab var year "Year"
  order reg inc, before(ag_empl)
```

> **C.2 - Save**
> - its always good to save your dataset so you don't have to rerun your do file every time you need it
> - see `help save`


### Part D - Analysis

Wow, so it took quite a bit of work to get a working dataset to use for our analysis. Now that the hard part is out of the way, let's try to answer those initial questions.

> **D.1 - What was the average percent of the workforce employed in agriculture by region in 2012?**
> - see `help tabstat` to see how to structure this command and how to include the options you need to get at this answer

> **D.2 - How many people had access to improved sanitation in 2012 by region?**
> - you will need to generate a new variable as your first step 
> - see `help tabstat` 

> **D.3 - Visualize the relationship between access to improved sanitation and size of a country's rural population in 2010 via a a scatter plot.**
> - remember that the y variable goes before the x variable in our command for graphs
> - see `help scatter' or check out [Stata Graphs] (http://www.stata.com/support/faqs/graphics/gph/stata-graphs/) 

> **D.4 - How has population growth changed over the period of 2003-2012 across different country income level groups?**
> - it will be usefull to use the `collapse` command, aggregating up the sum by income level and year
> - The equation for population growth in 2016 would look like:
>     * ` popgrowth_16 = (pop_16 - pop_15)/pop_15`
> - in order to get the year before the current observation, you will want to make sure you first sort (`sort inc year`) and then use `pop[_n-1]`, where `_n` is the number of the current observation.
> - see `help _n`
> - since this is a time series, it would be good to use a `line` or `connected` plot if you are going to graph this.
> - it will be useful to break the graphs into [small multiples] (https://en.wikipedia.org/wiki/Small_multiple), using the `by` option
> - see `help line`, `help connected` or check out [Stata Graphs] (http://www.stata.com/support/faqs/graphics/gph/stata-graphs/) 

Great work! You've gone through a typical process, importing raw data, appending it, reshaping it, merging it, and cleaning it and then performed some analysis on the final dataset!

