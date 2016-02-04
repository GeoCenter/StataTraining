cd "/Users/laurahughes/GitHub/StataTraining/Day4/Data"

// Since Stata can only deal w/ numbers for a dot graph, we need to encode the data.
encode disease, generate(diseaseCode)

// Import data
use "WHOdata.dta", clear

drop regionNum diseaseCode


replace region = "Asia_Oceania" if region == "Asia/Oceania"
replace region = "Mideast" if region == "Middle East"
replace region = "SEAsia" if region == "S. East Asia"
replace region = "Asia_Oceania" if region == "Asia/Oceania"

reshape wide numdeaths pctDeaths, i(disease) j(region, string)

export excel "WHOdata.xlsx", firstrow(variables) replace
