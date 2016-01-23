cd "/Users/laurahughes/GitHub/StataTraining/Day4/DoFiles/plot pdfs"

sysuse auto, clear


// error bars
collapse (mean) mpg (sd) sdMPG = mpg, by(foreign)
serrbar mpg sdMPG foreign

// better rbar
sysuse sp500, clear
twoway rbar high low date in 15/40, barwidth(.6)


// Random dataset
clear
set seed 25

range id 1 50 50
gen id2 = 2
gen id3 = 3
gen id4 = 4
gen id5 = 5


gen x1 = runiformint(0, 100)

set seed 13
gen y1 = runiformint(0, 100)

set seed 1
gen sign = runiform(-1, 1)

gen y2 = x1 + y1 
gen y3 = id + sign * y1 * 0.2

gen x2 = x1

gen y4 = y1

gen posNeg = sign*y1

gen gauss = rnormal(0, 0.2)

replace y4 = 175 if y4 > 98

gen facet = y1 >= 50

gen yStr = string(y1)

gen y5 = y1/4


gen y6 = y1^2 + sign * y1 * 40


recode id (1 2 3 4 5 6 7 8 9 10 = 1 "A") (11 12 13 14 15 16 17 18 19 20 = 2 "B")/*
*/ (21 22 23 24 25 26 27 28 29 30 = 3 "C") (31 32 33 34 35 36 37 38 39 40 = 4 "D") /*
*/ (41 42 43 44 45 46 47 48 49 50 = 5 "E"), gen(lettStr)


// ------------------------------------------------------------------------------
// Non-twoway
// ------------------------------------------------------------------------------


// bar
gr bar (asis) id in 1/4, over(id, reverse)

// hbar
gr hbar (asis) id in 1/4, over(id)

// box
gr box y4 y2

gr hbox y2 y4

// hist
hist gauss, w(0.2)

// kde
kdensity gauss, w(0.2)

// matrix
gr matrix y1 y2 y4, diag("y1" "y2" "y3")

// dot 
gr dot (mean) y3 in 1/30, over(lettStr)


// ------------------------------------------------------------------------------
// twoway
// ------------------------------------------------------------------------------

// scatter plot 
twoway(scatter y2 x1 in 1/40), play(peachTheme)

graph export "scatter.pdf", as(pdf) replace


// line
twoway(line y3 id in 1/20, sort)

// connected
twoway(connected y3 id in 1/20, sort)

// area
twoway(area y3 id in 9/20, sort)

// rarea
tw rarea y1 y2 id in 20/27, sort

tw rcap y1 y2 id in 20/27, sort
tw rcapsym y1 y2 id in 20/27, sort

// bar
tw bar posNeg y5 in 30/36, vert

// dot
twoway dot posNeg y5 in 44/50, horiz dotext(n)

// dropline
twoway dropline posNeg y5 in 44/50, vert

// pcspike
tw pcspike y1 id2 y3 id3 in 6/10 || pcspike y3 id3 y2 id4 in 6/10 || pcspike y2 id4 y1 id5 in 6/10

tw pccapsym y1 id2 y2 id3 in 7/9

// contour
tw contour y1 y2 y3, level(15) crule(intensity) ecolor("235 205 200")

// ------------------------------------------------------------------------------
// Fitting
// ------------------------------------------------------------------------------

tw scatter y1 y6 || lfit y1 y6
tw scatter y1 y6 || qfit y1 y6
tw scatter y1 y6 || lpoly y1 y6 
tw scatter y1 y6 || lowess y1 y6, bw(1)
tw scatter y1 y6 || fpfit y1 y6

tw scatter y1 y6 || mband y1 y6, bands(6)
tw scatter y1 y6 || mspline y1 y6, bands(5)

tw lfitci y1 y6, fintensity(inten20) alwidth(none) acolor("216 155 145") clcolor("155 98 89") /*
*/ || scatter y1 y6, msize(vsmall) mcolor("206 130 118")

tw qfitci y1 y6, fintensity(inten20) alwidth(none) acolor("216 155 145") clcolor("155 98 89") /*
*/ || scatter y1 y6, msize(vsmall) mcolor("206 130 118")

tw lpolyci y1 y6, fintensity(inten20) alwidth(none) acolor("216 155 145") clcolor("155 98 89") /*
*/ || scatter y1 y6, msize(vsmall) mcolor("206 130 118")

tw fpfitci y1 y6, fintensity(inten20) alwidth(none) acolor("216 155 145") clcolor("155 98 89") /*
*/ || scatter y1 y6, msize(vsmall) mcolor("206 130 118")

// ------------------------------------------------------------------------------
// Special pkgs.
// ------------------------------------------------------------------------------
