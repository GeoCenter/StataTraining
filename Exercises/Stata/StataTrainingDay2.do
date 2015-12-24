/*-------------------------------------------------------------------------------
# Name:		StataTrainingDay2
# Purpose:	Teach students how to conduct basic data munging operations in Stata
# Author:	Tim Essam, Ph.D.
# Created:	2015/12/23
# Owner:	Tim Essam - USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	see below
#-------------------------------------------------------------------------------
*/

*****************
* Preliminaries *
*****************
clear
capture log close
*import delimited C:\Users\Tim\Downloads\Full_ForeignAssistanceData.csv, rowrange(3) 
*import delimited "C:\Users\t\Downloads\Full_ForeignAssistanceData.csv", rowrange(3) 

global pathin "C:\Users\t\Documents\GitHub\StataTraining\Exercises\Stata"
cd $pathin


* --- Loading data --- *
import delimited "Full_ForeignAssistanceData.csv", rowrange(3)

/* Can we work w/ the data in it's current form? What is wrong with it?
	1) strings
	2) variable names in row 1
	3) unique identifier
As a first past, let's fix these problems then look at the data again 
This is often an iterative process. */

* Let's rename the data so we have variable names that make sense
rename (v1 v2 v3 v4 v5 v6 v7 v8 v9 v10)(FiscalYear QTR FiscalYearType Account /*
*/ Agency OperatingUnit BenefitingCountry Category Sector Amount)

* Drop the first row as this is simply a string variable.
drop in 1

**** Other rename methods ****
* --- Basic: way of renaming
/* ren v1 FiscalYear
ren v2 QTR
ren v3 FiscalYearType
ren v4 Account
ren v5 Agency
ren v6 OperatingUnit
ren v7 BenefitingCountry
ren v8 Category
ren v9 Sector
ren v10 Amount

* --- Advanced, but inefficient: if you have large dataset, a loop could be a better option
* 1) Initiate a loop over all the variables
* 2) create a local variable called new name that takes the value of the 1st record
* 3) use strtoname to ensure that the local newname is an acceptable variable name
* 4) print the name to the screne
* 5) rename each variable using the value from the local macro; repeat for all vars

foreach x of varlist _all {
	local newname = `x'[1]
	local varname = strtoname("`newname'")
	display "Renaming `x' to `varname'"
	rename `x' `varname'
}

* Now use the rename command to remove underscores (some bugginess here)
rename *_* **
rename _* *
rename *_ *
rename *_* **


* --- Advanced and efficient; Relies on user-contributed renvars command
* 1) loop over all variables stripping spaces from first record (making string a legal name)
* 2) rename all variables, using the word command to extract the first word

foreach x of varlist _all {
	replace `x' in 1 = subinstr(`x'[1]," ","",.)
	}
*
renvars , map(word(@[1], 1))

*could also use: 
renvars, map(strtoname(trim(@[1])))
*/

	
* Let's sample 2.5% of the data to prevent network lags
set seed 012016
sample 2.5

* Check what characters are contained in FY and QTR
* So these are really numbers that are read-in as strings
charlist FiscalYear 
charlist QTR

* Two ways of destringing.
* 1) use the 'real' function to return a number from a string
generate FiscalYear2 = real(FiscalYear)
generate QTR2 = real(QTR)

* 2) more forcefull, use the destring function to convert
destring FiscalYear,  replace
destring QTR, replace

* Check that QTR & QTR2 are equivalent
assert QTR == QTR2

* Create copies of the variables
clonevar Spent = Amount
clonevar Spent2 = Amount

* Check the problems with these variables
charlist Spent

* Lots of extra characters imported with the numbers. Break the fixes up into parts
* Attempt 1: Replace each special character case-by-case
replace Spent = subinstr(Spent, "$", "", .)
replace Spent = subinstr(Spent, ",", "", .)

* Flag the values that are likley missing and convert them to missing strings
g byte missValue = regexm(Spent, "-") == 1
replace Spent = "" if missValue == 1

* Create markers to denote negative values
replace Spent = subinstr(Spent, "(", "-", .)
replace Spent = subinstr(Spent, ")", "", .)
destring Spent, replace

*Another approach
* First, flag all variables that are likely missing, then replace w/ empty string
g byte missValue2 = (regexm(Spent2, "-") == 1)
replace Spent2 = "" if missValue2 == 1

* Now, let's tackle the negative values. We can use the subinstr command to identify
* where there is a lhs parantheses and replace it with a negative sign; Then we will
* destring the variable ingoring the characters ( ) " ".
replace Spent2 = subinstr(Spent2, "(", "-", .)
destring Spent2, replace ignore("$" "(" ")" ",") 
format Spent2 %15.2fc

* Verifying that our substitutions and conversions worked
clist Amount Spent Spent2 in 1/10 
clist Amount Spent Spent2 if Spent <0 & Spent >-500
drop missValue missValue2
sum Spent Spent2

* Check that the values in Spent and Spent2 are the same
assert Spent == Spent2

* Now create some value labels so we know what we are working with
label variable FiscalYear "fiscal year (string)"
la var QTR "quarter (string)"
la var FiscalYearType "type of foreign assistance"
la var Account "account type"
la var Agency "name of agency"
la var OperatingUnit "name of operating unit"
la var BenefitingCountry "name of benefiting country"
la var Category "category of assistance"
la var Sector "sector code"
la var Amount "amount of assistance (string)"
la var FiscalYear2 "fiscal year (number)"
la var QTR2 "quarter (numberic)"
la var Spent "amount of assistance (number)"
la var Spent2 "amount of assistance (number)"
d

* drop extra variables
drop FiscalYear2 QTR2

compress
save "CleaningNames.dta", replace



*********************
* Making data messy *
*********************
use "CleaningNames.dta", clear

* Mess up some values related to Agency
replace Agency = "U.S.A.I.D" if Category == "Health"
replace Agency = "Department of Stata" if Agency == "DOS"
replace Agency = lower(Agency) if Agency == "USAID"
replace Agency = upper(Agency) if Agency == "Peace Corps"
replace Agency = " USAID " if Agency == "usaid" & FiscalYear == 2009
replace Agency = " MCC " if Agency == "MCC"

* Scramble up the Categories a bit
replace Category = upper(Category) if Category == "Environment"
replace Category = "DRG" if Category == "Democracy, Human Rights, and Governance" & FiscalYear == 2011
replace Category = "Econ. Dev." if Category == "Economic Development" & FiscalYear == 2012
replace Category = lower(Category) if Category == "Multi-Sector"

tab FiscalYear
replace FiscalYear = 20014 if Agency == "DoD"
replace FiscalYear = 213 if Agency == " MCC "
replace QTR = 40 if (QTR==4 & Agency == " MCC ")
tab FiscalYear QTR

tab FiscalYearType
replace FiscalYearType = "Obgl." if FiscalYearType == "Obligations" & FiscalYear == 2010
replace FiscalYearType = "Disbsmnt." if FiscalYearType == "Disbursements" & FiscalYear == 2010

replace BenefitingCountry = "I.wonder.if.Laura.will.find.this" if BenefitingCountry == "N/A"

* Export a cut of data for Laura and Aaron
export delimited "StataTrainingMessy.csv", replace





* Check how many DC offices are represented in data
tab OperatingUnit if regexm(OperatingUnit, "(USAID|Region|Worldwide)") == 1, sort 
codebook OperatingUnit if regexm(OperatingUnit, "(USAID|Region|Worldwide)") == 1
clist OperatingUnit if regexm(OperatingUnit, "(USAID)") == 1 

* Keep only USAID programs
keep if regexm(Agency, "(USAID)")==1

* Drop USAID Offices & Regions
drop if regexm(OperatingUnit, "(USAID|Region|Worldwide)")











* Look at the Accounts
tab Account, sort mi
replace Account = "Account Unknown" if Account == "N/A"

clonevar Country = OperatingUnit
replace Country = "Bosnia and Herzegovina" if Country == "Bosnia-Hercegovina"
replace Country = "China" if Country == "China, People's Republic"
replace Country = "Taiwan" if Country == "China, Republic of (Taiwan)"
replace Country = "Kyrgyzstan" if Country == "Kyrgyz Republic"
replace Country = "Democratic Republic of the Congo" if Country == "Congo, Democratic Republic of"
replace Country = "Republic of the Congo" if Country == "Congo, Republic of"
replace Country = "The Gambia" if Country == "Gambia, The"
replace Country = "North Korea" if Country == "Korea, North"
replace Country = "South Korea" if Country == "Korea, Republic of"
replace Country = "Federated States of Micronesia" if Country == "Micronesia"
replace Country = "Moldova" if Country == "Moldovia"
replace Country = "Sudan" if Country == "North Sudan"
replace Country = "Palau" if Country == "Palau Islands"
replace Country = "Somoa" if Country == "Western Samoa"
replace Country = "West Bank-Gaza" if Country=="West Bank and Gaza"
replace Country = "South Korea" if Country=="Korea, South"
replace Country = "Syria" if Country=="Syrian Arab Republic"
replace Country = "Barbados" if Country=="Barbados and Eastern Caribbean"
replace Country = upper(Country)

