/* Pseudocode exercise to clean up a subset of the Foreign Assistance Database.

Laura Hughes, lhughes@usaid.gov, 11 January 2016
Fundamentals of Data Analysis and Visualization (using Stata)
*/

/* Background: we're given a new database, and we're given the task of cleaning 
it up before we do some analysis. We're using the FAD (Foreign Assistance Database),
and in the end we want to see the spending per sector.

1. Import the data
2. Explore the data to identify outliers and problems (data inconsistencies, type problems, etc.)
3. Clean up any problems
4. Summarize the spending per sector.

*/

/* First, we need to import the data and identify any issues; then we'll make a 
list of problems and how we'd correct them and verify that it worked.
*/

// (1) Set working directory to the location of the file 
cd "/Users/laurahughes/Github/StataTraining/Day2/Data"

// Import data
import delimited "StataTrainingMessy.csv", clear

// (2) Look at the data and see if there's anything amok.
// As with most things in analysis, there's multiple ways to see the same thing.

// First, let's look at the variables:
describe

// --> Problem #1: Amount is a string, so we would want to use spent.



// Fiscal Year
browse fiscalyear

// Okay, that's useful, but 2,000+ entries is too many for us to look through by
// hand. You can start to see, though, that some fiscal years don't look like years.

codebook fiscalyear
sum fiscalyear
inspect fiscalyear
tab fiscalyear, mi
// --> Problem #2: range of years is 213 - 20014


// Quarter
codebook qtr
sum qtr
inspect qtr
tab qtr
// ! note! make sure you include missing values when you tabulate.
tab qtr, mi
// You could also plot the qtr variable to see that something is wrong with it:
hist qtr, width(1)
// --> Problem #3: qtr contains 6 unique values and includes 0 and 40.
// --> Problem #4: qtr contains some missing values.

 
 
 // Fiscal Year Type
 codebook fiscalyeartype
 sum fiscalyeartype // Not useful, since the data are strings
 inspect fiscalyeartype // Not useful, since the data are strings
 tab fiscalyeartype, mi
 // --> Problem #5: fiscalyeartype contains redundant values
 
// Account
tab account, mi
// --> Problem #6: some accounts are N/A

// Agency
tab agency, mi
// --> Problem #7: USAID = U.S.A.I.D. = usaid
// --> Problem #8: Department of Stata (hah!)
// --> Problem #9: PEACE CORPS should be Peace Corps
// --> Problem #10: DoD should be Department of Defense
// --> Problem #11: Treasury should be Department of Treasury
// --> Problem #12: The first USAID has extra spaces around it!  Tricksy, I know.
// Unfortuantely, this sort of thing is common.  Don't believe me?  Count the number of characters.
codebook agency
gen lengthAgency = length(agency)

// You'll get this lovely warning: "variable has leading, embedded, and trailing blanks"

// Operating Unit
tab operatingunit, mi
// --> Problem #13: Washington OUs, "Worldwide", etc. are listed together.

// Benefitting Country
tab benefitingcountry, mi
// --> Problem #14: regions, worldwide, and countries are all possible beneficiaries.

// Category
tab category, mi
// --> Problem #15: ENVIRONMENT is all caps
// --> Problem #16: Econ. Dev. is probably the same as Economic Development
// --> Problem #17: DRG could be spelled out
// --> Problem #18: multi-sector is a nebulous category; luckily, it seems to be missing from USAID:
tab category if agency == "usaid" | agency == " USAID " | agency == "U.S.A.I.D", mi
// --> Problem #19: some have a category of " "; luckily, none from USAID


// Sector
tab sector, mi
// No glaring problems!  It's a miracle.  There are many categoies that could possibly be condensed...

// Amount
codebook amount

ssc install charlist
charlist(amount)

// --> Problem #1: amounts are strings
// --> Problem #20: amounts have $ 
// --> Problem #21: amounts have extra spaces in them:  "warning:  variable has leading and trailing blanks"
// --> Problem #22: negative amounts are specified by parentheses

// Spent
codebook spent
sum spent

// --> Problem #23: 10 missing values.
hist spent

// That's not too useful... let's log-transform:
// (note: I'm taking the abs value first, since you can't take the log of a negative number)
gen logSpent = log(abs(spent))

hist logSpent

// --> Maybe problem #23: there are some big (and small) numbers there!  are they real?

 
 
/* problems:

-- Missing Data --
- 

-- Inaccurate Data --
- qtr contains some zero
*/
