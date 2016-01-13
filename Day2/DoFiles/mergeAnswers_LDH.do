/*
Part 2, Exercise 2: merging
Fundamentals of Data Analysis and Visualization (using Stata)

Laura Hughes, 13 January 2016, lhughes@usaid.gov

Objective: merge ind2.dta with hh3.dta and keep observations in both datasets.
*/

/* Plan of attack:
1. Import data
2. Figure out what the unique id to merge on is.
3. Figure out whether I need to do a 1:1 merge or a many:1 merge.
4. Merge!
5. Check the merge worked and fix any errors.
6. Filter out the rows in both datasets.
*/

// 1: Import data --------------------------------------------------------------
webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
webuse "hh3.dta", clear
save "hh3.dta", replace

webuse "ind2.dta", clear

// 2: what's the unique id? ----------------------------------------------------
// From looking at the file, seems highly likely that id or hid is good.  
// But which one is it? Let's check each

* isid hid // Not run-- will --> error.

* isid id // Not run-- will --> error.

// d'oh!  neither of those work!  
// (... 2 minutes pass...)
browse
// What if I _combine_ the two of them together?
isid hid id

// SUCCESS!

/* Note: isid seems like magic.  But what it's really doing under the hood is 
checking whether the the variable contains only unique values.

Another way of thinking about it is that it's finding if there are any duplicates
in the variable (or combination of variables).  We can also look at the duplicate values.
*/

duplicates list hid
duplicates list hid id

// Let's check for hh3.dta
use "hh3.dta", clear

describe

// hh3.dta is much simpler than ind2.dta
// Since it only contains hid, that seems likely to be what we want to merge on.
// We still need to check that it's a unique identifier.

* isid hid // Not run-- will --> error.

// Uh oh.  isid doesn't work-- hid isn't unique! Let's look at the little dataset
list

// We'll get back to fixing this, but first let's decide 1:1 or m:1

// 3: 1:1 or m:1? --------------------------------------------------------------
// Comparing the two sets of hid's, they're not the same and there are multiple 
// unique copies of hid's in ind2. 
// So it's pretty clear we are in a m:1 situation.
// ind2.dta has hid = 101, 102, 103
// hh3.dta has hid = 101, 102, 104

// 4: Trying a merge (and failing) ---------------------------------------------
webuse"ind2.dta", clear // reset ind2.dta to be the "master" file
* merge m:1 hid using "hh3.dta", gen(_merge)  // Not run; will --> error

// As expected, the merge fails since there aren't unique ids.
// From looking at the file, hh3.dta has duplicate entries that seem to be errors.
// So let's fix it.

// (DETOUR): cleaning up hh3.dta -----------------------------------------------
use "hh3.dta", clear
list

// hid 101 has the same income value -- so clearly a duplicate. 
// We can remove it now... or wait till we create a new duplicate
duplicates drop

// hid104 has an income of $500 and missing. We'll make the assumption that the 
// missing data is incorrect.

// Replace missing income for hid 104
replace income = "$500" if hid == 104
// Note: can you figure out a clever way not to hardcode this?

// Check this works
list


// Remove duplicates (again)
duplicates drop

isid hid // Check is unique now

// yippio!
save "hh3_edited.dta", replace // save for later use

// 4: Merge (for real) ---------------------------------------------------------
webuse"ind2.dta", clear // reset ind2.dta to be the "master" file
 merge m:1 hid using "hh3_edited.dta", gen(_merge)  // Not run; will --> error

// 5: Check merge worked -------------------------------------------------------
list

// 6: Filter only the common rows ----------------------------------------------
// use the _merge variable we created to keep only those that matched (code 3)
drop if _merge != 3

// or: keep if _merge == 3

// check
list
