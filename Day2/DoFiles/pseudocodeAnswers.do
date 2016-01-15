/* Exercise:

Plot and save the proportion of the spending (disbursements, in millions of USD) 
of each category per fiscal year for USAID

Bonus: Find which sector had the most spending in the timeframe  
Hint: be careful which dates you include! 

Laura Hughes, lhughes@usaid.gov, 12 January 2016

*/


/* Plan of attack:
1. Import the data
2. Convert money from a string to a number.
3. Change amount spent to be millions.
4. Rename gorycate to category
5. Filter out only Disbursements and only USAID.
6. Calculate total spent per year
7. Calculate the share of spending per year
8. Check that the share is 100%
9. Plot the spending per year, by sector
10. Save it to an .xls sheet for further use.
*/

// 1 ---------------------------------------------------------------------------
// Set working directory and import data

webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
webuse "pseudocoding_data.dta", clear

// 2 ---------------------------------------------------------------------------
// Check if the spent data are the correct format.
// If they're not numbers, correct them.

// describe
// confirm numeric variable spent
/* Note: this will throw an error which breaks your .do file.  Which is good, 
since it alerts you to a problem. But bad if your subsequent code fixes the error! */

// Okay, that was fancy, but you would have seen if you checked the type:
describe spent
codebook spent

// Convert the strings to numbers
gen spentAmt = real(spent)

// Can also use the destring command: destring spent, replace 
// Double check that you have no missing values
codebook spentAmt 

/* Note: you could, in theory, use the function 'replace' or 'destring' to write over the 
variable spent. However-- you can't replace a variable with one of a different
type (going from a string to a float). More importantly, that means you couldn't
visually check that the conversion looked right.*/


// 3 ---------------------------------------------------------------------------
// Change spentAmt to be millions of USD.  In this case, we'll create a scalar that 
// we can use to define the amount by which we are deflating the value.
scalar deflator = 1000000
replace spentAmt = spentAmt / deflator

// Can also use "scalar deflator2 = 1e6" - scientific notation is sometimes easier. 1e6 = 1*10^6 = 1,000,000

// 4 ---------------------------------------------------------------------------
// Change the variable names to something more meaningful
rename (gorycate fiscalyeartype) (category paymentType)

// ... and relabel the value name for category since someone had some trouble typing.
label variable category "category"


// 5 ---------------------------------------------------------------------------
// Filter out dispersements

keep if paymentType == "Disbursements"


// Filter out non-USAID agencies

keep if agency == "USAID"


/*
Note: you don't have to do this stepwise.  You could also combine:

keep if paymentType == "Disbursements" & agency == "USAID"

Note 2: another way would be to create a variable that tracks whether we should
include it in our analysis.

Then, we'll use it as a filter in the following steps when we create new variables.
Rows where our boolean variable (isUSAIDdisburse) is false will generate a 
missing value. So the rest of the data is there, but the derived variable that 
we care about isn't generated for the cases we want to ignore.

The advantage of this approach is that you keep ALL the data and don't throw 
anything away till the end.

In the rest of the code, I'll refer to this as PATH 2 to show the alternate pathway.
So you can choose your own adventure!

Okay, the code for this step in PATH 2:
gen byte isUSAIDdisburse = (paymentType == "Disbursements") & (agency == "USAID")

*/


// 6 ---------------------------------------------------------------------------
// Calculate the total spent per year
egen totSpent = sum(spentAmt), by(fiscalyear)
label var totSpent "total spending by fiscal year"

/* PATH 2
egen totSpent = sum(spentAmt) if isUSAIDdisburse == 1, by(fiscalyear)
*/

// Visually check that this looks right. We'll have to sort the data before it makes sense:
sort fiscalyear category
clist
// browse


// 7 ---------------------------------------------------------------------------
// Calculate the proportion for each category
gen shareByCat = spentAmt / totSpent
label var shareByCat "spending share by category"

/* Note: here PATH 1 and PATH 2 converge; since totSpent has missing values
for the rows we want to ignore, it'll generate another missing value for the 
irrelevant data.
*/


// 8 ---------------------------------------------------------------------------
// Check that each group sums to 100%
// We can check visually...
table category fiscalyear, c(sum shareByCat) row
// The sum of each column (each year) should be 1


/* ... or we can ask the computer to check. This has the obvious advantage
that it is less likely to miss an error, and it's simple to check a ton of data 
all at the same time.
*/

// First, we'll generate the total for each share by year.
egen yearTot = total(shareByCat), by(fiscalyear)

/* Then we'll check if the total per year is 1.
If one of the values doesn't check out, the .do file will stop and give us
an ugly red error. */
assert yearTot == 1

// assert yearTot == 1.1  // This would break the code, since every value is 1.


// 9 ---------------------------------------------------------------------------
// Generate a small multiples plot of each category
twoway(scatter shareByCat fiscalyear, sort), by(category)
twoway(connected shareByCat fiscalyear, sort), by(category)

twoway (bar shareByCat fiscalyear), by(category)


// Note: you can plot everything on top of each other, but it quickly becomes hard to see.
// Ecode the category variable to be a numeric
// Declare data to be a panel and use a panel line plot (spaghetti graph)
encode category, gen(cat_enc)
label var cat_enc "category variable encoded"
xtset cat_enc fiscalyear
xtline shareByCat if fiscalyear >2007, overlay legend(size(small)) scheme(s1color)


// 10 --------------------------------------------------------------------------
// Save results
save "shareByCat.dta", replace
export excel "shareByCat.xls", firstrow(variables) replace

// 11 Extra credit -------------------------------------------------------------
// Which sector had the most spending in the timeframe?

// Ignore the 2007 data, since it seems incomplete
drop if fiscalyear < 2009

// Health is the clear winner.
tabstat spentAmt, by(category) stat(sum)
