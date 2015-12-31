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
describe
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
