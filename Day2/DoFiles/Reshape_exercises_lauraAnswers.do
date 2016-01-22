/*
Reshape Exercises -- Week 2 of Fundamentals of Data Analysis & Visualization

Laura Hughes, lhughes@usaid.gov, 18 January 2016

*/
clear
capture log close

* --- Exercise 1 --- *

* Run the lines below to set up a wide dataframe (highlight all the lines below up to Question 1
* and then press ctrl + d to input the dataframe)
input str3 country str5 agency q1FY2009 q2FY2009 q3FY2009 q4FY2009 q1FY2010 q2FY2010 q3FY2010 q4FY2010
"AFG"	"USAID"	399	361	254	71	378	398	85	39
"ALB"	"USAID"	45	282	40	285	306	230	398	216
"ANG"	"USAID"	354	24	19	252	146	123	369	376
"ARM"	"USAID"	86	89	127	212	394	255	141	74
"AZE"	"USAID"	116	239	330	34	92	315	312	220
end

* -- Goal: tidy the dataset
/*
Eventually we will want something like:

* ------- * ---- * ------- * ------ * ---- *
* country * year * quarter * agency * freq *
* ------- * ---- * ------- * ------ * ---- *
*   AFG   * 2009 *    1    *        *	   *
*   AFG   * 2009 *    2    *        *	   *
*   AFG   * 2009 *    3    *        *	   *
*   AFG   * 2009 *    4    *        *	   *
* ------- * ---- * ------- * ------ * ---- *
*   AFG   * 2010 *    1    *        *	   *
*   AFG   * 2010 *    2    *        *	   *
*   AFG   * 2010 *    3    *        *	   *
*   AFG   * 2010 *    4    *        *	   *
* ------- * ---- * ------- * ------ * ---- *
* ... (repeat for other countries)		   *
* ------- * ---- * ------- * ------ * ---- *
*/


* --- Question 1: 
* Use the "reshape" (long) command to create a new variable named "year"
* What does the resulting data frame look like? How many quarter variables are left?

// First, we need to see what's our unique variable.
browse

// country seems to be unique... let's double check with isid
isid(country)

// Since it doesn't give us an error, it's unique! We'll use that as our unique id ("i" variable)

/*
Time to set up the reshape.

We want to get to something like: 

* ------- * ------ * ---- * -- * -- * -- * -- *
* country * agency * year * q1 * q2 * q3 * q4 *
* ------- * ------ * ---- * -- * -- * -- * -- *
*   AFG   *        * 2009 *    *    *    *    *
*   AFG   *        * 2010 *    *    *    *    *
* ------- * ------ * ---- * -- * -- * -- * -- *
* ... (repeat for other countries)			  *
* ------- * ------ * ---- * -- * -- * -- * -- *

Our "i" variable will be what's unique in the wide dataset-- country
Our "j" variable is a new variable which will take the year numbers

Now for the tricky bit... we want to reshape all the quarter variables.
Since each of them have a different quarter number attached to them, we need to 
type out each of those variables, adding in an @ symbol where the number goes.

For instance:

q1FY@ will select q1FY2009 and q1FY2010 
-- and 2009 and 2010 will be saved in the variable year when those columns get split apart in the reshape.

*/

reshape long q1FY@ q2FY@ q3FY@ q4FY@, i(country) j(year)

list

/*
We now have a somewhat neater table, where each column is a quarter 
and each year is stacked.
*/




* --- Question 2: 
* Use the "rename" command to rename the remaining variables (quarter) in a 
* manner that allows you to reshape again. Then, use the "reshape" (long) command
* to create a tidy data frame.  

// To reshape again, we need to get rid of the FY part of the column names so
// each column is in the form Q@, where @ is the quarter number.

rename(q1FY q2FY q3FY q4FY)(Q1 Q2 Q3 Q4)

/*
Reshape setup: 

We want it to look like our end goal:

* ------- * ---- * ------- * ------ * ---- *
* country * year * quarter * agency * freq *
* ------- * ---- * ------- * ------ * ---- *
*   AFG   * 2009 *    1    *        *	   *
*   AFG   * 2009 *    2    *        *	   *
*   AFG   * 2009 *    3    *        *	   *
*   AFG   * 2009 *    4    *        *	   *
* ------- * ---- * ------- * ------ * ---- *
*   AFG   * 2010 *    1    *        *	   *
*   AFG   * 2010 *    2    *        *	   *
*   AFG   * 2010 *    3    *        *	   *
*   AFG   * 2010 *    4    *        *	   *
* ------- * ---- * ------- * ------ * ---- *
* ... (repeat for other countries)		   *
* ------- * ---- * ------- * ------ * ---- *

We know we want to whack Q1 into a "quarter" variable which is 1, 2, 3, or 4.
So quarter is our new variable that goes into the "j" argument.

The vars we want to reshape are Q@ (Q followed by a number)

Now we just need our unique ID.  Last time we used country... does that still work?

*/

* isid(country) // No longer unique

// Country isn't unique, since we converted the wide dataset into a long one by year.
// So we should be able to combine country and year as our unique id.
isid(country year)

reshape long Q@, i(country year) j(quarter)

list in 1/20 // show the first 20 rows.

// Looks a-okay.  As a final tidying up, I'll rename Q column. 
// Since I'm not entirely sure what the numbers in the table represent, I'll just call it 'freq'
rename(Q)(freq)

* --- Question 3:
* Use the "table" command to create a two-way table of the average frequency
* by country and year
table country year, c(mean freq)


// Interesting... Afghanistan has a lot more of something in 2009 compared to 
// other countries, but not in 2010.



* -----------------------------------------------------------------------------*

* --- Exercise 2 --- *

* Run the lines below to set up a wide dataframe (highlight all the lines below up to Question 1
* and then press ctrl + d to input the dataframe)
clear
input cid date changeAg changeSrvices
1 2015	8.28 4.12 
1 2016  9.23 5.69
2 2015 9.10 -5.23 
2 2016 10.55 6.92
end
label variable cid "country id"
label variable date "year"
label variable changeAg "Agricultural growth (% of GDP)"
label variable changeSrvices "Service growth (% of GDP)"

* --- Question 1: 
* Reshape (long) the dataframe to create a new variable called gdpType. It should contain
* the string values currently contained in the variables found in columns 3 and 4.
* Hint: use the "string" option when specifying the j variable in your reshape

list

// First: let's find the unique variable, which will go in our argument for "i"
// We can check if something is unique using "isid"
// cid seems like a good choice, but there are repeated values.

* isid(cid) // Will break code, since contains non-unique values.

// What if we combine cid and date together?
isid(cid date)

/*
Setting up the reshape:

Where we want to go: eventually we want this:

* --- * ---- * -------- * --------- *
* cid * date *   type   * changeGDP *
* --- * ---- * -------- * --------- *
*  1  * 2015 *    ag    *           *
*  1  * 2015 * services *           *
* --- * ---- * -------- * --------- *
*  1  * 2016 *    ag    *           *
*  1  * 2016 * services *           *
* --- * ---- * -------- * --------- *
* ... (repeat for cid == 2)			*
* --- * ---- * -------- * --------- *


- From isid, we know our unique variable is the combo of cid and date.
That'll go in our "i" argument.

- the column changeAg and changeServices are the two that we want to combine
into a single column. So if we specify change@, it'll look for columns that
start with change and save the rest of the column name in a new variable.

- ... and our new variable which will contain the "ag" and "srvices" part of 
those variables will go into a new variable "gdpType" which we will save in the "j" argument.

NOTE: since the "change" variables don't have numbers, but rather strings in
their names, we will need to add the "string" option to j.
*/

reshape long change@, i(cid date) j(gdpType, string)

list

* --- Question 2: Use the replace command to change all the occurences of "Ag" to
* "Agriculture" and to change all occurences of "Srvices" to "Services"
replace gdpType = "Agriculture" if gdpType == "Ag"
replace gdpType = "Services" if gdpType == "Srvices"

* --- Question 3: Rename the "change" variable to be more descriptive
rename(change)(changeGDP)

label variable changeGDP "growth (% of GDP)"  // Add a label so we know what it represents.


* -----------------------------------------------------------------------------*
* --- Exercise 3 --- *
clear
input str11 CountryName	str3 CountryCode	str35 SeriesName	year2012
"Afghanistan"	"AFG"	Ag	24.60324707
"Afghanistan"	"AFG"	GDP	14.43474129
"Afghanistan"	"AFG"	Tax	7.471638846
"Kenya"	"KEN"	Ag	29.08937253
"Kenya"	"KEN"	GDP	4.554912438
"Kenya"	"KEN"	Tax	15.87837126
"Pakistan"	"PAK"	Ag	24.54909124
"Pakistan"	"PAK"	GDP	3.50703342
"Pakistan"	"PAK"	Tax	10.09935899
"Senegal"	"SEN"	Ag	16.72581231
"Senegal"	"SEN"	GDP	4.363200853
"Senegal"	"SEN"	Tax	19.182225
end

* --- Question 1: Reshape (wide) the dataframe to create three new variables that contain
* the values for the SeriesName variable. 
* Hint: use the ", string" option for the j variable. Also, when reshaping wide
* you do not need to use the "@" character, just the stub 
list

/* 
Setting up the reshape

At the end of this reshape, we want each row to be a single country.
The data from year2012 will be be in 3 columns (Ag, GDP, Tax)
CountryCode is along for the ride:

* ----------- * ----------- * -- * --- * --- *
* CountryName * CountryCode * Ag * GDP * Tax * 
* ----------- * ----------- * -- * --- * --- *
* Afghanistan * 			*    *     *     *
* Kenya		  *				*    *     *     *
* Pakistan 	  *				*    *     *     *
* Senegal 	  * 			*    *     *     *
* ----------- * ----------- * -- * --- * --- *

- Since we're splaying out SeriesName, that'll go in the "j" argument.
The data in SeriesName are strings, not numbers, so we need to add in the
", string" option

- And the data is located in year2012, so that's our columns that we want to splot.

- Lastly, our "i" id argument.  In wide reshapes, it's not a unique
identifier, but what we _want_ to be unique after the transform.
That's country in this case

* isid(country) // not unique.. but soon it will be.
*/

reshape wide year2012, i(CountryName) j(SeriesName, string)

list

* --- Question 2: Rename the resulting variables and create a new variable called "year"
* that takes the appropriate value of the year given in the original dataframe.
rename(CountryName year2012Ag year2012GDP year2012Tax)(country ag gdp tax)

list 
// By "appropriate" value of the year, I'm assuming they mean the fact that the
// data in the original dataset were called "year2012". So the year is 2012.

// I could see this being important if you're adding in (appending) new data
// from another year(s).

gen year = 2012


* --- Question 3: Do you think the dataframe needed to be reshaped wide? Why or why not?

/*
It depends on what you want to do! If you're looking at the relationship between
gdp, taxes, and ag growth, you probably want it wide.

If you want to clean, edit, manipulate data, I would keep it long.
*/



* -----------------------------------------------------------------------------*


* --- Extra Credit: Exercise 4 --- *

* Reshaping long to wide *

* Run the lines below to set up a messy dataframe (highlight all the lines below
* question 1 and press ctrl+d)
clear
input str5 person	str5 software year2014 year2015 year2016
"Tim" "Stata"	5.93	2.40	10.25
"Tim" "R"	100	56	515
"Laura" "Stata"	3.09	4.26	7.93
"Laura" "R"	917	751		253
"Aaron" "Stata"	3.09	4.26	5.23
"Aaron" "R"	115	235	613
"Doug" "Stata"	7.35	3.23	1.3
"Doug" "R"	478	646	920
end

* Attach variable labels
label variable software "type of software"
label variable year2014 "github commits for 2014"
label variable year2015 "github commits for 2015"
label variable year2016 "github commits for 2016"


* --- Goal: 
* Reshape the data so that "Stata" and "R" are new variables in a tidy data frame

/*
So eventually we want to get to a form that looks like this: 

* ------ * ---- * - * ----- *
* person * year * R * Stata *
* ------ * ---- * - * ----- *
* Tim    * 2014 *   *       *
* Tim    * 2015 *   *       *
* Tim    * 2016 *   *       *
* ------ * ---- * - * ----- *
* Laura  * 2014 *   *       *
* Laura  * 2015 *   *       *
* Laura  * 2016 *   *       *
* ------ * ---- * - * ----- *
* Aaron  * 2014 *   *       *
* Aaron  * 2015 *   *       *
* Aaron  * 2016 *   *       *
* ------ * ---- * - * ----- *
* Doug   * 2014 *   *       *
* Doug   * 2015 *   *       *
* Doug   * 2016 *   *       *
* ------ * ---- * - * ----- *
*/

* --- Question 1:
* Use the "reshape" (wide) command to create new variables for the types of software

* Hint 1: when reshaping long --> wide your i variable (unique ID) is the variable
* that will be unique only after reshaping.

* Hint 2: the j variable is the existing string variable you want to reshape into a
* new column. You will need to use the ", string" option when reshaping

* Hint 3: use the * (wildcard) instead of the @ character in the first half of the reshape
* command

list 
// Hey... is this real data? Tim was being a slacker in 2015!

/*
Setting up the reshape...

We want to reshape wide to where everyone has a single like for each observation.
So it'll look something like this:

* ------ * ----- * ----- * ----- * --------- * --------- * --------- *
* person * R2014 * R2015 * R2016 * Stata2014 * Stata2015 * Stata2016 *
* ------ * ----- * ----- * ----- * --------- * --------- * --------- *
* Tim	 * 		 * 		 * 		 * 		     * 		     * 		     *
* Laura	 * 		 * 		 * 		 * 		     * 		     * 		     *
* Aaron	 * 		 * 		 * 		 * 		     * 		     * 		     *
* Doug	 * 		 * 		 * 		 * 		     * 		     * 		     *
* ------ * ----- * ----- * ----- * --------- * --------- * --------- *

That means we want to tack on the contents of software (which is a string)
onto every variable starting w/ "year"

- the year variables will be our columns we want to change 

- our "j" variable will be the type of software (a string)

- and the variable we want to be unique is the person ("i" variable)
*/


// Explicit way... but imagine what'd happen if we had 40 years of data...
* reshape wide year2014 year2015 year2016, i(person) j(software, string)

// Lazy (efficient) way. * means look for any variable starting w/ year
reshape wide year*, i(person) j(software, string)

list

* --- Question 2:
* Reshape the data (long) so that "R" and "Stata" form their own columns and can be sorted by year
* Hint: use the "@" where you expect the year value to appear

/*
Setting up the reshape

We want to get here:

* ------ * ---- * - * ----- *
* person * year * R * Stata *
* ------ * ---- * - * ----- *
* Tim    * 2014 *   *       *
* Tim    * 2015 *   *       *
* Tim    * 2016 *   *       *
* ------ * ---- * - * ----- *
* Laura  * 2014 *   *       *
* Laura  * 2015 *   *       *
* Laura  * 2016 *   *       *
* ------ * ---- * - * ----- *
* Aaron  * 2014 *   *       *
* Aaron  * 2015 *   *       *
* Aaron  * 2016 *   *       *
* ------ * ---- * - * ----- *
* Doug   * 2014 *   *       *
* Doug   * 2015 *   *       *
* Doug   * 2016 *   *       *
* ------ * ---- * - * ----- *

- we know that person is our unique id ("i"), 
since we just defined it to be the unique variable in the previous reshape.

- our new variable, which will be the year number, will go in the "j" argument.

- now for the tricky bit-- which column(s) do we want to split apart, and save the column name in the year?
We want the year number sliced out of the column name for ALL the variables like 
year2014R, year2014Stata, year2015R, ...

There are two patterns in those columns:
year----R (where ---- is 2014, 2015, or 2016)
year----Stata (where ---- is 2014, 2015, or 2016)

We can use the @ symbol to represent the number squished between year and R or Stata.

So the two column names are year@R and year@Stata.

*/

isid(person)

/*
An inefficent pathway-- real life detour!

This will work, but you'd be left with the 'new' variable containing 
two pieces of info: the year number and the software type (R or Stata)

You could fix this by splitting the new variable into the software type 
and the year (using regular expression matching), and converting the 
year from a string to a number.  Or you can use Stata's capabilities to 
do everything in one go, as explained in the note above and implemented below.

reshape long year@, i(person) j(new, string)
*/

reshape long year@R year@Stata, i(person) j(year)
rename(yearR yearStata)(R Stata)


* --- Question 3: Use the table or tabstat (help table or help tabstat) command to summarize the data 
* Who coded the most in R, in total, over the 3 years?
* Who coded the most in Stata, on average, over the last 3 years?

table person, c(mean R mean Stata sum R sum Stata)
tabstat R Stata, stat(mean sum) by(person)

/* Answer
most total R: Doug! (though I'm a close 2nd)
most average Stata: Tim (curious... Tim makes this exercise, 
and he's the grand Stata guru.  VERY curious...
*/

* Bonus part 2: Redo the exercise, this time use the reshape long command first followed
* by the reshape wide command. 

// Reload the data, since it's changed.
clear
input str5 person	str5 software year2014 year2015 year2016
"Tim" "Stata"	5.93	2.40	10.25
"Tim" "R"	100	56	515
"Laura" "Stata"	3.09	4.26	7.93
"Laura" "R"	917	751		253
"Aaron" "Stata"	3.09	4.26	5.23
"Aaron" "R"	115	235	613
"Doug" "Stata"	7.35	3.23	1.3
"Doug" "R"	478	646	920
end

* Attach variable labels
label variable software "type of software"
label variable year2014 "github commits for 2014"
label variable year2015 "github commits for 2015"
label variable year2016 "github commits for 2016"

// For the record, I think this path is much easier.

/* To reshape I need to find the unqiue id: the variable or set of variables 
which uniquely identify each observation.

Person won't work, since each of us is listed twice.  
What if we combine person + coding language? We can check that's unique with isid.
*/

isid(person software)

// Since that doesn't give me an error, it's unique.
// We'll use that as the "i" variable within reshape, the variable which has the
// unique id.
// We'll want to split up the "year" columns, so we'll add in the argument year@
// This will have the reshape function look for any columns starting with "year", 
// and it'll whack off the year numbers and throw it into a new variable.
// Within the "j" variable goes the name of the new variable to be created in the reshape. 
// Ideally, we want that to be "year", but year will be used.

* reshape long year@, i(person software) j(year) // Gives an error, since year is already defined.
reshape long year@, i(person software) j(new)

rename (year new)(codingOutput year)

// Reshape #2-- convert from long to wide with R and Stata as each of the vars.

reshape wide codingOutput, i(person year) j(software, string)
rename(codingOutputR codingOutputStata)(R Stata)

table person year, c(mean R mean Stata)
