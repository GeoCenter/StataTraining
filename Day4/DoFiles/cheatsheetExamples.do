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

// gap b/w
twoway rarea length headroom price
twoway rbar length headroom price
twoway rcap length headroom price
twoway rcapsym length headroom price

// bar
twoway bar price rep78

// dot
twoway dot mpg rep78, ndots(5)

// dropline
twoway dropline mpg price in 1/5, vert


// pcspike
sysuse nlswide1, clear
 twoway pcspike wage68 ttl_exp68 wage88 ttl_exp88
twoway pccapsym wage68 ttl_exp68 wage88 ttl_exp88
sysuse auto, clear

// contour
twoway contour mpg price weight, level(20) crule(intensity) ecolor(blue)

// --- fitting ----
collapse (mean) mpg (sd) sdMPG = mpg, by(foreign)
serrbar mpg sdMPG foreign

sysuse auto, clear

// lowess
twoway scatter mpg weight || lowess  mpg weight

// lfit
twoway scatter mpg weight || lfit  mpg weight, range(40 .)
twoway lfitci mpg weight, fintensity(inten30) alwidth(none) || scatter mpg weight

// qfit
twoway scatter mpg weight || qfit  mpg weight
twoway qfitci mpg weight, fintensity(inten30) alwidth(none) || scatter mpg weight

// lpoly
twoway scatter mpg weight || lpoly  mpg weight, kernel(cosine)
twoway lpolyci mpg weight, fintensity(inten30) alwidth(none) || scatter mpg weight

// fpfit
twoway scatter mpg weight || fpfit  mpg weight
twoway fpfitci mpg weight, fintensity(inten30) alwidth(none)|| scatter mpg weight

// mband
twoway scatter mpg weight || mband mpg weight
twoway scatter mpg weight || mspline mpg weight
