/*
Homework: Day 2

World Bank Indicators Data
Fundamentals of

*/

/* Objective:
1. Clean World Bank Indicator Data
2. Reshape the data to a tidy format.
3. Relabel variables
4. Summarize / graph the indicators over time by country
5. Save the data
6. Merge with Foreign Assistance data.
7. Summarize merged data
*/

/* Plan of Attack.
1. Import Data
2. Identify problems to be fixed.
3. Fix problems:
- convert all year data to be numbers
- check and remove duplicate columns
- drop seriescode
4. Reshape the data (a few times?)
5. Relabel the variables
6. Summarize in a table
7. Graph it
8. Save data
9. Merge data w/ FAD
10. Summarize in table
11. Explore in a graph
*/

// 1: Import data --------------------------------------------------------------
webuse set "/Users/laurahughes/Github/StataTraining/Day2/Data"
// Define a global variable to specify the location of the Github repository.
global dataurl "/Users/laurahughes/Github/StataTraining/Day2/Data"

import delimited "$dataurl/wb_indicators.csv", clear


// 2: Identify problems --------------------------------------------------------
// Alright, how mean (/ realistic) was Tim?

describe
// --> yr2007, yr2008, yr2013, yr2014 are strings.

browse
// YUCK. I was wondering what the numbers represented... looks like they 
// represent multiple things.
// --> need to reshape / make sense of the order of the variables.

// --> stringed years have ".." as missing values. Seems like that'll create problems.

// --> Series code isn't that informative.  Consider dropping.



/* Summary of problems: 
1. Need to convert yr2007, yr2008, yr2013, yr2014 to numeric.
2. Might need to convert ".." to missing values BEFORE change to numbers. 
3. Change names of vars and drop the stringed numbers.
4. Drop series code-- similar info to series name, but not useful.
5. Reshape!! 
*/

// 3: Clean problems -----------------------------------------------------------

// a) Try to destring yr2007, yr2008, yr2013, yr2014
// This might not work since there are some ".." in the data. Let's see how smart Stata is.
destring yr2007, gen(yr2007_fixed)

// Yep, that fails.  If you didn't catch that there are ".." in the dataset, 
// you can check all the characters in yr2007:
ssc install charlist
charlist yr2007
// ... this isn't actually that informative, since the problem is that we have 
// two . characters repeated.  But it's a good check to make sure there weren't
// any other weird characters (like $ or ()) in the data.

// b) Replace ".." with missing values.
replace yr2007 = "." if yr2007 == ".."
replace yr2008 = "." if yr2008 == ".."
replace yr2013 = "." if yr2013 == ".."
replace yr2014 = "." if yr2014 == ".."

// Note: this is kind of brute force... see if there are other ways to replace for all vars.

// c) Now destring yr2007, 2008, 2013, 2014
destring yr2007, gen(yr2007_fixed)
destring yr2008, gen(yr2008_fixed)
destring yr2013, gen(yr2013_fixed)
destring yr2014, gen(yr2014_fixed)

list yr2007 yr2007_fixed yr2008 yr2008_fixed yr2013 yr2013_fixed yr2014 yr2014_fixed

// Looks good.
// d) Drop not useful vars and rename the vars created in the fix.
drop yr2007 yr2008 yr2013 yr2014 seriescode

rename(yr2007_fixed yr2008_fixed yr2013_fixed yr2014_fixed)(yr2007 yr2008 yr2013 yr2014)

// 4: Reshape! -----------------------------------------------------------------
// Here we go.  Reshape 1.

// Find a unique id
* isid countryname // Doesn't work
isid countryname seriesname

// reshape
reshape long yr@, i(countryname seriesname) j(year)

rename(yr)(percent)

clist in 1/20

// Looks not bad... maybe useful for what we want.  But it's probably more useful 
// to have each of the 3 series names as their own column.

// Figure out what the unique values for seriesname are
duplicates examples seriesname

// Reshape 2.
// Create a unique id for each observation
isid(countryname seriesname year)

// Stata is going to whine b/c the values in seriesname have spaces in them.
// (note: I'm not that clever; I didn't replace, realized the reshape gave me the
// wrong answer, so I went back, fixed, and reran.
replace seriesname = "ag" if seriesname == "Agriculture, value added (% of GDP)"
replace seriesname = "gdp" if seriesname == "GDP growth (annual %)"
replace seriesname = "tax" if seriesname == "Tax revenue (% of GDP)"

reshape wide percent, i(countryname year) j(seriesname) string

clist

// Okay... that looks like it'll be useful.  Time to clean up the names and labels

// 5: Rename -------------------------------------------------------------------
rename(percentag percentgdp percenttax)(ag gdp tax)
label variable ag "Agriculture, value added (% of GDP)"
label variable gdp "GDP growth (annual %)"
label variable tax "Tax revenue (% of GDP)"

// 6: summarize ----------------------------------------------------------------

// 7: graph --------------------------------------------------------------------

// 8: save data ----------------------------------------------------------------
save "wb_clean_LDH.dta" 

// 9: Merge in FAD data --------------------------------------------------------
/* I don't know what the FAD_merge data look like, so I'm going 
to reimport and look at its structure before I merge.*/

webuse "FA_merge.dta", clear

clist in 1/10

/* Okay... so looking at the data, we'll want to merge on the country_id for
FA_merge. And there are multiple entries per country-- DRG, Program Mangement,
econ, etc. for each country, meaning we'll want many copies of the World Bank data.

In sum: FA_merge is master file, the 1 in many:1, with merge id = country_id + year
wb_clean_LDH is using file, the many in many:1, with merge id = countryname + year
*/

// First, change name of the country_id so it's the same between the files
rename(country_id)(countryname)

* merge m:1 countryname using "wb_clean_LDH.dta", gen(_merge)

// d'oh! That doesn't work. 
// The error code is opaque, but seems to indicate some sort of type mismatch.
// What's the type of countryname (aka country_id) in FAD_merge?
describe countryname
label list 

// Aha! It's a number with attached 

decode countryname, gen(countrystr)

// check it's the same
list countryname countrystr in 1/30

// Retrofit variable names
rename(countryname countrystr)(country_id countryname) 
/* Note: I can't decide if this is good or bad.  It's probably too clever for its
own good, since I'm swapping variable names, which is code that's hard to follow
and potentially confusing.

In reality, I would go back and edit my code to delete me renaming country_id to countryname.
Then in the decode statement I could directly generate countryname from country_id.
(see below)
*/

// Trial #2!
* merge m:1 countryname using "wb_clean_LDH.dta", gen(_merge)
// Ahh, right. Countryname isn't unique, since it's countryname+year.  
// We'll have to create a new merged variable for both datasets.
use "wb_clean_LDH.dta", clear

// Append strings together. Have to convert year to a string (from a number)
gen id = countryname + string(year)

save "wb_clean_LDH.dta", replace

// Repeat for FA data...
webuse "FA_merge.dta", clear
decode country_id, gen(countryname)
gen id = countryname + string(year)

// ... and merge
merge m:1 id using "wb_clean_LDH.dta", gen(_merge)

// Filter out things that didn't match
keep if _merge == 3

// 10: explore data. -----------------------------------------------------------
