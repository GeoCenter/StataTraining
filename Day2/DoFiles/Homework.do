/*-------------------------------------------------------------------------------
# Name:		StataTrainingDay2
# Purpose:	Day two homework solution
# Author:	Tim Essam, Ph.D.
# Created:	2015/12/28
# Owner:	Tim Essam - USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	see below
#-------------------------------------------------------------------------------
*/

webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
global dataurl "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"

*capture log close
*log using "$pathlog\Day2Homework.log", replace

/* --- Homweork Exercise --- *
Import the World Bank Indicator data and discuss how you would reshape it
Write psuedocode for each modification you'd make to the data.
*/
import delimited "$dataurl/wb_indicators.csv", clear

* What are these variables?
* http://data.worldbank.org/indicator/NV.AGR.TOTL.ZS
* http://data.worldbank.org/indicator/NY.GDP.MKTP.KD.ZG
* http://data.worldbank.org/indicator/GC.TAX.TOTL.GD.ZS

*br
describe
* How many instances of missing data do we have to fix?
count if inlist("..", yr2007, yr2008, yr2013, yr2014)==1

* Loop over each variable with missing and create a new variable
* Want to replace missing with blanks for coercion to strings
foreach x of varlist yr2007 yr2008 yr2013 yr2014 {
	replace `x' = "" if inlist("..", `x')
	
	* Check that you are destrining the right things
	destring `x', gen(`x'_ds) 
}
*end

* Drop string variables, rename years for reshaping below
drop yr2007 yr2008 yr2013 yr2014
rename *_ds* **

* (Could also use destring, force options + mvencode)

* relabel the series names to valid names
drop seriescode
replace seriesname = "gdp_growth" if seriesname == "GDP growth (annual %)"
replace seriesname = "ag_gdp" if seriesname == "Agriculture, value added (% of GDP)"
replace seriesname = "tax_gdp" if seriesname == "Tax revenue (% of GDP)"

* Reshape the data to wide format (swings seriesname variables wide)
* We want to get seriesname * year as our column names so we want to 
* flatten out year variables interacted with each series name
reshape wide yr*, i(countryname) j(seriesname, string)

* Replace the variable names w/ the variable labels
* Need to do some renaming b/c reshape is picky about how it reads years

* ds will return us an r-class value that we can use in a local macro to loop
* over each yr variable name. 
ds, not(type string)
local renlist = r(varlist)

* Inside the loop below, we are taking the value of the variable
* label for each yr variable, storing it in a new local variable (x)
* and then converting that value into a valid variable name, that is stored in y.
* We then rename each occurence of `v' by the value held in `y'. If we turn the trace on
* this is all much easier to see (you can also brute force this with repetitive coding).

set tr on 
foreach v of local renlist {
	display in yellow "We are on `v' variable now"
	local x : variable label `v'
	
	display in yellow "ensure that the variable label for `x' is a valid name and store it in y"
	local y = strtoname("`x'")
	
	display in white "Now we'll rename `v' to be `y'"
	rename `v' `y' 
	display in white "Our variable should now be named `y'"
	}
*end loop
set tr off

* Reshape one more time and things appear to be good
* This time, we want ag_gdp, gdp_growth and tax_gdp --> year (stacked)
rename *_yr* **
reshape long ag_gdp@ gdp_growth@ tax_gdp@, i(countryname) j(year)

*label a few variables and we are ready for merging
label var ag_gdp "agricultural sector (value added) as % of gdp"
label var gdp_growth "gdp growth rate"
label var tax_gdp "taxes collected as % of gdp"

* Plot the resulting data (all in percentages)
twoway(connected ag_gdp gdp_growth tax_gdp year, sort), by(countryname) scheme(s1color)

table countryname year, c(mean gdp_growth) f(%9.2fc) row col
encode countryname, gen(country_id)

* Create a unique id for merging with subset FAD data (need to look at this data first!
* Open a concurrent session and look at the id variable. What pattern do you see?
sort countryname year
gen loc_time_id = real( string(country_id) + string(year) )
isid loc_time_id

saveold "C:\Users\t\Documents\GitHub\StataTraining\Day2\Data\wb_indicators_long.dta", replace


/* Extra credit: reshape the data 1 more time to get a "real" tidy dataset.
* In this case, we want to combine the gdps into a single variable that is 
* identified by a gdp type variable. First, rename our gdp variables
ren(ag_gdp gdp_growth tax_gdp) (gdpag gdpgrowth gdptax)

* Think about syntax: new variable to be created (j) is gdpType
* variables we are squashing into there are gdp_ag, gdp_growth, and gdp_tax)
reshape long gdp@, i(loc_time_id) j(gdpType, string)
la var gdp "gdp values"
la var gdpType "type of gdp, growth is overall growth"

* ### NOTE!: This complicates the merge somewhat, you'll likely have to execute a many-to-many
* merge b/c neither dataset will have a unique id!
*/

* Load in the foreign assistance data and look at it's structure? What do you notice?
* Is there a unique id? No, so it will be a many to 1 merge at this point
cls
use "$dataurl/FA_merge.dta", clear
clist


* Merge with WB data so we can look at indicators alongside foreign assistance data
merge m:1 loc_time_id using "$dataurl/wb_indicators_long.dta"


* Pretty much finished, but you could go crazy and reshape one more time to stack all the gdp variables!
ren(ag_gdp gdp_growth tax_gdp) (gdpag gdpgrowth gdptax)

* Our unique variable combination (i) is loc_time_i + category
* Our variable we want to create (j) is gdpType, this is to be filled with a string
reshape long gdp@, i(loc_time_id category) j(gdpType, string)
la var gdp "Gdp values"
* Probably enough reshaping for today! How does gdp look compared to spending?

