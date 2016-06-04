/*-------------------------------------------------------------------------------
# Name:		ProgrammingCheatsheet.do
# Purpose:	Code to reproduce examples from cheat sheet
# Author:	Tim Essam, Ph.D. (tessam@usaid.gov) & Laura Hughes, Ph.D (lhughes@usaid.gov)
# Created:	2016/05/27
# License:	MIT License
# Ado(s):	mat2txt, estout, outreg2, 
#-------------------------------------------------------------------------------
*/

* Load in the auto.dta for demonstration purposes
* cd "yourWorkspace"
capture log close
log using "ProgrammingCheatsheet.log", replace
sysuse auto, clear

* -----------------------------------------------------------------------------*
*### Scalars - store numeric or string values to be called later
/* both r- and e-class results contain scalars
   Notes: Be careful when naming scalars: if a variable and a scalar
   have the same name, Stata will assume you are calling the variable.
   (see http://www.stata-journal.com/sjpdf.html?articlenum=dm0021) */

scalar x1 = 3
scalar a1 = "I am a string scalar"

* list scalars, drop scalar x1
scalar list
scalar drop x1


* -----------------------------------------------------------------------------*   
*### Matrices - for more advanced matrix commands see the Mata Reference Manual
/* e-class results matrices scalars */

matrix a = (4 \ 5 \ 6)
matrix b = (7 , 8 , 9) 

* Transpose matrix b
matrix d = b'

* Combine matrices by row and by column
matrix ad1 = a \ d
matrix ad2 = a , d 

* Select columns 1 and 3 of matrix b and store in new matrix x
* findit matselrc
matselrc b x, c(1 3)

* Export matrix to a text file (useful for estimation results)
mat2txt, matrix(ad1) saving("filename.txt") replace

* List all matrices, show contents of a single matrix and remove matrices
matrix dir
matrix list b
matrix drop _all


* -----------------------------------------------------------------------------*
* ### Macros - a name that is linked to text (a pointer)
/* GLOBAL macros have global scope, they are available throughout a Stata session (PUBLIC)
   Notes: be careful with globals because they can result in naming conflicts */

global pathdata "C:/Users/SantasLittleHelper/Stata"
cd $pathdata

global myGlobal price mpg length
summarize $myGlobal

/* LOCAL macros are available only to programs, loops or .do files (PRIVATE) */

local myLocal price mpg length
summarize `myLocal'

* Create a local macro called levels that takes each unique value in the variable rep78
* Loop through the contents of levels and display each unique value
levelsof rep78, local(levels)
foreach x of local levels {
	display in yellow "`x' is a unique value of rep78"
}
*end

* Create a local variable that stores the variable label in a local called varLab
* This can be useful when batch renaming variables based on their labels (see also strtoname)
local varLab: variable label foreign
display "`varLab'"
local varLab2 = strtoname("`varLab'")
rename foreign `varLab2'

* TEMPVARS, TEMPNAMES & TEMPFILES - assign names to specified local macro names 
* used as temp vars, names or files.

* Initialize a temp variable called temp1, save the squared value of mpg in temp1, summarize the result
tempvar temp1
generate `temp1' = mpg^2
sum `temp1'

/* I usually visit (http://www.cpc.unc.edu/research/tools/data_analysis/statatutorial/misc/temp_files) 
   for help on using temporary files. The can be really useful when merging different iterations 
   of a dataframe.
   See also here (http://www.stata.com/statalist/archive/2004-01/msg00542.html)*/
   
tempfile myAuto
display "`myAuto'"
save `myAuto', replace



* -----------------------------------------------------------------------------*
* ### Access and Save stored r- and e-class Objects
/* Many Stata commands store results in types of lists. To access these lists
   use the return or ereturn command. Stored results can be scalars, macros, matrices
   or functions (not covered in the cheat sheet). */
   
* summarize the price variable in the auto data; Store the mean in the variable p_mean1
sysuse auto, clear
sum price, d
return list
gen p_mean1 = r(mean)

* Estimate the mean of price along with standard errors
mean price 
ereturn list
gen meanN = e(N)

* Extract the mean estimate from the e(b) matrix and store in a new matrix p_mean2
* Compare the output with that obtained from the summarize command. 
matrix p_mean2 = e(b)
matrix list p_mean2
sum p_mean

* PRESERVE & RESTORE - use preserve and restore to set restore points when testing programs or code
sysuse auto2, clear
preserve
	mean price
	drop if inlist(rep78, 1, 2)
	sum price
restore

mean price



* -----------------------------------------------------------------------------*
/* ### RETURNING STORED RESULTS - after executing an execution command, the results of the 
   estimates are stored in a structure that you can save, view, compare and export. 
   The estout, outreg2 and putexcel commands are great tools to help you get your output
   outside of Stata. 
   */

* Estimate a simple regression model and save the estimate results in est1
est clear
regress price weight
estimates store est1
est dir

* ssc install estout or adoupdate, update (be careful with the latter, it updates everything!)
* Ues the estout package syntax to save estimates
eststo est2: reg price weight mpg
eststo est3: reg price weight mpg foreign

* Base Stata estimates table command produces a summary table of the regression coefficients
estimates table est1 est2 est3

* But, the estout package provides numerous, flexible options for making output tables.
esttab est2 est3, se star(* 0.10 ** 0.05 *** 0.01) label

* Save the results to a text file
esttab using "auto_reg.txt", replace plain se 

* The outreg2 package can produce similar results (ssc install outreg2)
outreg2 [est1 est2 est3] using "auto_reg2.txt", see replace



* -----------------------------------------------------------------------------*
/* ### LOOPS - use loops to automate repetitive tasks. 
   Anatomy of a loop: Stata has three options for repeating commands over lists or values:
   foreach, forvalues and while. Though each has a different first line, the basic syntax
   is the same:
   
   foreach x of varlist var1 var2 var3 {
		sum `x', details
	}
	
   Loops must contain an open brace on the first line and a closed brace on the last line.  */

* FOREACH: repeating commands over strings, lists or variables

* Compare the rep78 variable in the auto and auto2 datasets
foreach x in auto.dta auto2.dta {
	sysuse "`x'", clear
	tab rep78, missing
	}
*end

* Print the length of elements in a list of strings
foreach x in "Dr. Nick" "Dr. Hibbert" {
	display in yellow "`x' contains "  length("`x'") " characters"
	}
*end

* Iterate through variables in a dataset using different syntaxes
foreach x in mpg weight {
	summarize `x', detail
	}


*end

* When using foreach of you must state the list type you are using. This declaration
* makes the loop execute slightly faster than the general foreach in loop.
foreach x of varlist mpg weight {
	summarize `x', detail
	}

*end

* Use the forvalues option to loop over values
forvalues i = 10(10)50 {
	display `i'
	}
*end


* Set a trace to see how Stata is implementing loops
set trace on
forvalues i = 10(10)50 {
	display `i'
	}
*end
set trace off
	
* Looping through locals (not covered in cheat sheet) and store results in matrix
* (Not a great example, but you get the idea)
capture clear matrix xbar

* Define global macros vars1 and vars2
local varsToSum price weight mpg
local num : list sizeof varsToSum
display "`num'"

/* Initialize an empty matrix called xbar that has rows equal to the elements in the local macro
; We will use this to store the results*/
matrix xbar=J(`num',1,.)
local i = 1
foreach x of local varsToSum {
	* Calculate the mean for each global
	sum `x'

	* store the results in matrix xbar
	matrix xbar[`i',1]=r(mean)
	
		* Check that everything worked
	if `i' == `num' {	
		matrix list xbar
		}
		
	* iterate to next row in xbar matrix
	local i = `i' + 1
	}
*end

* Looping through globals for a regression model (you can add globals to other globals)
sysuse auto2, clear
est drop _all
global drop spec*

global spec1 "mpg"
global spec2 "$spec1 ib(3).rep78 headroom"
global spec3 "$spec2 length turn displacement"

* Loop through globals and combine regression results into a single table
forvalues i = 1/3 {
	* run OLS and store results
	eststo spec`i': regress price ${spec`i'}, robust
	
	if `i' == 3 {
		esttab spec*, se star(* 0.10 ** 0.05 *** 0.01) label ar2
		}
	}
*end

* -----------------------------------------------------------------------------*	
* PUTTING IT ALL TOGETHER:
sysuse auto, clear

* Generate a new variable called car make taking value of first word in variable make
generate car_make = word(make, 1)
levelsof car_make, local(cmake)
local i = 1

local cmake_len: word count `cmake'
foreach x of local cmake{
	display in yellow "Make group `i' is `x'"
		if `i' == `cmake_len' {
			display "The total number of groups is `i'"
				}
		local i = `++i'
	}
*end


* -----------------------------------------------------------------------------*
**** Not covered in cheat sheet but useful ****

* Below is a brief example a program. If you find yourself cutting and pasting
* your code more than 2 or 3 times, think about writing a program. For more on
* writing programs see https://www.ssc.wisc.edu/sscc/pubs/stata_prog_old.htm or
* check out the official Stata Blog (http://blog.stata.com/)

*! VERSION 1.0.0 20016.01.28
capture program drop drNick
program define drNick
	display in yellow "Hi Everybody!"
end

* Call the program using its name (drNick)
drNick

* Other useful packages / links not included on our cheat sheets
/* See https://github.com/haghish/MarkDoc for dynamic documents, slides and help files. 
   Brewscheme - create beautiful visualizations: https://wbuchanan.github.io/brewscheme/about/
   
   
   
   
