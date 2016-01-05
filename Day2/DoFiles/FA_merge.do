cd "C:\Users\Tim\Documents\Github\StataTraining\Day2\Data"

* Create a merge dataset for the homework
use StataTrainingClean.dta, clear

keep if regexm(benefitingcountry, "(Afghanistan|Geogria|Kenya|Pakistan|Senegal)") ///
 & inlist("Disbursements", fiscalyeartype)

* Create unique IDs for each country -- map them to WB IDs
encode benefitingcountry, gen(country_id)
label define country_id 3 "Kenya" 4 "Pakistan" 5 "Senegal", modify
recode country_id (2 = 3)(3 = 4)(4 = 5)
tab country_id

drop notCountry spent2 amount account operatingunit

compress

* Collapse down by category, then check for uniqueness
collapse (mean) spent (sum) spent_total = spent (count) count = spent ///
 if inlist("USAID", agency), ///
 by(fiscalyear category country_id agency)

 * Create a year variable to merge with
ren fiscalyear year
order country_id year
sort country_id category year

* Clean up the variable labels 
la var spent "average disbursement"
la var spent_total "total disbursements"
la var count "number of records"

* Create country + year id variable to enable a proper merge
sort country_id category year
gen loc_time_id = real( string(country_id) + string(year) )

saveold "FA_merge.dta", replace version(12)
