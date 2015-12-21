** FUNDAMENTALS OF DATA ANALYSIS AND VISUALIZATION (USING STATA)
** INSTRUCTORS: AARON CHAFETZ, TIM ESSAM, LAURA HUGHES  
** DAY 1 DO FILE  (1/8/16)
** CREATED: 12/15/15
** MODIFIED: 12/20/15

/* Notes on Do files
Stata reads each line as a command
Notes can be added in a few different ways
* or // at the start of a line will tell Stata to ignore the text as a command
// can be added at the end of a line to add a note
/// can be added at the end of a line to break the code over two lines
And you can run text over multiple lines starting with /* and ending with */

/* Notes on command structure
All stata commands have a similar structure, starting with a command on a 
	variable, which can be followed by an expression or other options.
[by varlist:] command [varlist] [=exp] [if exp] [in range] [weight] [, options]	[ ] - indicate optional	varlist Ð list of variable names	exp Ð algebraic expression	range Ð observation range	weight Ð weighting expression
For help on any function, in the command line write "help [command]"
*/

/*
Statistical tools are only as useful as the data you have available to you, 
	so lets start by importing some dataWeÕll be working with Foreign Assistance Dashboard dataYou can import data in csv or xlsx amongst other formats. 
The data weÕre using is in Excel fileOpening it up in Excel, we can see there are a few issues right off the bat. 
We need data to be loaded where the variables are the headers. 
Additionally, we can only import one tab of data in at a time.
*/

/*
Before starting, you should setup your file/folder structure for this 
	"project" similar to what was discussed in the presentation where
	you have sperate folders for your data, documents, and do files
*/

// PART II - Importind data and basic commands//

*Let's start by looking at the help documentation for importing 
	help import
*before we import, let's set the directory we want to work with
	cd // this will show us what our current working directory is
	global pathin "/Users/Aaron/Desktop/StataTraining/Day1/Data/" //we're defining a global macro that can be used throughout the code
	cd $pathin // this changes our working directory location
*import the data
	insheet using "StataTraining.csv", /// file to import (in the working directory)
		clear //clears out any data in current session
*we can save the initial file as a Stata (.dta) file
	save FAD.dta, /// file will save to the same directory we defined working in
		replace	//replaces the file if its already existing
* with that data imported, we can see the variables listed to the right
* we can browse the data in a way that looks like Excel
	browse

/*numbers are colored black; numbers with variable labels are stored as blue;
	and string (or text) is stored as red */
*we can get a quick description of our variables
	describe
*we can quickly sort and then list our the top expenditures in 2013
	sort spent // sorts ascending 
	gsort - spent //allows us to sort in decending order (negative sign)
	list benefitingcountry agency spent ///
		in 1/10 // this gives us the first 10 lines
	list benefitingcountry agency spent in 1/10

*a useful way to start looking through our data is to use sum and tab commands
*let's get some summary stats on spent
	sum spent, d // gives more detail
*lets get an average by year
	bysort fiscalyear: sum spent
*we can clean this up displaying the data in a table
	table fiscalyear, /// sets up our table by years
		c(mean spent med spent count spent) // we're then telling stata what statistics we want displayed
*lets look at spending in a particular area
	table fiscalyear ///
		if sector == "Agriculture", /// looking at just Ag projects
		c(mean spent med spent)
*lets look at spending in multiple areas
	table fiscalyear sector ///
		if inlist(sector, "Agriculture", "Nutrition", "Malaria"), ///
		c(mean spent)
		
// PART III - Group Exercise I //


// PART IV - Working with variables//

*we can create a new variable that shows amount in millions 
	gen spent_mil = spent/1000000
*we can label the variable 
	lab var spent_mil "Amount, millions USD"
		format spent_mil %9.0fc //adding formatting - see help format
	list operatingunit agencyname spent_mil in 1/10
*we can also add value values to 
	lab def lqtr 1 "Q1" 2 "Q2" 3 "Q3" 4"Q4"
*and then apply that label to the quarter variable
	lab val qtr lqtr
*we can see the labels were applied looking at the codebook or just browsing
	codebook qtr
	browse qtr
*its also useful to encode variables from string to text
*this converts the string to a number and then addes the string back as a value label
	encode sector, gen(sect)
	encode category, gen(cat)
*we can reorder the variables that show up in the variable window and browser
	order sect cat, after(benefitingcountry)
*and we can drop unnessary variables
	drop sector category spent2
*we can also drop line items
	drop if operatingunit=="Worldwide"
	
// Part IV - Group Exercise II //

// Part V - More complex functions //

*we can collapse to sum up by year and country via collapse command
*this will "permanently" change the dataset (we can preserve it and restore it after we finish if its going to be a quick "look")
*let's collapse the data again to look at just Ag projects by year and OU
	collapse (sum) spent ///
		if sector == "Agriculture", ///
		by(fiscalyear sector operatingunit)
*we can use the egen (extended generate) cmd to create more complex variables
*help egen //check out for more egen functions
*one function is rank
	egen rank = rank(-spent), by(fiscalyear) //negative added to sort in decending order
	sort fiscalyear rank
	browse rank operatingunit spent if fiscalyear==2013
*let's create a dummy variable for OUs w/ greater than avg expenditures
*add the yearly mean amount to each OU
	egen meanexp = mean(spent), by(fiscalyear)
*add variable to identify if OU ag spending is > avg
	gen highexp = 0 // all OUs are given a zero
		replace highexp = 1 if spent > meanexp 
*lets create value labels and apply them to highexp
	lab var highexp "Ag expenditures greater than avg"
		lab def yn 0 "No" 1 "Yes"
		lab val highexp yn
*we can use the tabulate cmd to see frequencies
	tab fiscalyear highexp
	
	

