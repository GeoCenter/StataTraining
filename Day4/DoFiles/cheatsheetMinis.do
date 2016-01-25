cd "/Users/laurahughes/GitHub/StataTraining/Day4/DoFiles/plot pdfs"

adopath ++ "~/Documents/USAID/StataThemes"
 set scheme cheatsheet
 
sysuse auto, clear


// error bars
collapse (mean) mpg (sd) sdMPG = mpg, by(foreign)
serrbar mpg sdMPG foreign, lw(thick) xscale(range(-1 2)) yscale(range(5 30)) xlabel(, nogrid) ylabel(, nogrid) 

graph export "errbars.pdf", as(pdf) replace

// better rbar
sysuse sp500, clear
twoway rbar high low date in 15/30, barwidth(.8)
graph export "rbars.pdf", as(pdf) replace

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

gen y7 = runiformint(80, 100)
gen y8 = runiformint(30, 65)

gen y9 = round(y5, 1)

recode id (1 2 3 4 5 6 7 8 9 10 = 1 "A") (11 12 13 14 15 16 17 18 19 20 = 2 "B")/*
*/ (21 22 23 24 25 26 27 28 29 30 = 3 "C") (31 32 33 34 35 36 37 38 39 40 = 4 "D") /*
*/ (41 42 43 44 45 46 47 48 49 50 = 5 "E"), gen(lettStr)


// ------------------------------------------------------------------------------
// Non-twoway
// ------------------------------------------------------------------------------


// bar
gr bar (asis) id in 1/4, over(id, reverse)
graph export "bars.pdf", as(pdf) replace



// hbar
gr hbar (asis) id in 1/4, over(id)
graph export "hbars.pdf", as(pdf) replace

// box
gr box y4 y2, inten(*0.4)
graph export "box.pdf", as(pdf) replace 

gr hbox y2 y4, inten(*0.4) m(2, m(O))
graph export "hbox.pdf", as(pdf) replace

vioplot y2 y4, line(lw(medthick)) bar(lw(medthick)) median(mlw(medthick)) yscale(range(-25 200)) xlabel(, nogrid) 
graph export "violin.pdf", as(pdf) replace

// hist
hist gauss, w(0.2) xlabel(, nogrid)
graph export "hist.pdf", as(pdf) replace

// kde
kdensity gauss, w(0.2) 
graph export "kde.pdf", as(pdf) replace

// matrix
gr matrix y1 y2 y4, diag("y1" "y2" "y3") scheme(cheatsheet)
graph export "matrix.pdf", as(pdf) replace


// dot 
gr dot (mean) y3 in 1/30, over(lettStr) scheme(cheatsheet) ndots(20)
graph export "dotCat.pdf", as(pdf) replace


// ------------------------------------------------------------------------------
// twoway
// ------------------------------------------------------------------------------

// scatter plot 
twoway(scatter y2 x1 in 1/40)
graph export "scatter.pdf", as(pdf) replace

tw scatter y2 y1 [aw = y5], msize(tiny) scheme(cheatsheet)
graph export "bubble.pdf", as(pdf) replace


tw scatter y6 y2 in 26/30, mlabel(y9) scheme(cheatsheet)
graph export "labels.pdf", as(pdf) replace

// line
twoway(line y3 id in 1/20, sort)
graph export "line.pdf", as(pdf) replace

// connected
twoway(connected y3 id in 1/20, sort), scheme(cheatsheet)
graph export "conn.pdf", as(pdf) replace

// area
twoway(area y3 id in 9/20, sort)
graph export "area.pdf", as(pdf) replace

// rarea
tw rarea y1 y2 id in 20/27, sort lw(medthick)
graph export "rarea.pdf", as(pdf) replace

tw rcap y1 y2 id in 20/27, sort
graph export "rcap.pdf", as(pdf) replace

tw rcapsym y1 y2 id in 20/27, sort lc("216 155 145")
graph export "rcapsym.pdf", as(pdf) replace

// bar
tw bar posNeg y5 in 30/36, vert
graph export "twbar.pdf", as(pdf) replace

// dot
twoway dot posNeg y5 in 44/50, horiz dotext(n) ndots(25) scheme(cheatsheet)
graph export "twdot.pdf", as(pdf) replace

// dropline
twoway dropline posNeg y5 in 44/50, vert lc("216 155 145")
graph export "drop.pdf", as(pdf) replace

// pcspike
tw pcspike y1 id2 y3 id3 in 6/10, lw(medthick) xlabel(, nogrid) ylabel(, nogrid)  || pcspike y3 id3 y2 id4 in 6/10, lw(medthick) lc("206 130 118")|| pcspike y2 id4 y1 id5 in 6/10, lw(medthick) lc("206 130 118")
graph export "pc.pdf", as(pdf) replace

tw pccapsym y1 id2 y2 id3 in 7/9, lc("216 155 145") xlabel(, nogrid) ylabel(, nogrid) 
graph export "bump.pdf", as(pdf) replace

// contour
tw contour y1 y2 y3, level(8) crule(intensity) ecolor("235 205 200") xlabel(, nogrid) ylabel(, nogrid) scheme(cheatsheet)
graph export "contour.pdf", as(pdf) replace

// ------------------------------------------------------------------------------
// Fitting
// ------------------------------------------------------------------------------

tw scatter y1 y6, msize(medsmall) mcolor("226 180 173")|| lfit y1 y6, scheme(cheatsheet)
graph export "lfit.pdf", as(pdf) replace

tw scatter y1 y6, msize(medsmall) mcolor("226 180 173")|| qfit y1 y6
graph export "qfit.pdf", as(pdf) replace

tw scatter y1 y6, msize(medsmall) mcolor("226 180 173")|| lpoly y1 y6 
graph export "lpoly.pdf", as(pdf) replace

tw scatter y1 y6, msize(medsmall) mcolor("226 180 173")|| lowess y1 y6, bw(1)
graph export "lowess.pdf", as(pdf) replace

tw scatter y1 y6, msize(medsmall) mcolor("226 180 173")|| fpfit y1 y6
graph export "fpfit.pdf", as(pdf) replace

tw scatter y1 y6, msize(medsmall) mcolor("226 180 173")|| mband y1 y6, bands(6) scheme(cheatsheet)
graph export "mband.pdf", as(pdf) replace

tw scatter y1 y6, msize(medsmall) mcolor("226 180 173")|| mspline y1 y6, bands(5)
graph export "mspline.pdf", as(pdf) replace

tw lfitci y1 y6, fintensity(inten20) alwidth(none) /*
*/ || scatter y1 y6, msize(medsmall) mcolor("226 180 173") m(O) scheme(cheatsheet)
graph export "lfitci.pdf", as(pdf) replace

tw qfitci y1 y6, fintensity(inten20) alwidth(none) /*
*/ || scatter y1 y6, msize(medsmall) mcolor("226 180 173") m(O) scheme(cheatsheet)
graph export "qfitci.pdf", as(pdf) replace

tw lpolyci y1 y6, fintensity(inten20) alwidth(none) /*
*/ || scatter y1 y6, msize(medsmall) mcolor("226 180 173") m(O) scheme(cheatsheet)
graph export "lpolyci.pdf", as(pdf) replace

tw fpfitci y1 y6, fintensity(inten20) alwidth(none) /*
*/ || scatter y1 y6, msize(medsmall) mcolor("226 180 173") m(O) scheme(cheatsheet)
graph export "fpfitci.pdf", as(pdf) replace

// ------------------------------------------------------------------------------
// Special pkgs.
// ------------------------------------------------------------------------------

// Facet
scatter y7 id
// Superimpose


line y7 y8 id in 1/20, sort scheme(cheatsheet)

graph export "facet.pdf", as(pdf) replace

