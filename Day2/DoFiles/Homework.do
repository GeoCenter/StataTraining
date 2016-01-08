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

global pathdata "C:\Users\Tim\Documents\Github\StataTraining\Day2\Data"
global pathlog "C:\Users\Tim\Documents\Github\StataTraining\Day2"
global path "C:\Users\Tim\Documents\Github\StataTraining\Day2\"

cd $path
capture log close
log using "$pathlog\Day2Homework.log", replace

/* --- Homweork Exercise --- *
Import the World Bank Indicator data and discuss how you would reshape it
Write psuedocode for each modification you'd make to the data.
*/
import delimited "$pathdata\wb_indicators.csv", clear

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

* reshape the data to wide format (swings seriesname variables wide)
reshape wide yr*, i(countryname) j(seriesname, string)

*replace the variable names w/ the variable labels
ds, not(type string)
local renlist = r(varlist)

foreach v of local renlist {
	local x : variable label `v'
	local y = strtoname("`x'")
	rename `v' `y' 
	}
*end loop

* Reshape one more time and things appear to be good
rename *_yr* **
reshape long ag_gdp@ gdp_growth@ tax_gdp@, i(countryname) j(year)

*label a few variables and we are ready for merging
label var ag_gdp "agricultural sector (value added) as % of gdp"
label var gdp_growth "gdp growth rate"
label var tax_gdp "taxes collected as % of gdp"

* Plot the resulting data (all in percentages)
scatter ag_gdp gdp_growth tax_gdp year, by(countryname) scheme(s1color)

table countryname year, c(mean gdp_growth) f(%9.2fc) row col
encode countryname, gen(country_id)

* Create a unique id for merging with subset FAD data
sort countryname year
gen loc_time_id = real( string(country_id) + string(year) )

saveold "wb_indicators_long.dta", replace  version(12)


cls
use "$pathdata/FA_merge.dta", clear

* Merge with WB data so we can look at indicators alongside foreign assistance data
merge m:1 loc_time_id using "wb_indicators_long.dta"

log close


