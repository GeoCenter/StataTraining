/* Exercise: Analyze aggregate spending (disbursements) by fiscal year across 
categories for only USAID in the Foreign Assistance Data.

Calculate the proportion of the spending (disbursements, in millions of USD) 
of each category per fiscal year for only USAID

Laura Hughes, lhughes@usaid.gov, 12 January 2016

*/


/* Plan of attack:
1. Import the data
2. Check the type of data
3. check for missing data (will skew mean)
4 group by agency (or category whatever) by year, calc mean etc
5 plot
6 export. 
*/

// Set working directory and import data

webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
webuse "StataTrainingClean.dta", clear


// Filter out dispersements

keep if fiscalyeartype == "Disbursements"


// Filter out non-USAID agencies

keep if agency == "USAID"


/*
Note: you don't have to do this stepwise.  You could also combine:

keep if fiscalyeartype == "Disbursements" & agency == "USAID"
*/

// Translate dollars into 

// Rename column

// Calculate the total spent per year
egen totSpent = sum(spent), by(fiscalyear)

// Aggregate amount spent per category and fiscal year. 
egen totCat = sum(spent), by(category fiscalyear)

// Calculate the proportion for each category
gen shareByCat = totCat / totSpent

// Convert to a pretty percent string
gen pctByCat = shareByCat*100
replace pctByCat = round(pctByCat, 0.1)
gen pctStr = strofreal(pctByCat)+"%" 
// Note: here you have to generate a new variable, since pctByCat is a number and pctStr is a string.

// or gen pctStr = strofreal(round(shareByCat*100, 0.1)) + "%"


// Generate a small multiples plot of each category
scatter shareByCat fiscalyear, by(category)

// Save results
save "shareByCat.dta", replace
export excel "shareByCat.xls", firstrow(variables) replace
