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
graph bar (sum) numdeaths, over(disease, sort(1) descending) saving("deathsByDisease.gph")



// Clean up the appearance

// Remove background colors
graph bar (sum) numdeaths, over(disease, sort(1) descending) saving("deathsByDisease.gph") /*
*/ graphregion(fcolor("white") ifcolor("white")) plotregion(fcolor("white") ifcolor("white")) 

// Change grid line color and thickness
graph bar (sum) numdeaths, over(disease, sort(1) descending) /*
*/ graphregion(fcolor("white") ifcolor("white")) plotregion(fcolor("white") ifcolor("white")) /*
*/

// Shrink size of axis labels so they fit better.
// Dull the color of the axis labels
// Add axis titles

// Change the color of everything to be light grey.

// To highlight the pneumonia bar... gets a little tricky.  We actually need to change it to be a twoway
graph bar (sum) numdeaths if disease == "Pneumonia", over(disease, sort(1) descending) allcategories bar(1, color(red))




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


// Add in value labels
twoway dropline pctDeaths diseaseCode, horizontal by(regionNum) ylabel(, valuelabel angle(0) tlength(8))

scatter pctDeaths diseaseCode
// Re-sort the regions by most deaths

ssc install 
egen

twoway dropline pctDeaths diseaseCode, horizontal by(regionNum)



// Reorder the disease by most common to least

