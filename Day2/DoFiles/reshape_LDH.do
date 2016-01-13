/*
Exercise: reshape World Bank Data 1 

Laura Hughes, lhughes@usaid.gov, 13 January 2016

Goals:
0. Load Data
1. Identify how the data are messy
2. Fix any errors you see
3. Make the data tidy using the reshape command
4. Once reshaped, convert the new variables into millions $USD and label the new variables. 
5. Using graphs or tables to explore temporal trends in the data
*/

// 0: Load data ----------------------------------------------------------------
webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
webuse "reshape_ex1.dta", clear

// 1: ID errors / messiness ----------------------------------------------------
// Since the dataset is small, honestly browse is a good (but unsustainable) way to look at the data
browse 

// Let's look at data type first.
describe

// --> MESSY alert! columns are all the same type of data (disbursements or obligations,
// but for different years.  

// --> disbursements2007 and obligations 2007 are strings. No es bueno for money.

// --> cat_id is kinda weird. it seems to be a number with labels associated with it.
// Let's check this is the case:
label list // --> Prints the labels for each of the values in cat_id (well, and everything else, but nothing else is labeled)

codebook // Look at everything
/* Interesting sidenote: the units are different for each of the spending data 
(1, 0.1, 0.01). This could be indicative of a problem; if your numbers are really
big (or small) and you have decimals, not all the data can be stored in that data
type, and you can lose info as the numbers get truncated.

You can see this if you force an double to be an integer:
clear
set obs 1
gen x = 3.4
recast int x, force
display x

In this case, the data type for all the values are doubles, which is the most
accurate representation of numbers.
So in this case, it just means some of the data have cents and others don't.
*/



/*
Okay, here's the summary of all the things I noticed that seemed wrong in the data:
- Data are messy!  Columns each are disbursements_yearX
- 2007 data are strings
- 2007 data are missing (".") for everything but health. Was health the only sector 
that got money in 2007?  I'm guessing not. After we reshape, let's filter out 
observations before 2009. 
- Disbursements and obligations are both in the data. Do we want both? 
*/



// 2: Fix errors ---------------------------------------------------------------
/* Honestly, I'd probably first drop 2007 data and then reshape (which avoids
changing case and dealing with "." values. But you don't always get that lucky,
and it's probably worth it not to prematurely delete / filter data. */

// change 2007 data to strings
gen d2007 = real(disbursements2007)
gen o2007 = real(obligations2007)

// Visually sanity check
clist disbursements2007 d2007 obligations2007 o2007
// Note: d2007 truncated the digits fo the string.

// Remove the bad data
drop disbursements2007 obligations2007
rename (d2007 o2007)(disbursements2007 obligations2007)

// Note: you could drop 2007 data in general, but I'm going to leave in and filter later.



// 3: Reshape data -------------------------------------------------------------
reshape long disbursements@ obligations@, i(category) j(year)

clist // Check it looks right

// OR: reshape long disbursements@ obligations@, i(cat_id) j(year)

/* Note: this is a bit messy still. To make it even cleaner, we can reshape again (but first we need to rename)
rename (disbursements obligations) (spentDisbursements spentObligations)

reshape long spent@, i(category year) j(paymentType) string

// Create a tag if the data are obligations or disbursements
gen byte isDisburse =  paymentType == "Disbursements"

We'll keep it simple here, though.
*/

// Create a tag if the data are before 2007
gen byte recentData  =  year > 2008



// 4: Convert data to millions, relabel ----------------------------------------
scalar deflator = 1e6 // Number in millions
replace disbursements = disbursements / deflator
replace obligations = obligations / deflator

label variable disbursements "disbursements (in millions USD)"
label variable obligations "obligations (in millions USD)"

/* Important note: this is really, really easy to do because the data are tidy.
With a couple lines of code, we can change all the dollars to millions and relabel it.
If we did this with the wide dataset,
1) It takes more time / lines of code
2) More importantly-- you're increasing your chances for errors. 
What if I accidentally forgot to change one column?  Then we would be comparing
$100M to $100 -- which has disasterous consequences.
*/

// 5: Explore temporal trends --------------------------------------------------

// I'm going to focus on disbursements, not obligations, since that seems more 
// relevant.  I'm also going to filter out the data before 2008.

// Overall, health is clearly the winner over all the years.
tabstat disbursements, by(category)


// Let's plot it.
twoway (connected disbursements year), by(category)

table year, c(mean disbursements) by(category) // Same data, harder to read.

clist year disbursements if cat_id == 3

// What happened to education in 2011????
// Is this an error?  Strange jump in investment?
