// -----------
// Examples for sheet

sysuse auto, clear


// Categorical barplot
graph bar (count), over(foreign) intensity(*0.5)

graph hbar (median) price, over(foreign)

// dot

graph dot (median) length headroom, over(foreign) marker(1, msymbol(S)) linetype(line)


// Box plot
graph box price, over(foreign) medtype(marker) medmarker(msymbol(Dh))
graph hbox mpg, over(rep78, descending) by(foreign) missing 

// histogram
histogram mpg, width(5) frequency kdensity kdenopts(bwidth(5))

// KDE
kdensity mpg, width(3)

// Matrix
gr matrix price mpg weight

// Lowess



// --- twoway -----------------------------------------------------------------
// Scatter
scatter mpg price

// Line/connected
twoway connected mpg price, sort(price) msymbol(x)

twoway line mpg price, sort(price) lpattern(longdash_dot)

// area
twoway area mpg price, sort(price) cmissing(yes)

// bar
twoway bar price rep78

// dot
twoway dot mpg rep78, ndots(5)

// dropline
twoway dropline mpg price in 1/5, vert

// lowess
twoway scatter mpg weight || lowess  mpg weight

// lfit
twoway scatter mpg weight || lfit  mpg weight, range(40 .)

// qfit

twoway scatter mpg weight || qfit  mpg weight

// lpoly
twoway scatter mpg weight || lpoly  mpg weight, kernel(cosine)

// fpfit
twoway scatter mpg weight || fpfit  mpg weight
