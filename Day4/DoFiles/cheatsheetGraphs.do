/* 
Graphs to serve as examples for the Stata Visualization cheatsheet

Laura Hughes, lhughes@usaid.gov, 19 January 2016
*/


/*
1. Generate fake data
2. Log transform
3. Plot

*/

clear
set seed 25

range id 1 50 50


gen x1 = runiformint(0, 100)

set seed 13
gen y1 = runiformint(0, 100)

set seed 1
gen sign = runiform(-1, 1)

gen y2 = x1 + y1 
gen y3 = id + sign * y1 * 0.2
gen x2 = x1

gen y4 = y1

gen gauss = rnormal(0, 0.2)

replace y4 = 175 if y4 > 98

gen facet = y1 >= 50

gen yStr = string(y1)



// big example showing the different parts of plot -----------------------------
graph twoway scatter y2 x1 in 1/40 || (scatter y2 x1 in 1/10, mlabel(id) m(i)) ||/*
*/ lfit y2 y1, /*
*/ title("title") subtitle("subtitle") xtitle("x-axis label") ytitle("y-axis label") play(plotLayout)

graph export "plotAreas.pdf", as(pdf) replace


// Examples for Cheatsheet ----------------------------------------------------------
graph twoway scatter y1 x1 || line y3 y2 x2 in 1/25 if y2 > 30, /*
*/ by(facet, note("")) xline(40) /*
*/ yline(50) xscale(range(-10 110)) yscale(range(-50 50)) legend(off) /*
*/ title("title") subtitle("subtitle") text(10 10 "annotation")/*
*/ xtitle("x-axis label") ytitle("y axis label") scheme(s1mono) saving("StataGraph.gph", replace)

//graph export "myPlot.pdf", as(pdf)

sysuse auto, clear

// Showing all the twoway options. ---------------------------------------------
graph twoway scatter mpg price in 27/74 || (scatter mpg price if mpg < 15  & price > 12000 in 27/74, mlabel(make) m(i)), by(foreign, note("")) /*
*/ xscale(range(0 20000)) yscale(range(10 40)) xline(12000) yline(15) /*
*/ title("title") subtitle("subtitle") xtitle("x-axis label") ytitle("y-axis label") text(20 12000 "expensive cars have bad fuel efficiency")  legend(cols(1)) scheme(s1mono) saving("StataGraph.gph", replace)

graph export "twowayopts.pdf", as(pdf) replace


// Showing markers and marker sizes. -------------------------------------------
clear

// Being lazy since I don't feel like figuring out looping w/ plotting...
range x 1 2 2
gen y1 = 1
gen y2 = 2
gen y3 = 3
gen y4 = 4
gen y5 = 5
gen y6 = 6
gen y7 = 7
gen y8 = 8
gen y9 = 9
gen y10 = 10
gen y11 = 11
gen y12 = 12
gen y13 = 13
gen y14 = 14
gen labStr = "size"

palette symbolpalette

graph query markersizestyle
// ehuge     large     medlarge  small     vhuge     vsmall    zero
//    huge      medium    medsmall  tiny      vlarge    vtiny
	
// Marker size
scatter y1 x, msize(ehuge) mlw(none) || scatter y4 x, msize(vlarge) mlw(none)|| scatter y5 x, msize(large) mlw(none)|| scatter y6 x, msize(medlarge) mlw(none)|| /*
*/ scatter y7 x, msize(medium) mlw(none)|| scatter y2 x, msize(vhuge) mlw(none) || scatter y8 x, msize(medsmall) mlw(none)|| scatter y3 x, msize(huge) mlw(none)|| /*
*/ scatter y11 x, msize(tiny) mlw(none)|| scatter y9 x, msize(small) mlw(none)|| scatter y10 x, msize(vsmall) mlw(none) || scatter y12 x, msize(vtiny) mlw(none) || scatter y13 x, msize(zero) mlw(none)
	
	 graph query linewidthstyle
	 
//	 medium    medthin   thick     vthick    vvthick   vvvthick
//    medthick  none      thin      vthin     vvthin    vvvthin

line y1 x, lw(vvvthin) || line y2 x, lw(vvthin) || line y3 x, lw(vthin) || /*
*/ line y4 x, lw(thin) || line y5 x, lw(medthin) || line y6 x, lw(medium) || /*
*/ line y7 x, lw(medthick) || line y8 x, lw(thick) || line y9 x, lw(vthick) || line y10 x, lw(vvthick) || line y11 x, lw(vvvthick)
	 
	 graph export "lineWidth.pdf", as(pdf) replace

	 palette linepalette 

	 
	 scatter y1 x, mcolor("emerald") mlcolor(lime)
	 
	 
scatter y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 x, m(i i i i i i i i i i i i i i) mlabel(labStr labStr labStr labStr labStr labStr labStr labStr labStr labStr labStr labStr labStr labStr) /*
*/ mlabsize(minuscule quarter_tiny  third_tiny half_tiny tiny vsmall small medsmall medium medlarge large vlarge huge vhuge) mlabc(red red red red red red red red red red red red red red) 
	 graph export "labelSize.pdf", as(pdf) replace
