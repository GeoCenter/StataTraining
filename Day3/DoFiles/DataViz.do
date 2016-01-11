/*-------------------------------------------------------------------------------
# Name:		Visualizing data
# Purpose:	Discuss basic data visualization principles and why they are important
# Author:	Tim Essam, Ph.D.
# Created:	2015/12/28
# Owner:	Tim Essam - USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	see below
#-------------------------------------------------------------------------------
*/

clear
capture log close

cd "$pathin/Day2/Data"
log using "DataViz.log", replace

* Introduce visualization types and show resources. Talk about imporantance
* of visualizing data (https://en.wikipedia.org/wiki/Anscombe%27s_quartet).

clear all
input x1	y1	x2	y2	x3	y3	x4	y4
10.0	8.04	10.0	9.14	10.0	7.46	8.0	6.58
8.0	6.95	8.0	8.14	8.0	6.77	8.0	5.76
13.0	7.58	13.0	8.74	13.0	12.74	8.0	7.71
9.0	8.81	9.0	8.77	9.0	7.11	8.0	8.84
11.0	8.33	11.0	9.26	11.0	7.81	8.0	8.47
14.0	9.96	14.0	8.10	14.0	8.84	8.0	7.04
6.0	7.24	6.0	6.13	6.0	6.08	8.0	5.25
4.0	4.26	4.0	3.10	4.0	5.39	19.0	12.50
12.0	10.84	12.0	9.13	12.0	8.15	8.0	5.56
7.0	4.82	7.0	7.26	7.0	6.42	8.0	7.91
5.0	5.68	5.0	4.74	5.0	5.73	8.0	6.89
end
saveold "quartet.dta", replace version(12)

 * What are the means for each data set?
 sum x* 
 sum y*
 
 * Show the correlations between x & y for each series
 forvalues i = 1/4 {
	pwcorr x`i' y`i'
	twoway(scatter y`i' x`i')(lfit y`i' x`i'), scheme(s1color) /*
	*/ name(series`i', replace) nodraw
	}
* end

* Combine the graphs into a single plot
graph combine series1 series2 series3 series4, cols(2) ycommon xcommon 

* What is going on?
* Series one is linear relationship, appears to be normally distributed
* Series two nonlinear
* Series three has one outlier
* series four has an extreme outlier that drives results

* PLOT YOUR DATA!
stem x4
inspect 

* Good function for doing just that: binscatter
binscatter y4 x4

*tddens can do heatmaps
tddens y4 x4
