cd "C:\Users\Tim\Documents\GitHub\StataTraining\"
use "Rwanda_EICV3.dta", clear

* Let's rename some variables, these names are too long for me.
ren (services industry agriculture gdppercapita_rw gdppercapita_br)(srv ind ag gdpPC_rw gdpPC_br)

* Basic plot
twoway (connected srv year, sort)(connected ag year, sort)(connected ind year, sort) /*
*/ , scheme(s1color)

* Plot GDP figures
twoway(connected gdpPC_rw year, sort)(connected gdpPC_br year, sort), scheme(s1color)

* Let's make a solid box for the global recession (appx 2007 - 2009)
sum srv
g maxval_output = `r(max)'
g rhgt_output =  `r(max)' if inlist(year, 2007, 2008, 2009)

sum gdpPC_rw
g maxval_gdp = `r(max)'
g rhgt_gdp =  `r(max)' if inlist(year, 2007, 2008, 2009)

* Let's also filter the data so we can add labels for the first and last years only
foreach x of varlist srv ind ag gdpPC_rw gdpPC_br {
	g mkr_`x' = "$" + strofreal(`x') if inlist(year, 2001, 2014)
	*tostring mkr_`x', replace
	*replace mkr_`x' = "" if mkr_`x' == "."
	}
*

gen mkr_gdpPC_rw2 = "Rwanda" if inlist(year, 2014)
gen mkr_gdpPC_br2 = "Burundi" if inlist(year, 2014)

* Set up globals for plots
global rwColor ""0 163 224""
global brColor ""222 45 38""
global labclrs ""150 150 150""
global white ""255 255 255""

* Plot GDP figures
twoway (area rhgt_output year, bcolor(gs15))(connected srv year, sort)(connected ag year, sort)/*
*/(connected ind year, sort), scheme(s1color)

twoway(area rhgt_gdp year, bcolor(gs15)) /*
*/(scatter gdpPC_br year if inlist(year, 2001, 2014), mlabel(mkr_gdpPC_br2) mlabp(6) mlabc($brColor) color($brColor)) /*
*/(scatter gdpPC_rw year if inlist(year, 2001, 2014), mlabel(mkr_gdpPC_rw2) mlabp(6) mlabc($rwColor) color($rwColor)) /*
*/(connected gdpPC_rw year, mlabgap(2) mlabel(mkr_gdpPC_rw) msize(zero) mlabp(12) mlabc($rwColor) color($rwColor) sort )/*
*/(connected gdpPC_br year,  mlabgap(2) mlabel(mkr_gdpPC_br) msize(zero) mlabp(12) mlabc($brColor) color($brColor) sort)/*
*/, legend(off) xlabel(2001(2)2015) xscale(lcolor($labclrs)) yscale(noline) /*
*/ ylabel(, angle(horizontal) labcolor($labclrs) tlcolor($white) nogrid nolabels) /*
*/ xlabel(, labcolor($labclrs) tlcolor($labclrs)) /*
*/ graphregion(fcolor($white))  xtitle("") 
/* ///remove grid lines/// 
*/ 




* Create percentage change variables
* Time-series set data frame so we can use lag/lead operators for calculations
tsset year 

gen services = (srv - L.srv) / L.srv
gen industry = (ind - L.ind) / L.ind
gen agriculture = (ag - L.ag) / L.ag
gen GDPpc = (gdpPC_rw - L.gdpPC_rw) / L.gdpPC_rw


* Convert the variables to a matrix so we can plot as a heatmap
format services industry agriculture GDPpc %9.2f
mkmat  services industry agriculture GDPpc if year!=2001, matrix(A)
matrix htmap = A'

* Use the plotmatrix package + a .grec file to make a heatmap. This is not as pretty as we can make in excel or R.
plotmatrix, mat(htmap) legend(off) c(ebblue) freq formatcells(%9.2f)/*
*/ aspect(0.4) ylabel(,angle(0)) xscale(alt) addbox(1 8 4 8) play(heatmap_rw) title("test") 

