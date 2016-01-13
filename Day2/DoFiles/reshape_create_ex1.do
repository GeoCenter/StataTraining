* Purpose: Create untidy dataset for reshape exercise
* Author: Tim Essam (GeoCenter)`
* Date: 2016.01.13

* Set online directory to github repo for portability
webuse set "https://github.com/GeoCenter/StataTraining/raw/master/Day2/Data"
webuse StataTrainingClean.dta, clear

* Filter out USAID and collapse to make exercise not so confusing
collapse (sum) spent2 if agency == "USAID", by(fiscalyear fiscalyeartype category )

*
rename (spent2 fiscalyeartype) (spent fisc_type)
* First, reshape so that spending is an intersection of fisc_type X spent
* This results in a nearly tidy dataset, but we want to make them work a bit
* so let's reshape again.
reshape wide spent, i(category fiscalyear) j(fisc_type, string)

* This time reshape will intersect spentDis X fiscal year and spentOb X fiscal year.
* This should results in a double-wide dataset
reshape wide spentDisbursements spentObligations, i(category ) j(fiscalyear )
rename spent* *
rename D* O*, lower

encode category, gen(cat_id)
order cat* d* o*

* string 1 variable for the heck of it...kind of being a jerk here,
* but this happens in reality! Look at WB data. 
tostring disbursements2007, replace force
tostring obligations2007, replace force

saveold "C:\Users\t\Documents\GitHub\StataTraining\Day2\Data\reshape_ex1.dta", replace
