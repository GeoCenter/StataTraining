** FUNDAMENTALS OF DATA ANALYSIS & VISUALIZATIONS
** DAY 1
**
** DEMONTRATE AUTOMATION OF REPETITIVE TASKS
** AUTHOR: AARON CHAFETZ

// Example 1: Constantly removing rows and columns to save space //

/* Background:
	I've developed an Excel visualization tool to look at various 
	pediatrics indicators related to HIV/AIDS pulled from DATIM.org
	on a quarterly basis. With lots of indicators for each country 
	at the implementing mechanism level, I need to free up some space.
	To do so, I constantly need to remove data from unnessary columns
	as well as any rows where the indicator value equals zero. Automating
	this task takes a lot less time */
	
* set directory
	global pathin "/Users/Aaron/Desktop/StataTraining/Day1/Data/"
	cd $pathin
* import csv file
	insheet using "PEPFAR-Data-Genie-MER-2015-12-19.csv"
* replace value in unnecessary columns
* create local variable for all variables to keep
 	local keepvlist operatingunit period dataelementname ///
		disaggregate categoryoptioncomboname resulttarget ///
		value orglevel4name orglevel5name orglevel6name ///
		orglevel7name orglevel8name fundingagency 
* identify variables to remove values
	ds `keepvlist', not
* string variables for replacing value purposes
	tostring `r(varlist)', replace
* identify full list again
	ds `keepvlist', not
/* use loop over each column to remove values (could just delete columns, want
 	but want to keep list of all colmns */
	foreach v in `r(varlist)'{
		replace `v'= ""
	}
	*end
* remove rows with zero value
	drop if value==0
* export to csv
	outsheet using "PEPFAR-Data-Genie-MER-2015-12-19_clean.csv", comma

// Example 2: Labeling a scatter plot //

/* Background:
	One frustration working in Excel is the inability to easily
	label points on a scatter plot. This must be done manually since
	the labeling options are to label with the data series, x value, or
	y value. This process is easily automated in Stata */

* set directory
	global pathin "/Users/Aaron/Desktop/StataTraining/Day1/Examples"
	cd $pathin
/*
* import metadata
	import excel using wdi_gdp.xls, sheet("Metadata - Countries") firstrow clear
	drop SpecialNotes //not used
	save ctrymetadata.dta, replace
*covert data to Stata (.dta) file
	foreach x in gdp aids {
		import excel using wdi_`x'.xls, sheet("Data") cellrange(A4:BH252) firstrow clear
		save `x'.dta, replace
	}
	*end
*open one of the datasets
	use aids.dta, clear
*append two datasets together
	append using gdp.dta
*relabel year variables (can't label starting with number)
	foreach year of var E-BH{
		local l`year' : variable label `year'		rename `year' y`l`year''
		}
*merge w/ country meta data
	merge m:1 CountryCode using ctrymetadata.dta, nogen
*drop a variable
	drop IndicatorCode
*rename for ease
	rename (CountryName IndicatorName CountryCode) (ccode vcode iso)
*encode
	encode Region, gen(reg)
	encode IncomeGroup, gen(inc)
	drop Region IncomeGroup
	lab var inc "WB Income Group (2015)"
	order reg inc, after(vcode)
*reshape dataset from long to wide for use in Stata
	reshape long y, i(ccode vcode) j(year)
	rename y data
*econde string variable
	encode vcode, gen(type)
*save labels for applying after reshape
*label save type using vardesc //edit dofile to lab var data[1] "[GDP]"
	drop vcode
*reshape again this time wide so the types are both variables
	reshape wide data, i(ccode year) j(type)
*label variables
	rename data1 gdp
		label var gdp "GDP, PPP (constant 2011 international $)"
		format gdp %16.0fc
	rename data2 hiv
		label var hiv "Prevalence of HIV, total (% of population ages 15-49)"
*generate GDP in billions variab;e
	gen gdp_b = gdp/1000000000
	lab var gdp_b "GDP in billions, PPP (constant 2011 international $)"
*export data to excel
	*export excel using "hivgdp.xlsx" if year==2014 & reg ==7, firstrow(variables) replace
*save 
	save hivgdp.dta, replace
*/
	
*open dataset
	use hivgdp.dta, clear
*initial scatter plot
	scatter gdp_b hiv if year==2014 & reg ==7
* sort 
	sort gdp
	list ccode gdp if year==2014 & reg==7
*second scatter 
 	scatter gdp_b hiv if year==2014 & reg ==7 ///
 		& ccode!="South Africa" & ccode!="Nigeria"	
*create a label for the points of interest
	gen mlab = iso if hiv>10
		lab var mlab "Marker Labels (HIV prev >10%)
*scatter
	scatter gdp_b hiv ///
		if year==2014 & reg ==7 & ccode!="South Africa" & ccode!="Nigeria", ///
		mlabel(mlab) ///
		title("HIV Prevalence v GDP") sub("Southern Africa 2014") ///
		note("Excludes South Africa and Nigeria" "Source: World Bank WDI")

