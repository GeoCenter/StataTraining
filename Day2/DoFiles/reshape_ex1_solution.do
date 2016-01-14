* Purpose: Solution to in-class reshape exercise
* Author: Tim Essam (GeoCenter)`
* Date: 2016.01.13

* Reshape 1 solution
webuse reshape_ex1.dta, clear

* Look at the data 
br
describe

* Fix the variables that are strings (or we could drop given it's a single data point!)
destring disbursements2007, replace
destring obligations2007, replace

* check if cat_id is unique for our reshape
isid cat_id

* Looks good, let's move on to the reshape. We want to reshape everything long (melt)
reshape long disbursements@ obligations@, i(cat_id) j(year)

* Check out the results, does the output make sense?
* Browse the data frame to see.
clist

* Apply some basic formatting
scalar deflator = 1000000
replace disbursements = disbursements / deflator
replace obligations = obligations / deflator

* Label the new variables
la var disbursements "total disbursements"
la var obligations "total obligations"

* Let's tabulate the data
table category year, c(mean disbursements mean obligations) row col

* Finally, plot the two datasets. Use a few local macros to clean up graph a bit (advanced).
local labopts "ylabel(, labsize(small) angle(horizontal)) xlabel(, labsize(vsmall)) ytitle(, size(vsmall)) xtitle(, size(vsmall))"
local layout "by(category, rows(2)) subtitle(, size(tiny) fcolor("245 245 245") bexpand)"
local lineopt1 "lcolor("171 221 165") mcolor("102 194 165") mlcolor("white") msize(medium) lpattern(solid) msymbol(circle)" 
local lineopt2 "lcolor("253 174 97") mcolor("244 109 67") mlcolor("white") msize(medium) lpattern(solid)"
local gopts "graphregion(fcolor(none) ifcolor(none))"

twoway(connected disbursements year, sort `lineopt1')(connected obligations year, sort `lineopt2'),/*
*/ by(category, note("")) yscale(noline) `labopts' `layout' scheme(s1mono) `gopts' /*
*/ legend(order(1 "Disbursements" 2 "Obligations") nobox region(fcolor(none) lcolor(none)) ///
 size(tiny) span)

* Are the data really tidy? Could we combine obligated and disbursed into a spending category?
* We could reshape 1 more time to make them fully tidy
rename (disbursements obligations ) (spentDisb spentOblig)
reshape long spent@, i(category year) j(spendingType, string)
la var spendingType "Type of spending - obligated or disbursed"
sort category spendingType year
clist
