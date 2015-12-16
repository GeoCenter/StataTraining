clear
capture log close
import delimited C:\Users\Tim\Downloads\Full_ForeignAssistanceData.csv, rowrange(3) 

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
replace Agency = " USAID" if Agency == "usaid" & FiscalYear == 2009

* Scramble up the Categories a bit
replace Category = upper(Category) if Category == "Environment"
replace Category = "DRG" if Category == "Democracy, Human Rights, and Governance" & FiscalYear == 2011
replace Category = "Econ. Dev." if Category == "Economic Development" & FiscalYear == 2012
replace Category = lower(Category) if Category == "Multi-Sector"

tab FiscalYear
replace FiscalYear = 20014 if Agency == "DoD"
replace QTR = 40 if (QTR==4 & Agency == "MCC")
tab FiscalYear QTR

tab FiscalYearType
replace FiscalYearType = "Obgl." if FiscalYearType == "Obligations" & FiscalYear == 2010
replace FiscalYearType = "Disbsmnt." if FiscalYearType == "Disbursements" & FiscalYear == 2010

replace BenefitingCountry = "I.wonder.if.Laura.will.find.this" if BenefitingCountry == "N/A"

* Export a cut of data for Laura and Aaron
export delimited "StataTraining.csv", replace






* Fixes

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

