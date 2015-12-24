

global pathin "C:\Users\t\Documents\GitHub\StataTraining\Exercises\Stata"
cd $pathin

* --- 10 min Exercise --- * 
* 1)load the StataTrainingMessy.csv
* 2) browse the data and describe the data, any variables with missing values?
* 3) identify potential data problems and propose solutions
* 4) What is the difference between spent & spent2 & amount?

* ### Solutions ### *

* 1) import
import delimited "StataTrainingMessy.csv", clear

* 2) browse data (may options)
br
codebook
describe
inspect
mdesc

* 3) data problems
sum

* ### Fiscal year seems messed up. Look at it in detail
tab fiscalyear, mi

* ### Need to fix some unlikely values (20014)
recode fiscalyear (213 = 2013) (20014 = 2014)
tab fiscalyear, mi

* ### Quarter also look a bit funny
tab qtr, mi
recode qtr (40 = 4) (0 = .)
tab qtr, mi

* ### Fiscal year type is not consistent
tab fiscalyeartype, mi
replace fiscalyeartype = "Disbursements" if fiscalyeartype == "Disbsmnt."
replace fiscalyeartype = "Obligations" if fiscalyeartype == "Obgl."
tab fiscalyeartype, mi

* ### Seems ok except for the many N/A
tab account, mi sort
replace account = "Unknown" if account == "N/A"
tab account, mi sort

* ### what are the problems with the Agency names?
tab agency, mi

* ### lots of problems: 1) USAID, 2) Stata! 3) MCC has spaces 4) Peace Corps all caps

* ### First, USAID is not consistent. Use the regexm function to fix all occurences
replace agency = "USAID" if regexm(agency, "(U.S.A.I.D|usaid|USAID )") == 1

* Fix the errors created by leading spaces
replace agency = trim(agency)
tab agency, mi 

replace agency = "DOS" if agency == "Department of Stata"
replace agency = "DOD" if agency == "DoD"
replace agency = proper(agency) if agency == "PEACE CORPS"
tab agency, mi

* Everything looks good, let's move on to operating units

* Operating Unit (ignoring mostly for now)
tab operatingunit, mi 
tab benefitingcountry, mi
replace benefitingcountry = "N/A" if benefitingcountry =="I.wonder.if.Laura.will.find.this"

* For later, let's tag all Benefiting countries that have region in their name
g byte notCountry = regexm(benefitingcountry, "(USAID|Region|Worldwide|Office|Treasury)") == 1
tab benefitingcountry if notCountry

* Category
tab category, mi
replace category = proper(category)
replace category = "Democracy, Human Rights, And Governance" if category == "Drg"
replace category = "Economic Development" if category == "Econ. Dev."
replace category = "Missing" if category == ""
tab category, mi

* Sector
tab sector, mi sort

* Describe the amounts
describe amount spent spent2
codebook amount spent spent2

* 4) spent versus spent2
describe amount spent spent2
compare spent spent2
assert spent == spent2 

compare spent2 amount
*assert string(spent2) == amount
charlist amount

replace spent = spent / 1000000
save "StataTrainingClean.dta", replace



/* Collapsing, reshaping, merging and appending data
* These are some of the most powerful munging operations out there
* they allow you to make different data sets talk to each other and 
* inform a research question.

* Examples: 1) Collapse: collapsing individual level down from a hh survey to hh-level
2) Collapse: Rolling up indicators to a geographic, sectoral, or programmatic level
3) Transforming data from wide to long enables you to take advantage of Stata's
 built-in panel settings
4) Merging data: joining geographic information with hh information based on common field
5) Appending: updating an existing dataset

* --- Collapse ---*
* Explore the collapse function to demonstrate how we can use it w/ the FA data
*/

* Collapse data down to fiscal year, aggregating total foreign assistance across sample
* (rescale spent to be in millions)


preserve
collapse (sum) spent, by(fiscalyear)
scatter spent fiscalyear
plot spent fiscalyear
restore

* Collapse data down to fiscal year and category type
preserve
collapse (sum) spent (count) spentCount = spent, by(fiscalyear category)
table category fiscalyear , c(mean spent) f(%12.2fc)
scatter spent fiscalyear, by(category, total) scheme(s1color)
restore

/* --- 5 min Exercise --- *
1) Collapse the data down by fiscalyear and agency while aggegrating total foreign assistance 
2) Extra credit - also collapse down the standard deviation for spent
3) plot the resulting data by agency
4) plot the data only for USAID
*/

preserve
collapse (mean) spent (sd) spendSd = spent, by(fiscalyear agency)

* Fixing a label for the plot
label variable spent "total spending (M USD)"

* Check the resulting collapse
table agency fiscalyear, c(mean spent) f(%12.2fc)

* plot all data
scatter spent fiscalyear, by(agency, total) scheme(s1color)

* plot only for USAID
scatter spent fiscalyear if agency == "USAID", scheme(s1color)

restore

/* --- Reshaping --- *
Used to cast data from long to wide or wide to long formats. 
Why is this useful? summarizing data; tabulating data; plotting
Need a combination of variables to provide a unique id!
isid fiscalyear qtr
*/

* Load the wide format of the data just for USAID and think about how you'd analyze it

* to create id
use "StataTrainingClean.dta", clear

* Create a fake econ variable from a uniform distribution
collapse (sum) spent if agency == "USAID", by(fiscalyear category agency)
set seed 12232015
g double ror = 5 * runiform() + (-5)
g double fpIndex = 10 * runiform() + 0
la var ror "rate of return"
la var fpIndex "dev priority"

reshape wide spent ror fpIndex, i(category) j(fiscalyear)
order category agency spent* ror* fp*
save "reshapeWide.dta", replace

* load the reshape data and discuss the format
/* How would you analyze this data format? Can you easily make temporal comparisons?
1) What problems do you see?
2) Is this a useful format? Maybe?

* --- Discuss ---
* How could you reshape the data to make it more useful? 
* Does total funding appear to be correlated with the ror?
* Does total funding appear to be correlated with the fpIndex?*/
use "reshapeWide.dta", clear

reshape long spent ror fpIndex, i(category) j(year)
bys category: pwcorr spent ror
scatter spent ror, by(category)

* What if we don't like the resulting format? Go back
reshape wide spent ror fpIndex, i(category) j(year)
order category agency spent* ror* fp*


/* --- Appending ---*
Stacking two datasets with common variables. Could be used to update a dataset. */
use "disbursements.dta", clear
br
use "obligations.dta", clear
count

* Append two datasets together
append using "disbursements.dta", gen(data_source)
tab data_source, mi

*label data source values
label define fisc_type 0 "obligations" 1 "disbursements"
label values data_source fisc_type 
count
clear


/* --- Homweork Exercise --- *
Import the World Bank Indicator data and discuss how you would reshape it
Write psuedocode for each modification you'd make to the data.
*/
import delimited "wb_indicators.csv", clear

* What are these variables?
* http://data.worldbank.org/indicator/NV.AGR.TOTL.ZS
* http://data.worldbank.org/indicator/NY.GDP.MKTP.KD.ZG
* http://data.worldbank.org/indicator/GC.TAX.TOTL.GD.ZS

br
* How many instances of missing data do we have to fix?
count if inlist("..", yr2007, yr2008, yr2013, yr2014)==1

* Loop over each variable with missing and create a new variable
foreach x of varlist yr2007 yr2008 yr2013 yr2014 {
	replace `x' = "" if inlist("..", `x')
	destring `x', replace 
}
*end

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


save "wb_indicators_long.dta", replace

* Merging data: combining two datasets based (usually based on a unique ID)


bob











/* How can I quickly summarize data?
1) summary
2) tabulate (user-written tabsort); tab, sum(varname)
3) tabstat
4) table */ 

* Summarise - summary stats for all variables
sum
sum spent, detail 

* tabulate - create one or two-way cross tabs
tab fiscalyear agency, mi
tabsort fiscalyear agency

* tabulate fiscal year account and summarize spending
tab fiscalyear, sum(spent)
tab category, sum(spent)

* tabstat - create tabulations with selected statistics
tabstat fiscalyear category, stat(mean median sd n)






















* Exploring and plotting data

summarize spent, detail
histogram spent 

* Define two scalars that will represent the lower and upper bound filters
scalar lowerb = -466299.9
scalar upperb = 1000000

histogram spent if inrange(spent, lowerb, upperb)

* Notice the outliers
scatter spent fiscalyear
scatter spent fiscalyear if inrange(fiscalyear, 2010, 2014), jitter(10)
scatter spent fiscalyear if inrange(spent, lowerb, upperb) & fiscalyear > 2009, jitter(10)

* Let's look at the scatter plot by quarter, by fiscal year
scatter spent qtr if inrange(spent, lowerb, upperb), by(fiscalyear) jitter(10) 

* Let's plot the data overtime using a combination of qtr + fiscal year to create a time var
sort fiscalyear qtr
egen timevar = group(fiscalyear qtr)



