* Purpose: Solution to in-class collapse exercise
* Author: Tim Essam (GeoCenter)
* Date: 2016.01.13

* Set web url to point to Github repo for easy merging
webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
global dataurl "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"

* --------------------------------------------
* === Collapsing Solution === *
* Load data
webuse "StataTrainingClean.dta", clear

* Keep only observations from agency == USAID
keep if inlist(agency, "USAID") & fiscalyeartype == "Disbursements"

* Collapse data down, summing total price by fiscalyear and category
collapse (sum) spent, by(fiscalyear category)
la var spent "aggregate disbursements"

* Tabulate results
table category fiscalyear, c(mean spent) format(%9.2fc)

* Plot results
twoway(connected spent fiscalyear, sort), by(category) ///
scheme(s1color) subtitle(, size(vsmall))

* === Extra Credit === *
webuse "StataTrainingClean.dta", clear
collapse (sum) spent, by(fiscalyear fiscalyeartype qtr agency)

* Look at patterns
bysort fiscalyeartype: table fiscalyear qtr if inlist(agency, "USAID") & ///
inrange(fiscalyear, 2010, 2013), c(mean spent) format(%9.2fc)

la var spent "Total spending (M USD)"
* formatting graph
* Can you plot or summarize aggregate spending now?
local labopts "ylabel(, labsize(small) angle(horizontal)) xlabel(, labsize(vsmall)) ytitle(, size(vsmall)) xtitle(, size(vsmall))"
local layout "subtitle(, size(tiny) fcolor("245 245 245") bexpand)"
local lineopt1 "lcolor("171 221 165") mcolor("102 194 165") mlcolor("white") msize(medium) lpattern(solid) msymbol(circle)" 
local lineopt2 "lcolor("253 174 97") mcolor("244 109 67") mlcolor("white") msize(medium) lpattern(solid)"
local gopts "graphregion(fcolor(none) ifcolor(none)) ylabel(, nogrid)"

* Let's plot the patterns for USAID
twoway(connected spent qtr if fiscalyeartype == "Disbursements", sort `lineopt2') ///
(connected spent qtr if fiscalyeartype == "Obligations", sort `lineopt1') ///
if inlist(agency, "USAID") & inrange(fiscalyear, 2010, 2013), by(fiscalyear, note("")) ///
legend(order(1 "Obligations" 2 "Disbursements") nobox region(fcolor(none) lcolor(none)) ///
 size(tiny) span) subtitle(, size(vsmall)) ///
`labopts' `layout' scheme(s1mono) `gopts'

* -------------------------------------------------- *
