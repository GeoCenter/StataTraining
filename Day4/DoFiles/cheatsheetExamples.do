// -----------
// Examples for sheet

sysuse auto, clear


// Categorical barplot
graph bar (count), over(foreign) intensity(*0.5)

graph hbar (median) price, over(foreign)


// Box plot
graph box price, over(foreign) medtype(marker) medmarker(msymbol(Dh))
graph hbox mpg, over(rep78, descending) by(foreign) missing 

// histogram
histogram mpg, width(5) frequency kdensity kdenopts(bwidth(5))

// KDE
kdensity mpg, width(3)

// Matrix
gr matrix price mpg weight



// --- twoway -----------------------------------------------------------------
// Scatter
scatter mpg price

// Line/connected
twoway connected mpg price, sort(price) msymbol(x)

twoway line mpg price, sort(price) lpattern(longdash_dot)
