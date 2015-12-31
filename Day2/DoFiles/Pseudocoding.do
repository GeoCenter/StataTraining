global pathin "C:\Users\Tim\Documents\GitHub\StataTraining\Exercises\Stata"
cd $pathin

* --- 10 min Exercise --- * 
* 1) load the StataTrainingMessy.csv
* 2) browse the data and describe the data, any variables with missing values?
* 3) identify potential data problems and propose solutions
* 4) What is the difference between spent & spent2 & amount?

* ### Solutions ### *

* 1) import
import delimited "StataTrainingMessy.csv", clear

* 2) browse data (may options)
br
codebook, p
codebook, c
describe
inspect
mdesc

* 3) data problems (two ways to resolve)
sum
codebook, c

* ### Fiscal year seems messed up. Look at it in detail
tab fiscalyear, mi

* ### Need to fix some unlikely values (20014)
recode fiscalyear (213 = 2013) (20014 = 2014)
tab fiscalyear, mi

* ### Quarter also look a bit funny
tab qtr, mi
recode qtr (40 = 4) (0 = .)
tab qtr, mi

* ### Fiscal year type is not consistent
tab fiscalyeartype, mi
replace fiscalyeartype = "Disbursements" if fiscalyeartype == "Disbsmnt."
replace fiscalyeartype = "Obligations" if fiscalyeartype == "Obgl."
tab fiscalyeartype, mi

* ### Seems ok except for the many N/A
tab account, mi sort
replace account = "Unknown" if account == "N/A"
tab account, mi sort

* ### what are the problems with the Agency names?
tab agency, mi

* ### lots of problems: 1) USAID, 2) Stata! 3) MCC has spaces 4) Peace Corps all caps

* ### First, USAID is not consistent. Use the regexm function to fix all occurences
replace agency = "USAID" if regexm(agency, "(U.S.A.I.D|usaid|USAID )") == 1

* Fix the errors created by leading spaces
replace agency = trim(agency)
tab agency, mi 

replace agency = "DOS" if agency == "Department of Stata"
replace agency = "DOD" if agency == "DoD"
replace agency = proper(agency) if agency == "PEACE CORPS"
tab agency, mi

* Everything looks good, let's move on to operating units

* Operating Unit (ignoring mostly for now)
tab operatingunit, mi 
tab benefitingcountry, mi
replace benefitingcountry = "N/A" if benefitingcountry =="I.wonder.if.Laura.will.find.this"

* For later, let's tag all Benefiting countries that have region in their name
g byte notCountry = regexm(benefitingcountry, "(USAID|Region|Worldwide|Office|Treasury)") == 1
tab benefitingcountry if notCountry

* Category
tab category, mi
replace category = proper(category)
replace category = "Democracy, Human Rights, And Governance" if category == "Drg"
replace category = "Economic Development" if category == "Econ. Dev."
replace category = "Missing" if category == ""
tab category, mi

* Sector
tab sector, mi sort

* Describe the amounts
describe amount spent spent2
codebook amount spent spent2

* 4) spent versus spent2
describe amount spent spent2
compare spent spent2
assert spent == spent2 

compare spent2 amount
*assert string(spent2) == amount
charlist amount

replace spent = spent / 1000000
save "StataTrainingClean.dta", replace
