/*
Part 2, Exercise 4: collapsing
Fundamentals of Data Analysis and Visualization (using Stata)

Laura Hughes, 13 January 2016, lhughes@usaid.gov

Objective 1: Collapse data for USAID disbursements by fiscal year by category and 
observe trends.

Objective 2: Collapse data by fiscal quarter/year, fiscal year type, agency.

*/

/* Plan of attack: (Objective 1)
1. Load the data
2. Filter USAID and disbursed
3. Collapse to sum of spending by fiscal year / category
4. Figure out what it means.
*/

// 1: Load in the data ---------------------------------------------------------
webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
webuse "StataTrainingClean.dta", clear


// 2: Fiter out USAID data, disbursements --------------------------------------
keep if agency == "USAID" & fiscalyeartype == "Disbursements"

browse

// 3: Collapse down to sum of spent --------------------------------------------
// Hmm... there's spent, and spent2.  Which one do we want?

describe spent spent2

// They're both floats. The variable label doesn't tell us anything informative.
// Sidenote: labels are great, but double check that they're correct.  

compare spent spent2

// Definitely not the same. And VERY different. Let's plot it.
twoway (scatter spent spent2)

// AHA! Pay close attention to the axes. spent2 is proportional to spent but 
// a million times larger. Double checking... look at the difference in ranges. 

codebook spent spent2

// We'll use spent (since the numbers are big)


collapse (sum) spent, by(fiscalyear category)

list

// 4. What does it mean? -------------------------------------------------------
table category fiscalyear, c(mean spent)
// table category fiscalyear, c(sum spent) // This works too, since there's only one observation per year/category combo.

// Poor environment.  Health, do you want to give a few dollars to the trees?
twoway (scatter spent fiscalyear), by(category)



// Wait... didn't we do something really similar in the pseudocoding exercise?
// 10 points to Gryffindor!
// Yeah, it's basically same.  But different!  How is it different?

/* Differences between pseudocoding exercise and the collapsing one:

1. In the pseudocoding exercise, we were dealing with the proportion / share
of disbursement money per category per fiscal year. Here we are looking at the
aggregate (sum).  But the trends will be the same, since they're proportional to 
each other.

2. In the pseudocoding exercise, we used egen to create the summary.  Here we 
used collapse.  That's actually a big difference:

3. Collapse gets rid of your data! It'll collapse it down to a simple chart, but
then it overrides all your data with that chart.  So make sure you want to do it
before you commit, and save a copy of your data.  

4. On the other hand, egen creates a NEW variable that's added to the dataset.
That means that if you have multiple observations for each year + category combo,
you'll get duplicates of whatever summary value you're creating (share in 
pseudocoding exercise, aggregate here).

5. ... highlighting those differences, the data in the two exercises is different
(though they're derived from the same raw data). 

In the pseudocoding exercise, we sort of tricked you we had already collapsed 
all the individual transactions down to a single value per year, per category. 
This was done so we'd avoid the messiness of having duplicate values for each
year/category combo.

In this exercise, we had the transaction-level data which contains multiple 
values for every year and category combination, and collapse will mush them 
all together appropriately.

Both egen and collapse are useful but VERY different-- make sure you know which
one you're using and why.
*/


// Onto the extra credit... 
/* Plan of attack: (Objective 2)
1. Reoad the data
2. Collapse to sum of spending by fiscal year / category / fiscal year type / agency
3. Tabulate by quarter and plot.
*/


// 1: Load in the data ---------------------------------------------------------
webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
webuse "StataTrainingClean.dta", clear

// 2: Collapse -----------------------------------------------------------------
collapse (sum) spent, by(fiscalyear fiscalyeartype qtr agency)



// 3: What's it mean?

// Mush things together by quarter -- ignoring agency, year, type.
tabstat spent if agency == "USAID", by(qtr) stat(sum)

// Lots of action in Q4!  And not much in Q2.  
// How does it differ between disbursements and obligations?
bysort fiscalyeartype: tabstat spent if agency == "USAID", by(qtr) stat(sum)

// Yowza, that's a lot of obligations in Q4. How much do you want to bet a large
// chunk of that was Sept. 23 - 30?

// And a plot of that...

twoway(scatter spent qtr if (agency == "USAID") & inrange(fiscalyear, 2010, 2013)), by(fiscalyear)

// So maybe things got better in 2013?

// Note: it'd obviously be nicer to have connected colored lines by type of payment.
// It can be done in Stata, but it's kind of a pain to set up.  
// You can get the gestalt by sorting in the right order so it'll connect the dots in the right order.
gsort fiscalyeartype fiscalyear qtr 
twoway(connected spent qtr if (agency == "USAID") & inrange(fiscalyear, 2010, 2013)), by(fiscalyear)
 
