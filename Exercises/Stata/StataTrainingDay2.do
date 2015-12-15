clear
capture log close
*import delimited C:\Users\Tim\Downloads\Full_ForeignAssistanceData.csv, rowrange(3) 
*import delimited "C:\Users\t\Downloads\Full_ForeignAssistanceData.csv", rowrange(3) 

global pathin "C:\Users\Tim\Documents\GitHub\StataTraining\Exercises\Stata"
cd $pathin
import delimited "Full_ForeignAssistanceData.csv", rowrange(3)

/* Another way of renaming
ren v1 FiscalYear
ren v2 QTR
ren v3 FiscalYearType
ren v4 Account
ren v5 Agency
ren v6 OperatingUnit
ren v7 BenefitingCountry
ren v8 Category
ren v9 Sector
ren v10 Amount
*/

rename (v1 v2 v3 v4 v5 v6 v7 v8 v9 v10)(FiscalYear QTR FiscalYearType Account /*
*/ Agency OperatingUnit BenefitingCountry Category Sector Amount)
drop in 1

/* Another way to grab 1st record of each entry
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
*/

set seed 012016
sample 2.5

destring FiscalYear,  replace
destring QTR, replace

* Create copies of the variables
clonevar Spent = Amount
clonevar Spent2 = Amount

* Brute force
charlist Spent
replace Spent = subinstr(Spent, "$", "", .)
replace Spent = subinstr(Spent, ",", "", .)
g byte missValue = (regexm(Spent, "-") == 1)
replace Spent = "" if missValue == 1

replace Spent = subinstr(Spent, "(", "-", .)
replace Spent = subinstr(Spent, ")", "", .)
destring Spent, replace

*Another approach
* First, flag all variables that contain a negative sign
g byte missValue2 = (regexm(Spent2, "-") == 1)
replace Spent2 = "" if missValue2 == 1
replace Spent2 = subinstr(Spent2, "(", "-", .)
destring Spent2, replace ignore("$" "(" ")" ",") 
format Spent2 %15.2fc

* Check our results
clist Amount Spent Spent2 in 1/5 
clist Amount Spent Spent2 if Spent <0 & Spent >-5000
drop missValue missValue2

* Check that the values in Spent and Spent2 are the same
assert Spent == Spent2

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
replace FiscalYear = 213 if Agency == "MCC"
replace QTR = 40 if (QTR==4 & Agency == "MCC")
tab FiscalYear QTR

tab FiscalYearType
replace FiscalYearType = "Obgl." if FiscalYearType == "Obligations" & FiscalYear == 2010
replace FiscalYearType = "Disbsmnt." if FiscalYearType == "Disbursements" & FiscalYear == 2010

replace BenefitingCountry = "I.wonder.if.Laura.will.find.this" if BenefitingCountry == "N/A"

* Export a cut of data for Laura and Aaron
export delimited "StataTrainingMessy.csv", replace


* Now fix all the errors going through each variable to check plausible values
tab FiscalYear, mi
recode FiscalYear (213 = 2013) (20014 = 2014)
tab FiscalYear, mi

* Show how you can also use recode to do many recodings at once
tab QTR, mi
recode QTR (40 = 4) (0 = .)
tab QTR, mi

tab FiscalYearType, mi
replace FiscalYearType = "Disbursements" if FiscalYearType == "Disbsmnt."
replace FiscalYearType = "Obligations" if FiscalYearType == "Obgl."
tab FiscalYearType, mi

* Seems ok except for the many N/A
tab Account, mi sort
replace Account = "Unknown" if Account == "N/A"
tab Account, mi sort

* What are the problems with the Agency name? (Fix them all at once? or let them try trim?)
tab Agency, mi
replace Agency = "USAID" if regexm(Agency, "(U.S.A.I.D|usaid|USAID )") == 1

* Fix the errors created by leading spaces
replace Agency = trim(Agency)
tab Agency /// What changed?

replace Agency = "DOS" if Agency == "Department of Stata"
replace Agency = "DOD" if Agency == "DoD"
replace Agency = proper(Agency) if Agency == "PEACE CORPS"
tab Agency, mi

* Operating Unit
tab OperatingUnit, mi 
tab BenefitingCountry, mi
replace BenefitingCountry = "N/A" if BenefitingCountry =="I.wonder.if.Laura.will.find.this"

* For later, let's tag all Benefiting countries that have region in their name
g byte notCountry = regexm(BenefitingCountry, "(USAID|Region|WorldWide|Office)") == 1

* Category
tab Category, mi
replace Category = proper(Category)
replace Category = "Democracy, Human Rights, And Governance" if Category == "Drg"
replace Category = "Economic Development" if Category == "Econ. Dev."
replace Category = "Missing" if Category == ""
tab Category, mi

* Sector
tab Sector, mi sort

* Describe the amounts
describe Amount Spent Spent2
codebook Amount Spent Spent2
 
* Spent - don't want to tabulate -- too many observations, many outliers
summarize Spent, detail
histogram Spent 
histogram Spent if inrange(Spent, -466299.9, 1000000)
* Notice the outliers
scatter Spent FiscalYear
scatter Spent FiscalYear, jitter(10)

export delimited "StataTraining.csv", replace


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

