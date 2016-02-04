cd "/Users/laurahughes/GitHub/StataTraining/Day4/Data"


// Import data
use "WHOdata.dta"


/*
Dot plot (also known as lollipop plot)
*/

// Since Stata can only deal w/ numbers for a dot graph, we need to encode the data.
encode disease, generate(diseaseCode)

twoway dropline  pctDeaths diseaseCode

// Whoops... that's not right. Gotta flip where the line goes.
* twoway dropline regionNum pctDeaths // Right axes... wrong lines
twoway dropline pctDeaths diseaseCode, horizontal 

// Fix the labels so we can see the name of the disease.

// Split into small multiples
twoway dropline pctDeaths diseaseCode, horizontal by(region)

// Remove "total" category
twoway dropline pctDeaths diseaseCode , horizontal by(region)

// Re-sort the regions by most deaths


// Reorder the disease by most common to least

// Scale the size of the dot to be proportional to the total number of deaths.
twoway dropline pctDeaths diseaseCode if region != "total" [fw = numdeaths], horizontal by(region)

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


// Save


// Clean up the appearance

// Remove background colors
// Change grid line color and thickness
// Shrink size of axis labels so they fit better.
// Dull the color of the axis labels
// Add axis titles

// Change the color of everything to be light grey.

// Highlight the pneumonia bar.
graph bar (sum) numdeaths if disease == "Pneumonia", over(disease, sort(1) descending) allcategories bar(1, color(red)) saving("deathsPneu.gph")



// Total deaths by region
graph bar (sum) numdeaths, over(region)
