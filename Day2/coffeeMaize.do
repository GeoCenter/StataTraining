// Create a random example table
// Laura Hughes, 9 January 2016, lhughes@usaid.gov


// Set seed
set seed 25

// Create some random data
clear all
input str6 country	coffee2011 coffee2012 maize2011 maize2012
"Malawi"	5.93	2.40	7.32	8.95
"Uganda" 	3.09	4.26	8.65	9.83
"Rwanda" 	7.35	3.23	9.53	1.14
end
saveold "coffeeMaize.dta", replace version(12)


// Second dataset for appending
// Create some random data
clear all
input str6 country	coffee2011 coffee2012 maize2011 maize2012
"Kenya"		1.79	6.65	4.75	0.34
end
saveold "coffeeMaize2.dta", replace version(12)

