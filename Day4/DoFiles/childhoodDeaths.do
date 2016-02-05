/*
Graphs using the estimated data from a WHO graphic on childhood deaths that could 
use a refresh.
http://www.who.int/bulletin/volumes/86/5/07-048769/en/


Data is pulled from the graph, so subject to rounding errors.
*/

cd "/Users/laurahughes/GitHub/StataTraining/Day4/Data"


// Import data
use "WHOdata.dta", clear




/*
Simple, clean bar graph 
*/

// Total deaths by disease
graph bar numdeaths, over(disease)

// But I don't want the mean deaths... I want the total (sum) deaths.
graph bar (sum) numdeaths, over(disease)

// Sort to clearer
graph bar (sum) numdeaths, over(disease, sort(1))

// Reverse the axis
graph bar (sum) numdeaths, over(disease, sort(1) descending)


// Clean up the appearance
// Note: can also edit in the graph editor.

// Remove background colors
graph bar (sum) numdeaths, over(disease, sort(1) descending)  /*
*/ graphregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ plotregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white"))
 

// Change grid line color and thickness
graph bar (sum) numdeaths, over(disease, sort(1) descending) /*
*/ graphregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ plotregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ ylabel(,glcolor("175 175 175") glwidth(vthin)) 

// Shrink size of axis labels so they fit better.
graph bar (sum) numdeaths, over(disease, sort(1) descending label(labsize(vsmall))) /*
*/ graphregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ plotregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ ylabel(,glcolor("175 175 175") glwidth(vthin))

// Remove y-axis and add numeric labels
graph bar (sum) numdeaths, over(disease, sort(1) descending label(labsize(vsmall))) /*
*/ graphregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ plotregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ ylabel(,glcolor("175 175 175") glwidth(vthin)) blabel(bar)

graph bar (sum) numdeaths, over(disease, sort(1) descending label(labsize(vsmall))) /*
*/ graphregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ plotregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ ylabel(,glcolor("175 175 175") glwidth(vthin)) blabel(bar, format(%9.1f))

graph bar (sum) numdeaths, over(disease, sort(1) descending label(labsize(vsmall))) /*
*/ graphregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ plotregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ ylabel(,glcolor("175 175 175") glwidth(vthin)) blabel(bar, format(%9.1f)) yscale(off)

// Dull all the colors of fonts
graph bar (sum) numdeaths, over(disease, sort(1) descending label(labsize(vsmall))) /*
*/ graphregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ plotregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ ylabel(,glcolor("175 175 175") glwidth(vthin)) yscale(off) /*
*/ blabel(bar, format(%9.1f) color("155 155 155"))

graph bar (sum) numdeaths, over(disease, sort(1) descending label(labsize(vsmall) labcolor("175 175 175"))) /*
*/ graphregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ plotregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ ylabel(,glcolor("175 175 175") glwidth(vthin)) yscale(off) /*
*/ blabel(bar, format(%9.1f) color("155 155 155"))


// Add in an annotation for the y-axis label
graph bar (sum) numdeaths, over(disease, sort(1) descending label(labsize(vsmall) labcolor("175 175 175"))) /*
*/ graphregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ plotregion(fcolor("white") ifcolor("white") lcolor("white") ilcolor("white")) /*
*/ ylabel(,glcolor("175 175 175") glwidth(vthin)) yscale(off) /*
*/ blabel(bar, format(%9.1f) color("155 155 155")) /*
*/ text(4.0 25 "million deaths worldwide", color("155 155 155"))



/*
Dot plot (also known as lollipop plot)
*/


twoway dropline  pctDeaths diseaseCode

// Whoops... that's not right. Gotta flip where the line goes.
* twoway dropline regionNum pctDeaths // Right axes... wrong lines
twoway dropline pctDeaths diseaseCode, horizontal 

// Fix the labels so we can see the name of the disease.
gsort numdeaths

// Split into small multiples
twoway dropline pctDeaths diseaseCode, horizontal by(regionNum)


// Add in value labels to the y-axis
twoway dropline pctDeaths diseaseCode, horizontal by(regionNum) ylabel(1/8, valuelabel angle(0))


// Re-sort the regions by most deaths-- requires to generate a new variable to help sort
ssc install egenmore
egen totDeaths = sum(numdeaths), by(regionNum)
egen regionNum2 = axis(totDeaths regionNum), label(regionNum) reverse

twoway dropline pctDeaths diseaseCode, horizontal by(regionNum2) /*
*/ ylabel(1/8, valuelabel angle(0))


// Reorder the disease by most common to least-- similar to what had to do w/ regions.
egen totDeaths_disease = sum(numdeaths), by(diseaseCode)
egen diseaseCode2 = axis(totDeaths_disease diseaseCode), label(diseaseCode)

twoway dropline pctDeaths diseaseCode2, horizontal by(regionNum2) /*
*/ ylabel(1/8, valuelabel angle(0))


// AND time to clean up... use the graph editor if you like, or try specifying everything in a scheme.
